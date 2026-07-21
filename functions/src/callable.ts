import { HttpsError } from "firebase-functions/v2/https";

import type {
  ReceiptExtractionModel,
  SmartReceiptQuotaManager,
} from "./contract";
import {
  handleExtractSmartReceipt,
  requireAuthenticatedUid,
  type CallableRequestLike,
  type SafeLogger,
} from "./extractSmartReceipt";

export interface SmartReceiptCallableDependencies {
  getOpenAIApiKey(): string;
  createModel(apiKey: string): ReceiptExtractionModel;
  quotaManager: SmartReceiptQuotaManager;
  clock?: () => Date;
  logger?: SafeLogger;
}

export function createExtractSmartReceiptCallableHandler(
  dependencies: SmartReceiptCallableDependencies,
): (
  request: CallableRequestLike,
) => ReturnType<typeof handleExtractSmartReceipt> {
  return async (request) => {
    // Authentication deliberately precedes secret access and model construction.
    requireAuthenticatedUid(request);
    const apiKey = dependencies.getOpenAIApiKey();
    if (!apiKey) {
      throw new HttpsError(
        "failed-precondition",
        "Receipt intelligence is not configured.",
      );
    }
    return handleExtractSmartReceipt(request, {
      model: dependencies.createModel(apiKey),
      quotaManager: dependencies.quotaManager,
      clock: dependencies.clock,
      logger: dependencies.logger,
    });
  };
}
