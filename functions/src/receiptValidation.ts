import {
  MAX_RECEIPT_ITEMS,
  MODEL_WARNING_CODES,
  type SmartReceipt,
  type SmartReceiptItem,
  type WarningCode,
} from "./contract";
import { INPUT_LIMITS } from "./requestValidation";

const MINIMUM_PURCHASE_DATE = new Date("2000-01-01T00:00:00.000Z");
const ZERO_DECIMAL_CURRENCIES = new Set([
  "CLP",
  "ISK",
  "JPY",
  "KRW",
  "PYG",
  "VND",
]);
const THREE_DECIMAL_CURRENCIES = new Set([
  "BHD",
  "IQD",
  "JOD",
  "KWD",
  "LYD",
  "OMR",
  "TND",
]);

type JsonObject = Record<string, unknown>;

const RECEIPT_KEYS = new Set([
  "storeName",
  "purchaseDate",
  "currency",
  "subtotal",
  "tax",
  "total",
  "items",
  "warningCodes",
]);
const ITEM_KEYS = new Set([
  "name",
  "quantity",
  "unit",
  "unitPrice",
  "totalPrice",
  "category",
]);

export class ReceiptStructureError extends Error {
  constructor(message: string) {
    super(message);
    this.name = "ReceiptStructureError";
  }
}

export function validateModelReceipt(
  value: unknown,
  expectedCurrency: string,
  now: Date,
  initialWarnings: readonly WarningCode[] = [],
): SmartReceipt {
  const warnings = new Set<WarningCode>(initialWarnings);
  const receipt = requireExactObject(value, RECEIPT_KEYS, "receipt");
  if (!Array.isArray(receipt.items)) {
    throw new ReceiptStructureError("receipt.items must be an array");
  }
  if (receipt.items.length > MAX_RECEIPT_ITEMS) {
    throw new ReceiptStructureError("receipt.items exceeds the item limit");
  }
  for (const [index, item] of receipt.items.entries()) {
    requireExactObject(item, ITEM_KEYS, `receipt.items[${index}]`);
  }
  if (!Array.isArray(receipt.warningCodes)) {
    throw new ReceiptStructureError("receipt.warningCodes must be an array");
  }

  const storeName = outputString(
    receipt.storeName,
    INPUT_LIMITS.storeNameCharacters,
    "STORE_NAME_INVALID",
    warnings,
  );
  const purchaseDate = outputDate(receipt.purchaseDate, now, warnings);
  const currency = outputCurrency(receipt.currency, expectedCurrency, warnings);
  const subtotal = outputMoney(receipt.subtotal, warnings);
  const tax = outputMoney(receipt.tax, warnings);
  const total = outputMoney(receipt.total, warnings);
  const items = outputItems(receipt.items, warnings);
  addModelWarnings(receipt.warningCodes, warnings);

  const tolerance = currencyTolerance(currency ?? expectedCurrency);
  reconcileReceiptTotals(subtotal, tax, total, tolerance, warnings);
  reconcileItemTotals(items, subtotal, tax, total, tolerance, warnings);

  return {
    storeName,
    purchaseDate,
    currency,
    subtotal,
    tax,
    total,
    items,
    warningCodes: [...warnings],
  };
}

export function currencyTolerance(currency: string): number {
  if (ZERO_DECIMAL_CURRENCIES.has(currency)) {
    return 2;
  }
  if (THREE_DECIMAL_CURRENCIES.has(currency)) {
    return 0.002;
  }
  return 0.02;
}

function outputItems(
  value: unknown,
  warnings: Set<WarningCode>,
): SmartReceiptItem[] {
  if (!Array.isArray(value)) return [];
  return value.map((entry) => {
    const item = entry as JsonObject;
    return {
      name: outputString(
        item.name,
        INPUT_LIMITS.itemNameCharacters,
        "ITEM_VALUE_INVALID",
        warnings,
      ),
      quantity: outputQuantity(item.quantity, warnings),
      unit: outputString(
        item.unit,
        INPUT_LIMITS.unitCharacters,
        "ITEM_VALUE_INVALID",
        warnings,
      ),
      unitPrice: outputMoney(item.unitPrice, warnings),
      totalPrice: outputMoney(item.totalPrice, warnings),
      category: outputString(
        item.category,
        INPUT_LIMITS.categoryCharacters,
        "ITEM_VALUE_INVALID",
        warnings,
      ),
    };
  });
}

function outputString(
  value: unknown,
  maximumLength: number,
  warning: WarningCode,
  warnings: Set<WarningCode>,
): string | null {
  if (value === null || value === undefined) {
    return null;
  }
  if (typeof value !== "string") {
    warnings.add(warning);
    return null;
  }
  const normalized = value.trim();
  if (normalized.length === 0) {
    return null;
  }
  if (normalized.length > maximumLength) {
    warnings.add(warning);
    return null;
  }
  return normalized;
}

function outputDate(
  value: unknown,
  now: Date,
  warnings: Set<WarningCode>,
): string | null {
  const normalized = outputString(value, 10, "PURCHASE_DATE_INVALID", warnings);
  if (normalized === null) {
    return null;
  }
  const match = /^(\d{4})-(\d{2})-(\d{2})$/.exec(normalized);
  if (match === null) {
    warnings.add("PURCHASE_DATE_INVALID");
    return null;
  }
  const year = Number(match[1]);
  const month = Number(match[2]);
  const day = Number(match[3]);
  const parsed = new Date(Date.UTC(year, month - 1, day));
  if (
    parsed.getUTCFullYear() !== year ||
    parsed.getUTCMonth() !== month - 1 ||
    parsed.getUTCDate() !== day
  ) {
    warnings.add("PURCHASE_DATE_INVALID");
    return null;
  }
  const latest = new Date(now);
  latest.setUTCHours(0, 0, 0, 0);
  latest.setUTCDate(latest.getUTCDate() + 2);
  if (parsed < MINIMUM_PURCHASE_DATE || parsed > latest) {
    warnings.add("PURCHASE_DATE_OUT_OF_RANGE");
    return null;
  }
  return normalized;
}

function outputCurrency(
  value: unknown,
  expectedCurrency: string,
  warnings: Set<WarningCode>,
): string | null {
  const normalized = outputString(value, 3, "CURRENCY_INVALID", warnings);
  if (normalized === null) {
    return null;
  }
  const currency = normalized.toUpperCase();
  if (!/^[A-Z]{3}$/.test(currency)) {
    warnings.add("CURRENCY_INVALID");
    return null;
  }
  if (currency !== expectedCurrency) {
    warnings.add("CURRENCY_CONFLICT");
  }
  return currency;
}

function outputMoney(
  value: unknown,
  warnings: Set<WarningCode>,
): number | null {
  if (value === null || value === undefined) {
    return null;
  }
  if (
    typeof value !== "number" ||
    !Number.isFinite(value) ||
    value < 0 ||
    value > INPUT_LIMITS.maximumMoney
  ) {
    warnings.add("MONETARY_VALUE_INVALID");
    return null;
  }
  return value;
}

function outputQuantity(
  value: unknown,
  warnings: Set<WarningCode>,
): number | null {
  if (value === null || value === undefined) {
    return null;
  }
  if (
    typeof value !== "number" ||
    !Number.isFinite(value) ||
    value <= 0 ||
    value > INPUT_LIMITS.maximumQuantity
  ) {
    warnings.add("ITEM_VALUE_INVALID");
    return null;
  }
  return value;
}

function addModelWarnings(value: unknown, warnings: Set<WarningCode>): void {
  if (!Array.isArray(value)) {
    warnings.add("MODEL_OUTPUT_INVALID");
    return;
  }
  const allowed = new Set<string>(MODEL_WARNING_CODES);
  for (const warning of value) {
    if (typeof warning === "string" && allowed.has(warning)) {
      warnings.add(warning as WarningCode);
    } else {
      warnings.add("MODEL_OUTPUT_INVALID");
    }
  }
}

function reconcileReceiptTotals(
  subtotal: number | null,
  tax: number | null,
  total: number | null,
  tolerance: number,
  warnings: Set<WarningCode>,
): void {
  if (
    subtotal !== null &&
    tax !== null &&
    total !== null &&
    Math.abs(subtotal + tax - total) > tolerance
  ) {
    warnings.add("SUBTOTAL_TAX_TOTAL_MISMATCH");
  }
}

function reconcileItemTotals(
  items: readonly SmartReceiptItem[],
  subtotal: number | null,
  tax: number | null,
  total: number | null,
  tolerance: number,
  warnings: Set<WarningCode>,
): void {
  for (const item of items) {
    if (
      item.quantity !== null &&
      item.unitPrice !== null &&
      item.totalPrice !== null &&
      Math.abs(item.quantity * item.unitPrice - item.totalPrice) > tolerance
    ) {
      warnings.add("ITEM_ARITHMETIC_MISMATCH");
    }
  }

  if (items.length === 0 || items.some((item) => item.totalPrice === null)) {
    return;
  }
  const itemSum = items.reduce((sum, item) => sum + (item.totalPrice ?? 0), 0);
  if (subtotal !== null && Math.abs(itemSum - subtotal) > tolerance) {
    warnings.add("ITEM_TOTAL_MISMATCH");
    return;
  }
  if (
    subtotal === null &&
    tax !== null &&
    total !== null &&
    Math.abs(itemSum + tax - total) > tolerance
  ) {
    warnings.add("ITEM_TOTAL_MISMATCH");
  }
}

function isObject(value: unknown): value is JsonObject {
  return typeof value === "object" && value !== null && !Array.isArray(value);
}

function requireExactObject(
  value: unknown,
  expectedKeys: ReadonlySet<string>,
  field: string,
): JsonObject {
  if (!isObject(value)) {
    throw new ReceiptStructureError(`${field} must be an object`);
  }
  const keys = Object.keys(value);
  if (
    keys.length !== expectedKeys.size ||
    keys.some((key) => !expectedKeys.has(key))
  ) {
    throw new ReceiptStructureError(
      `${field} must contain exactly the required fields`,
    );
  }
  return value;
}
