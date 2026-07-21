export const REDACTION_KINDS = [
  "EMAIL",
  "PHONE",
  "PAYMENT_CARD",
  "PAYMENT_REFERENCE",
  "LOYALTY_IDENTIFIER",
  "TERMINAL_IDENTIFIER",
  "AUTHORIZATION_IDENTIFIER",
  "REFERENCE_IDENTIFIER",
] as const;

export type RedactionKind = (typeof REDACTION_KINDS)[number];

export interface RedactionResult {
  text: string;
  kinds: RedactionKind[];
}

export function redactReceiptText(input: string): RedactionResult {
  const result = sanitizeReceiptData(input);
  return { text: result.value, kinds: result.kinds };
}

export interface SanitizationResult<T> {
  value: T;
  kinds: RedactionKind[];
}

/** Applies the receipt redaction policy to every nested string without coercing values. */
export function sanitizeReceiptData<T>(input: T): SanitizationResult<T> {
  const kinds = new Set<RedactionKind>();
  const value = sanitizeValue(input, kinds) as T;
  return { value, kinds: [...kinds] };
}

function sanitizeValue(value: unknown, kinds: Set<RedactionKind>): unknown {
  if (typeof value === "string") {
    return redactString(value, kinds);
  }
  if (Array.isArray(value)) {
    return value.map((entry) => sanitizeValue(entry, kinds));
  }
  if (typeof value === "object" && value !== null) {
    return Object.fromEntries(
      Object.entries(value).map(([key, entry]) => [
        key,
        sanitizeValue(entry, kinds),
      ]),
    );
  }
  return value;
}

function redactString(input: string, kinds: Set<RedactionKind>): string {
  let text = input;

  text = replaceAndRecord(
    text,
    /\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}\b/gi,
    "[REDACTED_EMAIL]",
    "EMAIL",
    kinds,
  );

  text = replaceLabelledIdentifier(
    text,
    /\b((?:phone|telephone|tel|mobile|cell)\s*(?:(?:no\.?|number|#)\s*)?[:#-]?\s*)\+?\d(?:[\s().-]*\d){6,14}(?![\d.])/gi,
    "[REDACTED_PHONE]",
    "PHONE",
    kinds,
  );

  text = replaceAndRecord(
    text,
    /(?<![\w\d.])\+\d(?:[\s().-]*\d){6,14}(?![\d.])/g,
    "[REDACTED_PHONE]",
    "PHONE",
    kinds,
  );

  text = replaceAndRecord(
    text,
    /(?<![\d.])(?:\+?1[\s().-]*)?(?:\(?\d{3}\)?[\s.-]*)\d{3}[\s.-]*\d{4}(?![\d.])/g,
    "[REDACTED_PHONE]",
    "PHONE",
    kinds,
  );

  text = text.replace(/\b(?:\d[ -]?){12,18}\d\b/g, (match) => {
    const digitCount = match.replace(/\D/g, "").length;
    if (digitCount < 13 || digitCount > 19 || !passesLuhnCheck(match)) {
      return match;
    }
    kinds.add("PAYMENT_CARD");
    return "[REDACTED_PAYMENT_CARD]";
  });

  text = replaceLabelledIdentifier(
    text,
    /\b((?:visa|mastercard|amex|american express|debit|credit|card)\s*(?:ending(?:\s+in)?|end|no\.?|number|#)?\s*[:#-]?\s*)(?:(?:x{2,}|\*{2,})\s*)?\d{4,}\b/gi,
    "[REDACTED_PAYMENT_CARD]",
    "PAYMENT_CARD",
    kinds,
  );

  text = replaceLabelledIdentifier(
    text,
    /\b((?:payment|transaction|trace|account|acct)\s*(?:id|no\.?|number|#|code)\s*[:#-]?\s*)[A-Z0-9][A-Z0-9-]{3,}\b/gi,
    "[REDACTED_PAYMENT_REFERENCE]",
    "PAYMENT_REFERENCE",
    kinds,
  );

  text = replaceLabelledIdentifier(
    text,
    /\b((?:loyalty|member(?:ship)?|rewards?|club|air\s+miles|pc\s+optimum)\s*(?:id|no\.?|number|#|card)\s*[:#-]?\s*)[A-Z0-9][A-Z0-9-]{3,}\b/gi,
    "[REDACTED_LOYALTY_ID]",
    "LOYALTY_IDENTIFIER",
    kinds,
  );

  text = replaceLabelledIdentifier(
    text,
    /\b(terminal\s*(?:id|no\.?|number|#)\s*[:#-]?\s*)[A-Z0-9][A-Z0-9-]{3,}\b/gi,
    "[REDACTED_TERMINAL_ID]",
    "TERMINAL_IDENTIFIER",
    kinds,
  );

  text = replaceLabelledIdentifier(
    text,
    /\b((?:auth(?:orization)?|approval)\s*(?:(?:id|no\.?|number|#|code)\s*[:#-]?\s*|[:#-]\s*))[A-Z0-9][A-Z0-9-]{3,}\b/gi,
    "[REDACTED_AUTHORIZATION_ID]",
    "AUTHORIZATION_IDENTIFIER",
    kinds,
  );

  text = replaceLabelledIdentifier(
    text,
    /\b((?:reference|ref)\s*(?:(?:id|no\.?|number|#|code)\s*[:#-]?\s*|[:#-]\s*))[A-Z0-9][A-Z0-9-]{3,}\b/gi,
    "[REDACTED_REFERENCE_ID]",
    "REFERENCE_IDENTIFIER",
    kinds,
  );

  return text;
}

function replaceAndRecord(
  text: string,
  pattern: RegExp,
  replacement: string,
  kind: RedactionKind,
  kinds: Set<RedactionKind>,
): string {
  return text.replace(pattern, () => {
    kinds.add(kind);
    return replacement;
  });
}

function replaceLabelledIdentifier(
  text: string,
  pattern: RegExp,
  replacement: string,
  kind: RedactionKind,
  kinds: Set<RedactionKind>,
): string {
  return text.replace(pattern, (_match, label: string) => {
    kinds.add(kind);
    return `${label}${replacement}`;
  });
}

function passesLuhnCheck(value: string): boolean {
  const digits = value.replace(/\D/g, "");
  let sum = 0;
  let doubleDigit = false;
  for (let index = digits.length - 1; index >= 0; index -= 1) {
    let digit = Number(digits[index]);
    if (doubleDigit) {
      digit *= 2;
      if (digit > 9) digit -= 9;
    }
    sum += digit;
    doubleDigit = !doubleDigit;
  }
  return sum % 10 === 0;
}
