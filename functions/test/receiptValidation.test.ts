import { describe, expect, it } from "vitest";

import {
  currencyTolerance,
  ReceiptStructureError,
  validateModelReceipt,
} from "../src/receiptValidation";
import { MAX_RECEIPT_ITEMS } from "../src/contract";
import { validReceipt } from "./fixtures";

const NOW = new Date("2026-06-20T12:00:00.000Z");

describe("validateModelReceipt", () => {
  it("preserves a valid structured receipt", () => {
    expect(validateModelReceipt(validReceipt(), "CAD", NOW)).toEqual(
      validReceipt(),
    );
  });

  it("preserves a conservative derived category and allows null", () => {
    expect(
      validateModelReceipt(validReceipt(), "CAD", NOW).items[0]?.category,
    ).toBe("Dairy");
    expect(
      validateModelReceipt(
        validReceipt({
          items: [
            {
              name: "Unclear item",
              quantity: 1,
              unit: null,
              unitPrice: 10,
              totalPrice: 10,
              category: null,
            },
          ],
        }),
        "CAD",
        NOW,
      ).items[0]?.category,
    ).toBeNull();
  });

  it("rejects incomplete structured JSON", () => {
    expect(() => validateModelReceipt({ total: 11.3 }, "CAD", NOW)).toThrow(
      ReceiptStructureError,
    );
  });

  it("rejects output beyond the bounded item contract", () => {
    expect(() =>
      validateModelReceipt(
        validReceipt({
          items: Array.from(
            { length: MAX_RECEIPT_ITEMS + 1 },
            () => validReceipt().items[0]!,
          ),
        }),
        "CAD",
        NOW,
      ),
    ).toThrow(ReceiptStructureError);
  });

  it("nulls invalid values and emits machine-readable warnings", () => {
    const result = validateModelReceipt(
      validReceipt({
        purchaseDate: "2026-02-30",
        total: -4,
        items: [
          {
            name: "Milk",
            quantity: 0,
            unit: "ea",
            unitPrice: 4,
            totalPrice: 4,
            category: null,
          },
        ],
      }),
      "CAD",
      NOW,
    );

    expect(result.purchaseDate).toBeNull();
    expect(result.total).toBeNull();
    expect(result.items[0]?.quantity).toBeNull();
    expect(result.warningCodes).toEqual(
      expect.arrayContaining([
        "PURCHASE_DATE_INVALID",
        "MONETARY_VALUE_INVALID",
        "ITEM_VALUE_INVALID",
      ]),
    );
  });

  it("warns when subtotal plus tax does not reconcile with total", () => {
    const result = validateModelReceipt(
      validReceipt({ subtotal: 10, tax: 1, total: 12 }),
      "CAD",
      NOW,
    );

    expect(result.warningCodes).toContain("SUBTOTAL_TAX_TOTAL_MISMATCH");
  });

  it("reconciles line totals and quantity arithmetic", () => {
    const result = validateModelReceipt(
      validReceipt({
        subtotal: 15,
        tax: 0,
        total: 15,
        items: [
          {
            name: "Apples",
            quantity: 2,
            unit: "kg",
            unitPrice: 4,
            totalPrice: 9,
            category: "Produce",
          },
        ],
      }),
      "CAD",
      NOW,
    );

    expect(result.warningCodes).toEqual(
      expect.arrayContaining([
        "ITEM_ARITHMETIC_MISMATCH",
        "ITEM_TOTAL_MISMATCH",
      ]),
    );
  });

  it("uses currency minor-unit tolerances", () => {
    expect(currencyTolerance("CAD")).toBe(0.02);
    expect(currencyTolerance("JPY")).toBe(2);
    expect(currencyTolerance("KWD")).toBe(0.002);
  });
});
