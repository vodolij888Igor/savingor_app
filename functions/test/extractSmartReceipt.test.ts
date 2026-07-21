import { describe, expect, it, vi } from "vitest";

import type {
  ModelReceiptInput,
  QuotaReservation,
  ReceiptExtractionModel,
  SmartReceiptQuotaManager,
} from "../src/contract";
import { handleExtractSmartReceipt } from "../src/extractSmartReceipt";
import {
  ModelRefusalError,
  ModelResponseError,
} from "../src/openaiReceiptModel";
import { RateLimitExceededError } from "../src/rateLimit";
import { validReceipt, validRequestData } from "./fixtures";

const NOW = new Date("2026-06-20T12:00:00.000Z");
const RESERVATION: QuotaReservation = {
  reservationId: "reservation-1",
  reservedDayKey: "2026-06-20",
  userDocumentPath: "smartReceiptRateLimits/user_20260620",
  projectDocumentPath: "smartReceiptProjectBudgets/20260620",
};

function quotaManager(): SmartReceiptQuotaManager {
  return {
    reserve: vi.fn(async () => RESERVATION),
    finalize: vi.fn(async () => undefined),
    release: vi.fn(async () => undefined),
  };
}

function dependencies(
  model: ReceiptExtractionModel = {
    extract: vi.fn(async () => validReceipt()),
  },
  quota: SmartReceiptQuotaManager = quotaManager(),
) {
  return { model, quotaManager: quota, clock: () => NOW };
}

describe("handleExtractSmartReceipt", () => {
  it("requires Firebase Authentication before doing any work", async () => {
    const deps = dependencies();

    await expect(
      handleExtractSmartReceipt({ data: validRequestData() }, deps),
    ).rejects.toMatchObject({ code: "unauthenticated" });
    expect(deps.model.extract).not.toHaveBeenCalled();
    expect(deps.quotaManager.reserve).not.toHaveBeenCalled();
  });

  it("recursively redacts OCR and candidate strings without changing numbers", async () => {
    let modelInput: ModelReceiptInput | undefined;
    const model: ReceiptExtractionModel = {
      extract: vi.fn(async (input: ModelReceiptInput) => {
        modelInput = input;
        return validReceipt();
      }),
    };
    const data = validRequestData();
    data.rawOcrText = "Email buyer@example.com\nVISA **** 4242\nTotal 11.30";
    data.parserCandidate = {
      ...(data.parserCandidate as Record<string, unknown>),
      storeName: "Call +44 20 7946 0958",
      subtotal: 10,
      tax: 1.3,
      total: 11.3,
      items: [
        {
          name: "Milk loyalty ID MEMBER-9988",
          quantity: 2,
          unit: "ea",
          unitPrice: 5,
          totalPrice: 10,
          category: "Dairy ref: CAT-1234",
        },
      ],
    };

    const result = await handleExtractSmartReceipt(
      { data, auth: { uid: "user-1" } },
      dependencies(model),
    );

    const serialized = JSON.stringify(modelInput);
    expect(serialized).not.toContain("buyer@example.com");
    expect(serialized).not.toContain("4242");
    expect(serialized).not.toContain("7946 0958");
    expect(serialized).not.toContain("MEMBER-9988");
    expect(serialized).not.toContain("CAT-1234");
    expect(modelInput?.rawOcrText).toContain("11.30");
    expect(modelInput?.parserCandidate).toMatchObject({
      subtotal: 10,
      tax: 1.3,
      total: 11.3,
      items: [{ quantity: 2, unitPrice: 5, totalPrice: 10 }],
    });
    expect(result.receipt.warningCodes).toContain("IDENTIFIERS_REDACTED");
    expect(result.processing).toEqual({
      schemaVersion: "1",
      model: "gpt-5.6-sol",
      appCheckVerified: false,
    });
  });

  it("finalizes a reservation only after validated output", async () => {
    const quota = quotaManager();

    await handleExtractSmartReceipt(
      { data: validRequestData(), auth: { uid: "user-1" } },
      dependencies(undefined, quota),
    );

    expect(quota.reserve).toHaveBeenCalledOnce();
    expect(quota.finalize).toHaveBeenCalledWith(RESERVATION);
    expect(quota.release).not.toHaveBeenCalled();
  });

  it("reports verified App Check context without enforcing it yet", async () => {
    const result = await handleExtractSmartReceipt(
      {
        data: validRequestData(),
        auth: { uid: "user-1" },
        app: { appId: "x" },
      },
      dependencies(),
    );

    expect(result.processing.appCheckVerified).toBe(true);
  });

  it("maps rate-limit failures without creating a reservation", async () => {
    const quota = quotaManager();
    vi.mocked(quota.reserve).mockRejectedValue(
      new RateLimitExceededError("minute", 20),
    );

    await expect(
      handleExtractSmartReceipt(
        { data: validRequestData(), auth: { uid: "user-1" } },
        dependencies(undefined, quota),
      ),
    ).rejects.toMatchObject({
      code: "resource-exhausted",
      details: { limit: "minute", retryAfterSeconds: 20 },
    });
    expect(quota.finalize).not.toHaveBeenCalled();
    expect(quota.release).not.toHaveBeenCalled();
  });

  it.each([
    ["refusal", new ModelRefusalError(), "failed-precondition"],
    [
      "malformed response",
      new ModelResponseError("invalid-json"),
      "unavailable",
    ],
    [
      "timeout",
      Object.assign(new Error("timed out"), {
        name: "APIConnectionTimeoutError",
      }),
      "unavailable",
    ],
    ["provider failure", new Error("provider failed"), "unavailable"],
  ])("releases quota after a %s", async (_name, error, expectedCode) => {
    const quota = quotaManager();
    const model: ReceiptExtractionModel = {
      extract: vi.fn(async () => {
        throw error;
      }),
    };

    await expect(
      handleExtractSmartReceipt(
        { data: validRequestData(), auth: { uid: "user-1" } },
        dependencies(model, quota),
      ),
    ).rejects.toMatchObject({ code: expectedCode });
    expect(quota.finalize).not.toHaveBeenCalled();
    expect(quota.release).toHaveBeenCalledWith(RESERVATION);
  });

  it("rejects structurally incomplete model JSON and refunds quota", async () => {
    const quota = quotaManager();
    const model: ReceiptExtractionModel = {
      extract: vi.fn(async () => ({ total: 11.3 })),
    };

    await expect(
      handleExtractSmartReceipt(
        { data: validRequestData(), auth: { uid: "user-1" } },
        dependencies(model, quota),
      ),
    ).rejects.toMatchObject({ code: "unavailable" });
    expect(quota.release).toHaveBeenCalledWith(RESERVATION);
  });
});
