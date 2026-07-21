import { createHash, randomUUID } from "node:crypto";

import type { Firestore } from "firebase-admin/firestore";

import type { QuotaReservation, SmartReceiptQuotaManager } from "./contract";

export const QUOTA_LIMITS = {
  attemptsPerMinute: 3,
  successfulUsesPerUserUtcDay: 10,
  successfulUsesProjectUtcDay: 200,
  reservationTtlSeconds: 90,
  documentTtlDays: 3,
} as const;

export type RateLimitKind = "minute" | "user-day" | "project-day";

export class RateLimitExceededError extends Error {
  constructor(
    readonly kind: RateLimitKind,
    readonly retryAfterSeconds: number,
  ) {
    super(`Smart receipt ${kind} rate limit exceeded`);
    this.name = "RateLimitExceededError";
  }
}

export class QuotaReservationError extends Error {
  constructor(message: string) {
    super(message);
    this.name = "QuotaReservationError";
  }
}

export interface QuotaTransaction {
  get(documentPath: string): Promise<Record<string, unknown> | null>;
  set(documentPath: string, data: Record<string, unknown>): void;
}

export interface QuotaTransactionStore {
  runTransaction<T>(
    update: (transaction: QuotaTransaction) => Promise<T>,
  ): Promise<T>;
}

/** Keeps Firebase Admin details at the network boundary for deterministic tests. */
export class FirestoreQuotaTransactionStore implements QuotaTransactionStore {
  constructor(private readonly firestore: Firestore) {}

  async runTransaction<T>(
    update: (transaction: QuotaTransaction) => Promise<T>,
  ): Promise<T> {
    return this.firestore.runTransaction(async (transaction) =>
      update({
        get: async (documentPath) => {
          const snapshot = await transaction.get(
            this.firestore.doc(documentPath),
          );
          return snapshot.exists ? (snapshot.data() ?? null) : null;
        },
        set: (documentPath, data) => {
          transaction.set(this.firestore.doc(documentPath), data);
        },
      }),
    );
  }
}

interface StoredReservation {
  id: string;
  expiresAtMs: number;
}

interface UserQuotaState {
  dayKey: string;
  successfulUses: number;
  minuteKey: string;
  minuteAttempts: number;
  reservations: StoredReservation[];
  finalizedReservationIds: string[];
}

interface ProjectQuotaState {
  dayKey: string;
  successfulUses: number;
  reservations: StoredReservation[];
  finalizedReservationIds: string[];
}

export class FirestoreSmartReceiptQuotaManager implements SmartReceiptQuotaManager {
  constructor(
    private readonly store: QuotaTransactionStore,
    private readonly clock: () => Date = () => new Date(),
    private readonly createReservationId: () => string = randomUUID,
  ) {}

  async reserve(uid: string): Promise<QuotaReservation> {
    const now = this.clock();
    const nowMs = now.getTime();
    const dayKey = utcDayKey(now);
    const minuteKey = utcMinuteKey(now);
    const uidHash = createHash("sha256").update(uid, "utf8").digest("hex");
    const reservationId = this.createReservationId();
    const userDocumentPath = `smartReceiptRateLimits/${uidHash.slice(0, 40)}_${compactDayKey(dayKey)}`;
    const projectDocumentPath = `smartReceiptProjectBudgets/${compactDayKey(dayKey)}`;
    const reservation: StoredReservation = {
      id: reservationId,
      expiresAtMs: nowMs + QUOTA_LIMITS.reservationTtlSeconds * 1000,
    };

    await this.store.runTransaction(async (transaction) => {
      const [rawUser, rawProject] = await Promise.all([
        transaction.get(userDocumentPath),
        transaction.get(projectDocumentPath),
      ]);
      const user = readUserState(rawUser, dayKey, minuteKey, nowMs);
      const project = readProjectState(rawProject, dayKey, nowMs);

      if (user.minuteAttempts >= QUOTA_LIMITS.attemptsPerMinute) {
        throw new RateLimitExceededError("minute", secondsUntilNextMinute(now));
      }
      if (
        user.successfulUses + user.reservations.length >=
        QUOTA_LIMITS.successfulUsesPerUserUtcDay
      ) {
        throw new RateLimitExceededError(
          "user-day",
          secondsUntilNextUtcDay(now),
        );
      }
      if (
        project.successfulUses + project.reservations.length >=
        QUOTA_LIMITS.successfulUsesProjectUtcDay
      ) {
        throw new RateLimitExceededError(
          "project-day",
          secondsUntilNextUtcDay(now),
        );
      }

      user.minuteAttempts += 1;
      user.reservations.push(reservation);
      project.reservations.push(reservation);
      transaction.set(
        userDocumentPath,
        userDocumentData(user, uidHash.slice(0, 40), now),
      );
      transaction.set(projectDocumentPath, projectDocumentData(project, now));
    });

    return {
      reservationId,
      reservedDayKey: dayKey,
      userDocumentPath,
      projectDocumentPath,
    };
  }

  async finalize(reservation: QuotaReservation): Promise<void> {
    const now = this.clock();
    const nowMs = now.getTime();
    const dayKey = reservation.reservedDayKey;
    const minuteKey = utcMinuteKey(now);

    await this.store.runTransaction(async (transaction) => {
      const [rawUser, rawProject] = await Promise.all([
        transaction.get(reservation.userDocumentPath),
        transaction.get(reservation.projectDocumentPath),
      ]);
      const user = readUserState(rawUser, dayKey, minuteKey, nowMs);
      const project = readProjectState(rawProject, dayKey, nowMs);
      const alreadyFinalized =
        user.finalizedReservationIds.includes(reservation.reservationId) &&
        project.finalizedReservationIds.includes(reservation.reservationId);
      if (alreadyFinalized) return;

      const userHasReservation = removeReservation(
        user.reservations,
        reservation.reservationId,
      );
      const projectHasReservation = removeReservation(
        project.reservations,
        reservation.reservationId,
      );
      if (!userHasReservation || !projectHasReservation) {
        throw new QuotaReservationError(
          "Smart receipt quota reservation is missing or expired",
        );
      }

      user.successfulUses += 1;
      project.successfulUses += 1;
      user.finalizedReservationIds.push(reservation.reservationId);
      project.finalizedReservationIds.push(reservation.reservationId);
      transaction.set(
        reservation.userDocumentPath,
        userDocumentData(
          user,
          userHashFromPath(reservation.userDocumentPath),
          now,
        ),
      );
      transaction.set(
        reservation.projectDocumentPath,
        projectDocumentData(project, now),
      );
    });
  }

  async release(reservation: QuotaReservation): Promise<void> {
    const now = this.clock();
    const nowMs = now.getTime();
    const dayKey = reservation.reservedDayKey;
    const minuteKey = utcMinuteKey(now);

    await this.store.runTransaction(async (transaction) => {
      const [rawUser, rawProject] = await Promise.all([
        transaction.get(reservation.userDocumentPath),
        transaction.get(reservation.projectDocumentPath),
      ]);
      const user = readUserState(rawUser, dayKey, minuteKey, nowMs);
      const project = readProjectState(rawProject, dayKey, nowMs);
      removeReservation(user.reservations, reservation.reservationId);
      removeReservation(project.reservations, reservation.reservationId);
      transaction.set(
        reservation.userDocumentPath,
        userDocumentData(
          user,
          userHashFromPath(reservation.userDocumentPath),
          now,
        ),
      );
      transaction.set(
        reservation.projectDocumentPath,
        projectDocumentData(project, now),
      );
    });
  }
}

function readUserState(
  value: Record<string, unknown> | null,
  dayKey: string,
  minuteKey: string,
  nowMs: number,
): UserQuotaState {
  if (value === null || value.dayKey !== dayKey) {
    return freshUserState(dayKey, minuteKey);
  }
  const state: UserQuotaState = {
    dayKey,
    successfulUses: nonNegativeInteger(value.successfulUses),
    minuteKey:
      typeof value.minuteKey === "string" ? value.minuteKey : minuteKey,
    minuteAttempts: nonNegativeInteger(value.minuteAttempts),
    reservations: storedReservations(value.reservations),
    finalizedReservationIds: stringArray(value.finalizedReservationIds),
  };
  state.reservations = state.reservations.filter(
    (reservation) => reservation.expiresAtMs > nowMs,
  );
  if (state.minuteKey !== minuteKey) {
    state.minuteKey = minuteKey;
    state.minuteAttempts = 0;
  }
  return state;
}

function readProjectState(
  value: Record<string, unknown> | null,
  dayKey: string,
  nowMs: number,
): ProjectQuotaState {
  if (value === null || value.dayKey !== dayKey) {
    return freshProjectState(dayKey);
  }
  return {
    dayKey,
    successfulUses: nonNegativeInteger(value.successfulUses),
    reservations: storedReservations(value.reservations).filter(
      (reservation) => reservation.expiresAtMs > nowMs,
    ),
    finalizedReservationIds: stringArray(value.finalizedReservationIds),
  };
}

function freshUserState(dayKey: string, minuteKey: string): UserQuotaState {
  return {
    dayKey,
    successfulUses: 0,
    minuteKey,
    minuteAttempts: 0,
    reservations: [],
    finalizedReservationIds: [],
  };
}

function freshProjectState(dayKey: string): ProjectQuotaState {
  return {
    dayKey,
    successfulUses: 0,
    reservations: [],
    finalizedReservationIds: [],
  };
}

function userDocumentData(
  state: UserQuotaState,
  uidHash: string,
  now: Date,
): Record<string, unknown> {
  return {
    ...state,
    uidHash,
    updatedAt: now,
    expiresAt: documentExpiry(now),
  };
}

function projectDocumentData(
  state: ProjectQuotaState,
  now: Date,
): Record<string, unknown> {
  return {
    ...state,
    updatedAt: now,
    expiresAt: documentExpiry(now),
  };
}

function storedReservations(value: unknown): StoredReservation[] {
  if (!Array.isArray(value)) return [];
  return value.flatMap((entry) => {
    if (
      typeof entry !== "object" ||
      entry === null ||
      Array.isArray(entry) ||
      typeof (entry as Record<string, unknown>).id !== "string" ||
      typeof (entry as Record<string, unknown>).expiresAtMs !== "number" ||
      !Number.isFinite((entry as Record<string, unknown>).expiresAtMs)
    ) {
      return [];
    }
    return [
      {
        id: (entry as Record<string, unknown>).id as string,
        expiresAtMs: (entry as Record<string, unknown>).expiresAtMs as number,
      },
    ];
  });
}

function stringArray(value: unknown): string[] {
  return Array.isArray(value)
    ? value.filter((entry): entry is string => typeof entry === "string")
    : [];
}

function nonNegativeInteger(value: unknown): number {
  return typeof value === "number" && Number.isSafeInteger(value) && value >= 0
    ? value
    : 0;
}

function removeReservation(
  reservations: StoredReservation[],
  reservationId: string,
): boolean {
  const index = reservations.findIndex((entry) => entry.id === reservationId);
  if (index < 0) return false;
  reservations.splice(index, 1);
  return true;
}

function userHashFromPath(documentPath: string): string {
  const documentId = documentPath.split("/").at(-1) ?? "";
  return documentId.split("_")[0] ?? "";
}

function documentExpiry(now: Date): Date {
  const expiresAt = new Date(now);
  expiresAt.setUTCDate(expiresAt.getUTCDate() + QUOTA_LIMITS.documentTtlDays);
  return expiresAt;
}

function utcDayKey(now: Date): string {
  return now.toISOString().slice(0, 10);
}

function compactDayKey(dayKey: string): string {
  return dayKey.replaceAll("-", "");
}

function utcMinuteKey(now: Date): string {
  return now.toISOString().slice(0, 16);
}

function secondsUntilNextMinute(now: Date): number {
  return 60 - now.getUTCSeconds();
}

function secondsUntilNextUtcDay(now: Date): number {
  const next = new Date(now);
  next.setUTCHours(24, 0, 0, 0);
  return Math.max(1, Math.ceil((next.getTime() - now.getTime()) / 1000));
}
