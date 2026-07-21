import type { QuotaTransaction, QuotaTransactionStore } from "../src/rateLimit";

export class InMemoryQuotaStore implements QuotaTransactionStore {
  private readonly documents = new Map<string, Record<string, unknown>>();
  private transactionTail: Promise<void> = Promise.resolve();

  async runTransaction<T>(
    update: (transaction: QuotaTransaction) => Promise<T>,
  ): Promise<T> {
    const previous = this.transactionTail;
    let unlock = (): void => undefined;
    this.transactionTail = new Promise<void>((resolve) => {
      unlock = resolve;
    });
    await previous;

    const pendingWrites = new Map<string, Record<string, unknown>>();
    try {
      const result = await update({
        get: async (documentPath) => {
          const value =
            pendingWrites.get(documentPath) ?? this.documents.get(documentPath);
          return value === undefined ? null : structuredClone(value);
        },
        set: (documentPath, data) => {
          pendingWrites.set(documentPath, structuredClone(data));
        },
      });
      for (const [path, data] of pendingWrites) {
        this.documents.set(path, data);
      }
      return result;
    } finally {
      unlock();
    }
  }

  read(documentPath: string): Record<string, unknown> | undefined {
    const value = this.documents.get(documentPath);
    return value === undefined ? undefined : structuredClone(value);
  }

  seed(documentPath: string, data: Record<string, unknown>): void {
    this.documents.set(documentPath, structuredClone(data));
  }
}
