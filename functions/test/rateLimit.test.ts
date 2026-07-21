import { describe, expect, it } from "vitest";

import {
  FirestoreSmartReceiptQuotaManager,
  QUOTA_LIMITS,
  QuotaReservationError,
  RateLimitExceededError,
} from "../src/rateLimit";
import { InMemoryQuotaStore } from "./inMemoryQuotaStore";

const START = new Date("2026-06-20T12:34:45.000Z");

function setup() {
  const store = new InMemoryQuotaStore();
  let now = new Date(START);
  let id = 0;
  const manager = new FirestoreSmartReceiptQuotaManager(
    store,
    () => new Date(now),
    () => `reservation-${++id}`,
  );
  return {
    manager,
    store,
    advance(milliseconds: number) {
      now = new Date(now.getTime() + milliseconds);
    },
  };
}

describe("FirestoreSmartReceiptQuotaManager", () => {
  it("counts an attempt at reservation and a success only at finalization", async () => {
    const { manager, store } = setup();
    const reservation = await manager.reserve("user-1");

    expect(store.read(reservation.userDocumentPath)).toMatchObject({
      successfulUses: 0,
      minuteAttempts: 1,
      reservations: [{ id: "reservation-1" }],
    });

    await manager.finalize(reservation);

    expect(store.read(reservation.userDocumentPath)).toMatchObject({
      successfulUses: 1,
      minuteAttempts: 1,
      reservations: [],
      finalizedReservationIds: ["reservation-1"],
    });
    expect(store.read(reservation.projectDocumentPath)).toMatchObject({
      successfulUses: 1,
      reservations: [],
    });
  });

  it("refunds a controlled failure while retaining the short-window attempt", async () => {
    const { manager, store } = setup();
    const reservation = await manager.reserve("user-1");

    await manager.release(reservation);

    expect(store.read(reservation.userDocumentPath)).toMatchObject({
      successfulUses: 0,
      minuteAttempts: 1,
      reservations: [],
    });
    expect(store.read(reservation.projectDocumentPath)).toMatchObject({
      successfulUses: 0,
      reservations: [],
    });
  });

  it("is idempotent when finalization is retried", async () => {
    const { manager, store } = setup();
    const reservation = await manager.reserve("user-1");

    await manager.finalize(reservation);
    await manager.finalize(reservation);

    expect(store.read(reservation.userDocumentPath)).toMatchObject({
      successfulUses: 1,
      finalizedReservationIds: ["reservation-1"],
    });
  });

  it("serializes concurrent reservations at the per-minute limit", async () => {
    const { manager } = setup();

    const outcomes = await Promise.allSettled(
      Array.from({ length: QUOTA_LIMITS.attemptsPerMinute + 1 }, () =>
        manager.reserve("user-1"),
      ),
    );

    expect(
      outcomes.filter((result) => result.status === "fulfilled"),
    ).toHaveLength(QUOTA_LIMITS.attemptsPerMinute);
    const rejected = outcomes.find((result) => result.status === "rejected");
    expect(rejected).toMatchObject({
      reason: expect.objectContaining({ kind: "minute" }),
    });
  });

  it("expires abandoned reservations without consuming daily success quota", async () => {
    const { manager, store, advance } = setup();
    const abandoned = await manager.reserve("user-1");
    advance((QUOTA_LIMITS.reservationTtlSeconds + 1) * 1000);

    const replacement = await manager.reserve("user-1");

    expect(store.read(replacement.userDocumentPath)).toMatchObject({
      successfulUses: 0,
      reservations: [{ id: replacement.reservationId }],
    });
    await expect(manager.finalize(abandoned)).rejects.toBeInstanceOf(
      QuotaReservationError,
    );
  });

  it("enforces the per-user daily successful-use limit", async () => {
    const { manager, advance } = setup();
    for (
      let count = 0;
      count < QUOTA_LIMITS.successfulUsesPerUserUtcDay;
      count += 1
    ) {
      const reservation = await manager.reserve("user-1");
      await manager.finalize(reservation);
      advance(61_000);
    }

    await expect(manager.reserve("user-1")).rejects.toMatchObject({
      kind: "user-day",
    });
  });

  it("enforces a project-wide daily success circuit breaker", async () => {
    const { manager, store } = setup();
    store.seed("smartReceiptProjectBudgets/20260620", {
      dayKey: "2026-06-20",
      successfulUses: QUOTA_LIMITS.successfulUsesProjectUtcDay,
      reservations: [],
      finalizedReservationIds: [],
    });

    await expect(manager.reserve("user-1")).rejects.toMatchObject({
      kind: "project-day",
    });
  });

  it("writes Firestore-compatible timestamps and a three-day document expiry", async () => {
    const { manager, store } = setup();
    const reservation = await manager.reserve("user-1");
    const data = store.read(reservation.userDocumentPath);

    expect(data?.updatedAt).toEqual(START);
    expect(data?.expiresAt).toEqual(new Date("2026-06-23T12:34:45.000Z"));
  });

  it("returns machine-readable retry windows", async () => {
    const { manager } = setup();
    for (let count = 0; count < QUOTA_LIMITS.attemptsPerMinute; count += 1) {
      await manager.reserve("user-1");
    }

    try {
      await manager.reserve("user-1");
      throw new Error("expected rate limit");
    } catch (error: unknown) {
      expect(error).toBeInstanceOf(RateLimitExceededError);
      expect(error).toMatchObject({ kind: "minute", retryAfterSeconds: 15 });
    }
  });
});
