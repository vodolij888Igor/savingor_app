import { MAX_RECEIPT_ITEMS, MODEL_WARNING_CODES } from "./contract";

const nullableString = { type: ["string", "null"] };
const nullableNumber = { type: ["number", "null"] };

export const RECEIPT_JSON_SCHEMA: Record<string, unknown> = {
  type: "object",
  additionalProperties: false,
  properties: {
    storeName: {
      ...nullableString,
      description: "Printed merchant name, or null when absent or uncertain.",
    },
    purchaseDate: {
      ...nullableString,
      description:
        "Printed purchase date in YYYY-MM-DD form, or null when absent or uncertain.",
    },
    currency: {
      ...nullableString,
      description: "Three-letter currency code, or null when uncertain.",
    },
    subtotal: nullableNumber,
    tax: nullableNumber,
    total: nullableNumber,
    items: {
      type: "array",
      maxItems: MAX_RECEIPT_ITEMS,
      items: {
        type: "object",
        additionalProperties: false,
        properties: {
          name: nullableString,
          quantity: nullableNumber,
          unit: nullableString,
          unitPrice: nullableNumber,
          totalPrice: nullableNumber,
          category: {
            ...nullableString,
            description:
              "A derived, conservative classification inferred from the printed item name, or null when uncertain.",
          },
        },
        required: [
          "name",
          "quantity",
          "unit",
          "unitPrice",
          "totalPrice",
          "category",
        ],
      },
    },
    warningCodes: {
      type: "array",
      items: { type: "string", enum: MODEL_WARNING_CODES },
    },
  },
  required: [
    "storeName",
    "purchaseDate",
    "currency",
    "subtotal",
    "tax",
    "total",
    "items",
    "warningCodes",
  ],
};
