import { readFileSync } from "node:fs";
import { resolve } from "node:path";

import { describe, expect, it } from "vitest";

describe("Firestore Smart Receipt rules", () => {
  it.each(["smartReceiptRateLimits", "smartReceiptProjectBudgets"])(
    "keeps %s server-only",
    (collection) => {
      const rules = readFileSync(
        resolve(__dirname, "..", "..", "firestore.rules"),
        "utf8",
      );
      const escapedCollection = collection.replace(
        /[.*+?^${}()|[\]\\]/g,
        "\\$&",
      );
      const serverOnlyRule = new RegExp(
        `match \\/${escapedCollection}\\/\\{documentId\\} \\{\\s*allow read, write: if false;`,
      );

      expect(rules).toMatch(serverOnlyRule);
    },
  );
});
