import { describe, expect, it, vi } from "vitest";

import {
  createOpenAIReceiptModel,
  ModelRefusalError,
  ModelResponseError,
  OPENAI_MAX_RETRIES,
  OPENAI_MAX_OUTPUT_TOKENS,
  OPENAI_REQUEST_TIMEOUT_MS,
  OpenAIReceiptModel,
  safetyIdentifierForUid,
  type OpenAIClientOptions,
  type OpenAIReceiptRequest,
} from "../src/openaiReceiptModel";
import { MAX_RECEIPT_ITEMS } from "../src/contract";
import { validReceipt } from "./fixtures";

function modelInput() {
  return {
    rawOcrText: "Total 11.30",
    locale: "en-CA",
    currency: "CAD",
    parserCandidate: {
      storeName: null,
      purchaseDate: null,
      subtotal: null,
      tax: null,
      total: 11.3,
      items: [],
    },
    safetyIdentifier: safetyIdentifierForUid("firebase-user-1"),
  };
}

describe("OpenAIReceiptModel", () => {
  it("uses GPT-5.6 Sol, Responses, strict JSON Schema, and privacy controls", async () => {
    let captured: OpenAIReceiptRequest | undefined;
    const boundary = {
      create: vi.fn(async (request: OpenAIReceiptRequest) => {
        captured = request;
        return {
          status: "completed",
          output_text: JSON.stringify(validReceipt()),
          output: [],
        };
      }),
    };
    const model = new OpenAIReceiptModel(boundary);

    await expect(model.extract(modelInput())).resolves.toEqual(validReceipt());
    expect(captured?.model).toBe("gpt-5.6-sol");
    expect(captured?.reasoning).toEqual({ effort: "low" });
    expect(captured?.store).toBe(false);
    expect(captured?.safety_identifier).toHaveLength(64);
    expect(captured?.max_output_tokens).toBe(OPENAI_MAX_OUTPUT_TOKENS);
    expect(captured?.text.format).toMatchObject({
      type: "json_schema",
      name: "savingor_smart_receipt",
      strict: true,
    });
    expect(captured?.text.format.schema).toMatchObject({
      type: "object",
      additionalProperties: false,
      properties: {
        items: {
          maxItems: MAX_RECEIPT_ITEMS,
          items: {
            properties: {
              category: {
                description: expect.stringContaining("derived"),
              },
            },
          },
        },
      },
    });
    expect(captured?.instructions).toContain(
      "Category is a derived classification",
    );
    expect(captured?.instructions).toContain(
      "when the classification is uncertain, return null",
    );
  });

  it("creates a client with no retries and a bounded operation timeout", () => {
    let options: OpenAIClientOptions | undefined;

    createOpenAIReceiptModel("test-key", (received) => {
      options = received;
      return { responses: { create: vi.fn() } };
    });

    expect(options).toEqual({
      apiKey: "test-key",
      maxRetries: OPENAI_MAX_RETRIES,
      timeout: OPENAI_REQUEST_TIMEOUT_MS,
    });
    expect(OPENAI_MAX_RETRIES).toBe(0);
    expect(OPENAI_REQUEST_TIMEOUT_MS).toBeLessThan(60_000);
  });

  it("does not include a raw Firebase uid in the safety identifier", () => {
    const uid = "firebase-user-1";
    const identifier = safetyIdentifierForUid(uid);

    expect(identifier).not.toContain(uid);
    expect(identifier).toHaveLength(64);
  });

  it("turns a refusal into a typed error without exposing its text", async () => {
    const model = new OpenAIReceiptModel({
      create: vi.fn(async () => ({
        status: "completed",
        output: [
          {
            type: "message",
            content: [{ type: "refusal", refusal: "sensitive refusal text" }],
          },
        ],
      })),
    });

    await expect(model.extract(modelInput())).rejects.toBeInstanceOf(
      ModelRefusalError,
    );
  });

  it("rejects invalid JSON at the mocked network boundary", async () => {
    const model = new OpenAIReceiptModel({
      create: vi.fn(async () => ({
        status: "completed",
        output_text: "not-json",
        output: [],
      })),
    });

    await expect(model.extract(modelInput())).rejects.toBeInstanceOf(
      ModelResponseError,
    );
  });

  it.each(["failed", "incomplete"])(
    "rejects a %s response instead of accepting partial JSON",
    async (status) => {
      const model = new OpenAIReceiptModel({
        create: vi.fn(async () => ({
          status,
          output_text: JSON.stringify(validReceipt()),
          output: [],
        })),
      });

      await expect(model.extract(modelInput())).rejects.toBeInstanceOf(
        ModelResponseError,
      );
    },
  );
});
