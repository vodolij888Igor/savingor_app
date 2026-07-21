import type { Firestore } from "firebase-admin/firestore";
import { describe, expect, it, vi } from "vitest";

import { FirestoreQuotaTransactionStore } from "../src/rateLimit";

describe("FirestoreQuotaTransactionStore", () => {
  it("performs reads and writes inside the Firebase transaction boundary", async () => {
    const documents = new Map<string, Record<string, unknown>>([
      ["limits/user", { count: 1 }],
    ]);
    const get = vi.fn(async (reference: { path: string }) => ({
      exists: documents.has(reference.path),
      data: () => documents.get(reference.path),
    }));
    const set = vi.fn(
      (reference: { path: string }, data: Record<string, unknown>) => {
        documents.set(reference.path, structuredClone(data));
      },
    );
    const runTransaction = vi.fn(
      async (update: (transaction: unknown) => unknown) => update({ get, set }),
    );
    const firestore = {
      doc: (path: string) => ({ path }),
      runTransaction,
    } as unknown as Firestore;
    const store = new FirestoreQuotaTransactionStore(firestore);

    await store.runTransaction(async (transaction) => {
      const current = await transaction.get("limits/user");
      transaction.set("limits/user", { count: Number(current?.count) + 1 });
    });

    expect(runTransaction).toHaveBeenCalledOnce();
    expect(get).toHaveBeenCalledWith({ path: "limits/user" });
    expect(set).toHaveBeenCalledWith({ path: "limits/user" }, { count: 2 });
  });
});
