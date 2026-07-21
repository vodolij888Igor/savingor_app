import { initializeApp } from "firebase-admin/app";
import { getFirestore } from "firebase-admin/firestore";
import { defineSecret } from "firebase-functions/params";
import { logger } from "firebase-functions";
import { onCall } from "firebase-functions/v2/https";

import { createExtractSmartReceiptCallableHandler } from "./callable";
import { createOpenAIReceiptModel } from "./openaiReceiptModel";
import {
  FirestoreQuotaTransactionStore,
  FirestoreSmartReceiptQuotaManager,
} from "./rateLimit";

initializeApp();

const OPENAI_API_KEY = defineSecret("OPENAI_API_KEY");
const quotaManager = new FirestoreSmartReceiptQuotaManager(
  new FirestoreQuotaTransactionStore(getFirestore()),
);
const callableHandler = createExtractSmartReceiptCallableHandler({
  getOpenAIApiKey: () => OPENAI_API_KEY.value(),
  createModel: createOpenAIReceiptModel,
  quotaManager,
  logger,
});

export const extractSmartReceipt = onCall(
  {
    region: "northamerica-northeast1",
    secrets: [OPENAI_API_KEY],
    enforceAppCheck: false,
    consumeAppCheckToken: false,
    timeoutSeconds: 60,
    memory: "256MiB",
    cpu: 1,
    concurrency: 10,
    maxInstances: 5,
  },
  callableHandler,
);
