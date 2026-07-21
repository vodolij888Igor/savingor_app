export const MODEL_WARNING_CODES = [
  "OCR_AMBIGUOUS",
  "UNCERTAIN_STORE_NAME",
  "UNCERTAIN_PURCHASE_DATE",
  "UNCERTAIN_CURRENCY",
  "UNCERTAIN_SUBTOTAL",
  "UNCERTAIN_TAX",
  "UNCERTAIN_TOTAL",
  "UNCERTAIN_ITEM",
] as const;

export const SERVER_WARNING_CODES = [
  "IDENTIFIERS_REDACTED",
  "MODEL_OUTPUT_INVALID",
  "STORE_NAME_INVALID",
  "PURCHASE_DATE_INVALID",
  "PURCHASE_DATE_OUT_OF_RANGE",
  "CURRENCY_INVALID",
  "CURRENCY_CONFLICT",
  "MONETARY_VALUE_INVALID",
  "ITEM_VALUE_INVALID",
  "ITEM_COUNT_TRUNCATED",
  "SUBTOTAL_TAX_TOTAL_MISMATCH",
  "ITEM_TOTAL_MISMATCH",
  "ITEM_ARITHMETIC_MISMATCH",
] as const;

export const MAX_RECEIPT_ITEMS = 50;

export type ModelWarningCode = (typeof MODEL_WARNING_CODES)[number];
export type ServerWarningCode = (typeof SERVER_WARNING_CODES)[number];
export type WarningCode = ModelWarningCode | ServerWarningCode;

export interface SmartReceiptItem {
  name: string | null;
  quantity: number | null;
  unit: string | null;
  unitPrice: number | null;
  totalPrice: number | null;
  /** Derived classification inferred conservatively from the printed item name. */
  category: string | null;
}

export interface SmartReceipt {
  storeName: string | null;
  purchaseDate: string | null;
  currency: string | null;
  subtotal: number | null;
  tax: number | null;
  total: number | null;
  items: SmartReceiptItem[];
  warningCodes: WarningCode[];
}

export interface ParserCandidate {
  storeName: string | null;
  purchaseDate: string | null;
  subtotal: number | null;
  tax: number | null;
  total: number | null;
  items: SmartReceiptItem[];
}

export interface ExtractSmartReceiptInput {
  rawOcrText: string;
  locale: string;
  currency: string;
  parserCandidate: ParserCandidate;
}

export interface ModelReceiptInput extends ExtractSmartReceiptInput {
  rawOcrText: string;
  safetyIdentifier: string;
}

export interface ExtractSmartReceiptResponse {
  receipt: SmartReceipt;
  processing: {
    schemaVersion: "1";
    model: "gpt-5.6-sol";
    appCheckVerified: boolean;
  };
}

export interface ReceiptExtractionModel {
  extract(input: ModelReceiptInput): Promise<unknown>;
}

export interface QuotaReservation {
  reservationId: string;
  reservedDayKey: string;
  userDocumentPath: string;
  projectDocumentPath: string;
}

export interface SmartReceiptQuotaManager {
  reserve(uid: string): Promise<QuotaReservation>;
  finalize(reservation: QuotaReservation): Promise<void>;
  release(reservation: QuotaReservation): Promise<void>;
}
