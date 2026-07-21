import { describe, expect, it } from "vitest";

import {
  INPUT_LIMITS,
  InputValidationError,
  validateExtractSmartReceiptInput,
} from "../src/requestValidation";
import { validRequestData } from "./fixtures";

describe("validateExtractSmartReceiptInput", () => {
  it("normalizes bounded locale, currency, and candidate fields", () => {
    const data = validRequestData();
    data.locale = "en_CA";
    data.currency = "cad";

    const result = validateExtractSmartReceiptInput(data);

    expect(result.locale).toBe("en-CA");
    expect(result.currency).toBe("CAD");
    expect(result.parserCandidate.items).toHaveLength(1);
  });

  it("rejects image or other unsupported fields", () => {
    expect(() =>
      validateExtractSmartReceiptInput({
        ...validRequestData(),
        imageBase64: "not-accepted",
      }),
    ).toThrow(InputValidationError);
  });

  it("rejects oversized OCR text", () => {
    expect(() =>
      validateExtractSmartReceiptInput({
        ...validRequestData(),
        rawOcrText: "x".repeat(INPUT_LIMITS.rawOcrCharacters + 1),
      }),
    ).toThrow("rawOcrText exceeds the maximum length");
  });

  it("rejects negative candidate money", () => {
    const data = validRequestData();
    data.parserCandidate = {
      ...(data.parserCandidate as Record<string, unknown>),
      total: -1,
    };

    expect(() => validateExtractSmartReceiptInput(data)).toThrow(
      "parserCandidate.total is outside the allowed range",
    );
  });

  it("rejects too many parser candidate items", () => {
    const data = validRequestData();
    data.parserCandidate = {
      ...(data.parserCandidate as Record<string, unknown>),
      items: Array.from(
        { length: INPUT_LIMITS.candidateItems + 1 },
        () => ({}),
      ),
    };

    expect(() => validateExtractSmartReceiptInput(data)).toThrow(
      "must contain at most",
    );
  });
});
