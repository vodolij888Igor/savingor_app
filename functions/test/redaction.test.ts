import { describe, expect, it } from "vitest";

import { redactReceiptText, sanitizeReceiptData } from "../src/redaction";

describe("receipt redaction policy", () => {
  it("removes supported identifiers without damaging receipt facts", () => {
    const result = redactReceiptText(`Savingor Market
Date 2026-06-15
Email buyer@example.com
Phone +44 20 7946 0958
Loyalty ID MEMBER-9988
VISA **** 4242
Payment ID PAY-48291
Terminal ID TERM-7788
Authorization Code AUTH-5511
Reference: REF-9911
Subtotal 39.99
Tax 5.49
Total 45.48`);

    for (const identifier of [
      "buyer@example.com",
      "+44 20 7946 0958",
      "MEMBER-9988",
      "4242",
      "PAY-48291",
      "TERM-7788",
      "AUTH-5511",
      "REF-9911",
    ]) {
      expect(result.text).not.toContain(identifier);
    }
    expect(result.text).toContain("2026-06-15");
    expect(result.text).toContain("39.99");
    expect(result.text).toContain("5.49");
    expect(result.text).toContain("45.48");
    expect(result.kinds).toEqual(
      expect.arrayContaining([
        "EMAIL",
        "PHONE",
        "PAYMENT_CARD",
        "PAYMENT_REFERENCE",
        "LOYALTY_IDENTIFIER",
        "TERMINAL_IDENTIFIER",
        "AUTHORIZATION_IDENTIFIER",
        "REFERENCE_IDENTIFIER",
      ]),
    );
  });

  it("recursively sanitizes every candidate string and preserves numeric values", () => {
    const candidate = {
      storeName: "buyer@example.com",
      purchaseDate: "2026-06-15",
      subtotal: 39.99,
      tax: 5.49,
      total: 45.48,
      items: [
        {
          name: "Milk member ID MEMBER-1234",
          quantity: 2,
          unit: "ea",
          unitPrice: 4.25,
          totalPrice: 8.5,
          category: "Dairy terminal ID TERM-1234",
        },
      ],
    };

    const result = sanitizeReceiptData(candidate);
    const serialized = JSON.stringify(result.value);

    expect(serialized).not.toContain("buyer@example.com");
    expect(serialized).not.toContain("MEMBER-1234");
    expect(serialized).not.toContain("TERM-1234");
    expect(result.value).toMatchObject({
      purchaseDate: "2026-06-15",
      subtotal: 39.99,
      tax: 5.49,
      total: 45.48,
      items: [
        {
          quantity: 2,
          unitPrice: 4.25,
          totalPrice: 8.5,
        },
      ],
    });
  });

  it("redacts a Luhn-valid full payment-card number", () => {
    const result = redactReceiptText("Card 4111 1111 1111 1111\nTotal 19.99");

    expect(result.text).toContain("[REDACTED_PAYMENT_CARD]");
    expect(result.text).toContain("19.99");
  });

  it("does not mistake prices, dates, tax, subtotal, or total for identifiers", () => {
    const input = `Date 2026-06-15
Bread 3.49
Subtotal 3.49
Tax 0.00
Total 3.49`;
    expect(redactReceiptText(input)).toEqual({ text: input, kinds: [] });
  });
});
