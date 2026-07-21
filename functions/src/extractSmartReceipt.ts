import { HttpsError } from "firebase-functions/v2/https";

import type {
  ExtractSmartReceiptResponse,
  QuotaReservation,
  ReceiptExtractionModel,
  SmartReceiptQuotaManager,
  WarningCode,
} from "./contract";
import {
  ModelRefusalError,
  ModelResponseError,
  OPENAI_MODEL,
  safetyIdentifierForUid,
} from "./openaiReceiptModel";
import {
  InputValidationError,
  validateExtractSmartReceiptInput,
} from "./requestValidation";
import { sanitizeReceiptData } from "./redaction";
import { RateLimitExceededError } from "./rateLimit";
import {
  ReceiptStructureError,
  validateModelReceipt,
} from "./receiptValidation";

export interface CallableRequestLike {
  data: unknown;
  auth?: { uid: string } | null;
  app?: unknown;
}

export interface SafeLogger {
  info(message: string, metadata: Record<string, unknown>): void;
  warn(message: string, metadata: Record<string, unknown>): void;
}

export interface ExtractSmartReceiptDependencies {
  model: ReceiptExtractionModel;
  quotaManager: SmartReceiptQuotaManager;
  clock?: () => Date;
  logger?: SafeLogger;
}

export async function handleExtractSmartReceipt(
  request: CallableRequestLike,
  dependencies: ExtractSmartReceiptDependencies,
): Promise<ExtractSmartReceiptResponse> {
  const uid = requireAuthenticatedUid(request);

  const now = dependencies.clock?.() ?? new Date();
  const appCheckVerified = request.app !== undefined && request.app !== null;
  let reservation: QuotaReservation | undefined;
  try {
    const input = validateExtractSmartReceiptInput(request.data);
    const sanitization = sanitizeReceiptData({
      rawOcrText: input.rawOcrText,
      parserCandidate: input.parserCandidate,
    });
    reservation = await dependencies.quotaManager.reserve(uid);

    const modelOutput = await dependencies.model.extract({
      ...input,
      rawOcrText: sanitization.value.rawOcrText,
      parserCandidate: sanitization.value.parserCandidate,
      safetyIdentifier: safetyIdentifierForUid(uid),
    });
    const initialWarnings: WarningCode[] =
      sanitization.kinds.length > 0 ? ["IDENTIFIERS_REDACTED"] : [];
    const receipt = validateModelReceipt(
      modelOutput,
      input.currency,
      now,
      initialWarnings,
    );
    await dependencies.quotaManager.finalize(reservation);
    reservation = undefined;

    dependencies.logger?.info("Smart receipt extraction completed", {
      appCheckVerified,
      itemCount: receipt.items.length,
      redactionKindCount: sanitization.kinds.length,
      warningCount: receipt.warningCodes.length,
    });

    return {
      receipt,
      processing: {
        schemaVersion: "1",
        model: OPENAI_MODEL,
        appCheckVerified,
      },
    };
  } catch (error: unknown) {
    if (reservation !== undefined) {
      await releaseReservationSafely(
        dependencies.quotaManager,
        reservation,
        dependencies.logger,
      );
      reservation = undefined;
    }
    if (error instanceof HttpsError) {
      throw error;
    }
    if (error instanceof InputValidationError) {
      throw new HttpsError("invalid-argument", error.message);
    }
    if (error instanceof RateLimitExceededError) {
      throw new HttpsError(
        "resource-exhausted",
        "Smart receipt request limit reached. Try again later.",
        {
          limit: error.kind,
          retryAfterSeconds: error.retryAfterSeconds,
        },
      );
    }
    if (error instanceof ModelRefusalError) {
      throw new HttpsError(
        "failed-precondition",
        "The receipt could not be extracted.",
        { warningCode: "MODEL_REFUSAL" },
      );
    }
    if (
      error instanceof ModelResponseError ||
      error instanceof ReceiptStructureError
    ) {
      dependencies.logger?.warn("Smart receipt model response was unusable", {
        errorType: error.name,
      });
      throw new HttpsError(
        "unavailable",
        "Receipt intelligence is temporarily unavailable.",
      );
    }

    dependencies.logger?.warn("Smart receipt extraction failed", {
      errorType: safeErrorType(error),
    });
    throw new HttpsError(
      "unavailable",
      "Receipt intelligence is temporarily unavailable.",
    );
  }
}

export function requireAuthenticatedUid(request: CallableRequestLike): string {
  if (request.auth?.uid === undefined || request.auth.uid.length === 0) {
    throw new HttpsError(
      "unauthenticated",
      "Firebase Authentication is required.",
    );
  }
  return request.auth.uid;
}

async function releaseReservationSafely(
  quotaManager: SmartReceiptQuotaManager,
  reservation: QuotaReservation,
  logger?: SafeLogger,
): Promise<void> {
  try {
    await quotaManager.release(reservation);
  } catch (error: unknown) {
    logger?.warn("Smart receipt quota reservation release failed", {
      errorType: safeErrorType(error),
    });
  }
}

function safeErrorType(error: unknown): string {
  if (error instanceof Error && error.name) {
    return error.name.slice(0, 80);
  }
  return "UnknownError";
}
