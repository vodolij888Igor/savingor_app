import type {
  ExtractSmartReceiptInput,
  ParserCandidate,
  SmartReceiptItem,
} from "./contract";
import { MAX_RECEIPT_ITEMS } from "./contract";

export const INPUT_LIMITS = {
  payloadBytes: 32 * 1024,
  rawOcrCharacters: 16_000,
  localeCharacters: 35,
  storeNameCharacters: 160,
  itemNameCharacters: 200,
  unitCharacters: 32,
  categoryCharacters: 80,
  candidateItems: MAX_RECEIPT_ITEMS,
  maximumMoney: 1_000_000,
  maximumQuantity: 100_000,
} as const;

export class InputValidationError extends Error {
  constructor(message: string) {
    super(message);
    this.name = "InputValidationError";
  }
}

type JsonObject = Record<string, unknown>;

const TOP_LEVEL_KEYS = new Set([
  "rawOcrText",
  "locale",
  "currency",
  "parserCandidate",
]);
const CANDIDATE_KEYS = new Set([
  "storeName",
  "purchaseDate",
  "subtotal",
  "tax",
  "total",
  "items",
]);
const ITEM_KEYS = new Set([
  "name",
  "quantity",
  "unit",
  "unitPrice",
  "totalPrice",
  "category",
]);

export function validateExtractSmartReceiptInput(
  value: unknown,
): ExtractSmartReceiptInput {
  const payload = asObject(value, "payload");
  assertAllowedKeys(payload, TOP_LEVEL_KEYS, "payload");

  let encoded: string;
  try {
    encoded = JSON.stringify(payload);
  } catch {
    throw new InputValidationError("payload must be JSON serializable");
  }
  if (Buffer.byteLength(encoded, "utf8") > INPUT_LIMITS.payloadBytes) {
    throw new InputValidationError("payload exceeds the maximum size");
  }

  const rawOcrText = requiredString(
    payload.rawOcrText,
    "rawOcrText",
    INPUT_LIMITS.rawOcrCharacters,
    false,
  );
  if (rawOcrText.trim().length === 0) {
    throw new InputValidationError("rawOcrText must not be empty");
  }

  const locale = requiredString(
    payload.locale,
    "locale",
    INPUT_LIMITS.localeCharacters,
    true,
  );
  if (!/^[A-Za-z]{2,3}(?:[-_][A-Za-z0-9]{2,8})*$/.test(locale)) {
    throw new InputValidationError("locale must be a valid locale tag");
  }

  const currency = requiredString(payload.currency, "currency", 3, true)
    .toUpperCase()
    .trim();
  if (!/^[A-Z]{3}$/.test(currency)) {
    throw new InputValidationError("currency must be a three-letter code");
  }

  return {
    rawOcrText,
    locale: locale.replaceAll("_", "-"),
    currency,
    parserCandidate: parseCandidate(payload.parserCandidate),
  };
}

function parseCandidate(value: unknown): ParserCandidate {
  if (value === undefined || value === null) {
    return emptyCandidate();
  }
  const candidate = asObject(value, "parserCandidate");
  assertAllowedKeys(candidate, CANDIDATE_KEYS, "parserCandidate");

  const rawItems = candidate.items ?? [];
  if (!Array.isArray(rawItems)) {
    throw new InputValidationError("parserCandidate.items must be an array");
  }
  if (rawItems.length > INPUT_LIMITS.candidateItems) {
    throw new InputValidationError(
      `parserCandidate.items must contain at most ${INPUT_LIMITS.candidateItems} items`,
    );
  }

  return {
    storeName: nullableString(
      candidate.storeName,
      "parserCandidate.storeName",
      INPUT_LIMITS.storeNameCharacters,
    ),
    purchaseDate: nullableDateString(
      candidate.purchaseDate,
      "parserCandidate.purchaseDate",
    ),
    subtotal: nullableNumber(
      candidate.subtotal,
      "parserCandidate.subtotal",
      INPUT_LIMITS.maximumMoney,
      true,
    ),
    tax: nullableNumber(
      candidate.tax,
      "parserCandidate.tax",
      INPUT_LIMITS.maximumMoney,
      true,
    ),
    total: nullableNumber(
      candidate.total,
      "parserCandidate.total",
      INPUT_LIMITS.maximumMoney,
      true,
    ),
    items: rawItems.map(parseCandidateItem),
  };
}

function parseCandidateItem(value: unknown, index: number): SmartReceiptItem {
  const item = asObject(value, `parserCandidate.items[${index}]`);
  assertAllowedKeys(item, ITEM_KEYS, `parserCandidate.items[${index}]`);

  return {
    name: nullableString(
      item.name,
      `parserCandidate.items[${index}].name`,
      INPUT_LIMITS.itemNameCharacters,
    ),
    quantity: nullableNumber(
      item.quantity,
      `parserCandidate.items[${index}].quantity`,
      INPUT_LIMITS.maximumQuantity,
      false,
    ),
    unit: nullableString(
      item.unit,
      `parserCandidate.items[${index}].unit`,
      INPUT_LIMITS.unitCharacters,
    ),
    unitPrice: nullableNumber(
      item.unitPrice,
      `parserCandidate.items[${index}].unitPrice`,
      INPUT_LIMITS.maximumMoney,
      true,
    ),
    totalPrice: nullableNumber(
      item.totalPrice,
      `parserCandidate.items[${index}].totalPrice`,
      INPUT_LIMITS.maximumMoney,
      true,
    ),
    category: nullableString(
      item.category,
      `parserCandidate.items[${index}].category`,
      INPUT_LIMITS.categoryCharacters,
    ),
  };
}

function emptyCandidate(): ParserCandidate {
  return {
    storeName: null,
    purchaseDate: null,
    subtotal: null,
    tax: null,
    total: null,
    items: [],
  };
}

function asObject(value: unknown, field: string): JsonObject {
  if (typeof value !== "object" || value === null || Array.isArray(value)) {
    throw new InputValidationError(`${field} must be an object`);
  }
  return value as JsonObject;
}

function assertAllowedKeys(
  value: JsonObject,
  allowed: ReadonlySet<string>,
  field: string,
): void {
  const unexpected = Object.keys(value).find((key) => !allowed.has(key));
  if (unexpected !== undefined) {
    throw new InputValidationError(`${field} contains unsupported fields`);
  }
}

function requiredString(
  value: unknown,
  field: string,
  maximumLength: number,
  trim: boolean,
): string {
  if (typeof value !== "string") {
    throw new InputValidationError(`${field} must be a string`);
  }
  const normalized = trim ? value.trim() : value;
  if (normalized.length > maximumLength) {
    throw new InputValidationError(`${field} exceeds the maximum length`);
  }
  return normalized;
}

function nullableString(
  value: unknown,
  field: string,
  maximumLength: number,
): string | null {
  if (value === undefined || value === null) {
    return null;
  }
  const normalized = requiredString(value, field, maximumLength, true);
  return normalized.length === 0 ? null : normalized;
}

function nullableDateString(value: unknown, field: string): string | null {
  const normalized = nullableString(value, field, 10);
  if (normalized !== null && !/^\d{4}-\d{2}-\d{2}$/.test(normalized)) {
    throw new InputValidationError(`${field} must use YYYY-MM-DD`);
  }
  return normalized;
}

function nullableNumber(
  value: unknown,
  field: string,
  maximum: number,
  allowZero: boolean,
): number | null {
  if (value === undefined || value === null) {
    return null;
  }
  if (typeof value !== "number" || !Number.isFinite(value)) {
    throw new InputValidationError(`${field} must be a finite number or null`);
  }
  const minimum = allowZero ? 0 : Number.EPSILON;
  if (value < minimum || value > maximum) {
    throw new InputValidationError(`${field} is outside the allowed range`);
  }
  return value;
}
