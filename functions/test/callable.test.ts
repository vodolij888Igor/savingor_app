import { describe, expect, it, vi } from "vitest";

import { createExtractSmartReceiptCallableHandler } from "../src/callable";
import type {
  QuotaReservation,
  ReceiptExtractionModel,
  SmartReceiptQuotaManager,
} from "../src/contract";
import {
  ModelRefusalError,
  ModelResponseError,
} from "../src/openaiReceiptModel";
import { validReceipt, validRequestData } from "./fixtures";

const RESERVATION: QuotaReservation = {
  reservationId: "callable-reservation",
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

function createHandler(
  model: ReceiptExtractionModel,
  quota: SmartReceiptQuotaManager = quotaManager(),
  getOpenAIApiKey = vi.fn(() => "secret-from-manager"),
) {
  return {
    quota,
    getOpenAIApiKey,
    handler: createExtractSmartReceiptCallableHandler({
      getOpenAIApiKey,
      createModel: vi.fn(() => model),
      quotaManager: quota,
      clock: () => new Date("2026-06-20T12:00:00.000Z"),
    }),
  };
}

describe("extractSmartReceipt callable boundary", () => {
  it("checks authentication before reading secret configuration", async () => {
    const getOpenAIApiKey = vi.fn(() => "secret-from-manager");
    const setup = createHandler(
      { extract: vi.fn(async () => validReceipt()) },
      undefined,
      getOpenAIApiKey,
    );

    await expect(
      setup.handler({ data: validRequestData() }),
    ).rejects.toMatchObject({ code: "unauthenticated" });
    expect(getOpenAIApiKey).not.toHaveBeenCalled();
    expect(setup.quota.reserve).not.toHaveBeenCalled();
  });

  it("returns a controlled configuration error when the secret is missing", async () => {
    const setup = createHandler(
      { extract: vi.fn(async () => validReceipt()) },
      undefined,
      vi.fn(() => ""),
    );

    await expect(
      setup.handler({ data: validRequestData(), auth: { uid: "user-1" } }),
    ).rejects.toMatchObject({ code: "failed-precondition" });
    expect(setup.quota.reserve).not.toHaveBeenCalled();
  });

  it("returns a successful validated callable response", async () => {
    const setup = createHandler({ extract: vi.fn(async () => validReceipt()) });

    const result = await setup.handler({
      data: validRequestData(),
      auth: { uid: "user-1" },
    });

    expect(result.receipt).toEqual(validReceipt());
    expect(setup.quota.finalize).toHaveBeenCalledWith(RESERVATION);
  });

  it.each([
    ["refusal", new ModelRefusalError(), "failed-precondition"],
    ["malformed", new ModelResponseError("invalid-json"), "unavailable"],
    [
      "timeout",
      Object.assign(new Error("timeout"), {
        name: "APIConnectionTimeoutError",
      }),
      "unavailable",
    ],
    ["provider failure", new Error("provider failure"), "unavailable"],
  ])(
    "maps %s and refunds the callable reservation",
    async (_name, error, code) => {
      const setup = createHandler({
        extract: vi.fn(async () => {
          throw error;
        }),
      });

      await expect(
        setup.handler({ data: validRequestData(), auth: { uid: "user-1" } }),
      ).rejects.toMatchObject({ code });
      expect(setup.quota.release).toHaveBeenCalledWith(RESERVATION);
      expect(setup.quota.finalize).not.toHaveBeenCalled();
    },
  );
});
