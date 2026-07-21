import type { SmartReceipt } from "../src/contract";

export function validReceipt(
  overrides: Partial<SmartReceipt> = {},
): SmartReceipt {
  return {
    storeName: "Savingor Market",
    purchaseDate: "2026-06-15",
    currency: "CAD",
    subtotal: 10,
    tax: 1.3,
    total: 11.3,
    items: [
      {
        name: "Milk",
        quantity: 1,
        unit: "ea",
        unitPrice: 10,
        totalPrice: 10,
        category: "Dairy",
      },
    ],
    warningCodes: [],
    ...overrides,
  };
}

export function validRequestData(): Record<string, unknown> {
  return {
    rawOcrText: "Savingor Market\nMilk 10.00\nTax 1.30\nTotal 11.30",
    locale: "en-CA",
    currency: "CAD",
    parserCandidate: {
      storeName: "Savingor Market",
      purchaseDate: "2026-06-15",
      subtotal: 10,
      tax: 1.3,
      total: 11.3,
      items: [
        {
          name: "Milk",
          quantity: 1,
          unit: "ea",
          unitPrice: 10,
          totalPrice: 10,
          category: null,
        },
      ],
    },
  };
}
