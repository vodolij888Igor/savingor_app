import { readFileSync } from "node:fs";
import { resolve } from "node:path";

import {
  assertFails,
  assertSucceeds,
  initializeTestEnvironment,
  type RulesTestEnvironment,
} from "@firebase/rules-unit-testing";
import { doc, getDoc, setDoc } from "firebase/firestore";
import { afterAll, beforeAll, describe, it } from "vitest";

let testEnvironment: RulesTestEnvironment;

beforeAll(async () => {
  testEnvironment = await initializeTestEnvironment({
    projectId: "savingor-smart-receipt-test",
    firestore: {
      rules: readFileSync(
        resolve(__dirname, "..", "..", "firestore.rules"),
        "utf8",
      ),
    },
  });
});

afterAll(async () => {
  await testEnvironment.cleanup();
});

describe("Firestore Smart Receipt quota rules", () => {
  it.each(["smartReceiptRateLimits", "smartReceiptProjectBudgets"])(
    "denies authenticated client reads and writes to %s",
    async (collectionName) => {
      const unauthenticatedDatabase = testEnvironment
        .unauthenticatedContext()
        .firestore();
      const clientDatabase = testEnvironment
        .authenticatedContext("user-1")
        .firestore();
      const documentPath = `${collectionName}/test-document`;

      await testEnvironment.withSecurityRulesDisabled(async (context) => {
        await assertSucceeds(
          setDoc(doc(context.firestore(), documentPath), { test: true }),
        );
      });

      await assertFails(
        setDoc(doc(clientDatabase, documentPath), { test: false }),
      );
      await assertFails(getDoc(doc(clientDatabase, documentPath)));
      await assertFails(
        setDoc(doc(unauthenticatedDatabase, documentPath), { test: false }),
      );
    },
  );
});
