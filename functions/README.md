# Savingor Smart Receipt backend (Phase 1)

This Firebase Functions v2 TypeScript package is the secure contract foundation
for **Savingor Smart Receipt — GPT-5.6 Receipt Intelligence**. It does not change
the Flutter receipt flow and does not accept, upload, or persist receipt images.

## Runtime architecture

`extractSmartReceipt` is an HTTPS callable function in
`northamerica-northeast1`. It requires Firebase Authentication before reading
secret configuration, validates and bounds the request, recursively redacts OCR
and parser-candidate strings, reserves quota, calls OpenAI, strictly validates
the structured response, and finalizes quota only after success. It never writes
a receipt; the existing client save/review flow remains the owner of that future
Phase 2 action.

The accepted request is:

```text
rawOcrText: string (1..16,000 characters)
locale: locale tag (up to 35 characters)
currency: three-letter code
parserCandidate: deterministic store/date/totals/items candidate (up to 50 items)
```

Unknown top-level fields are rejected, so image bytes and image URLs are not
accepted. The response contains `receipt` plus non-sensitive processing metadata.
Every uncertain scalar is nullable. Item `category` is explicitly a derived
classification that may be conservatively inferred from the printed item name;
it must be `null` when uncertain. Server warnings cover invalid values, date
plausibility, currency conflicts, subtotal/tax/total reconciliation, per-line
arithmetic, item-total reconciliation, and redaction.

## Security and privacy controls

- `OPENAI_API_KEY` is declared with `defineSecret` and bound only to this
  function. Set it interactively with
  `firebase functions:secrets:set OPENAI_API_KEY`; never use a committed env file.
- OpenAI receives redacted OCR text, locale/currency context, and bounded parser
  candidates only. The same recursive policy sanitizes every nested candidate
  string while leaving numeric receipt values unchanged. No image is sent.
- Responses requests use `store: false` and a one-way SHA-256-derived
  `safety_identifier`; raw Firebase user IDs are not sent to OpenAI.
- Logs contain counts and error classes only. They exclude OCR text, parser
  candidates, model output, identifiers, and secret values.
- Firestore transactions enforce 3 validated attempts per user per minute, 10
  successful uses per user per UTC day, and 200 successful uses project-wide per
  UTC day. Active calls hold 90-second reservations in
  `smartReceiptRateLimits` and `smartReceiptProjectBudgets`. Successful validated
  responses atomically finalize both counters; controlled failures release both.
  Expired reservations are ignored and pruned, so abandoned calls cannot
  permanently consume quota. Firestore rules explicitly deny client access to
  both collections.
- Function-level bounds (`maxInstances: 5`, `concurrency: 10`, 60-second timeout,
  no automatic OpenAI retry, a 30-second OpenAI operation timeout, and 8,192
  output tokens) cap demo exposure.

The 50-item maximum is intended to cover practical grocery receipts while
keeping request cost and latency bounded. The 8,192-token response allowance
provides headroom for all required nullable item fields plus low-effort reasoning.
Incomplete or structurally incomplete JSON is rejected rather than partially
accepted.

## Existing AI Savings Assistant boundary

The pre-existing Flutter AI Savings Assistant files are preserved unchanged.
That legacy development path can still call an OpenAI-compatible endpoint from
the client when configured. It is not used by Smart Receipt and is not covered
by the Firebase Secret Manager boundary described here. Before production use,
the legacy assistant needs a separate authenticated backend migration; Smart
Receipt code must never be connected to its client-side credential path.

## App Check rollout

The callable explicitly sets `enforceAppCheck: false` so the current Flutter demo
is not blocked before the client is configured. Firebase still validates a token
when one is supplied, and the response reports only whether verified App Check
context was present.

Before production enforcement:

1. Add and configure the Flutter App Check SDK and platform providers.
2. Verify valid-token metrics for all supported builds and Firebase emulators.
3. Change `enforceAppCheck` to `true` and redeploy.
4. Consider replay protection for this endpoint only after measuring the added
   latency and configuring limited-use client tokens.

Also configure Firestore TTL policies for `smartReceiptRateLimits.expiresAt` and
`smartReceiptProjectBudgets.expiresAt`. Documents are written with a three-day
expiry timestamp, but physical TTL deletion must be enabled in the Firebase
project. Reservation capacity already uses the embedded reservation expiry and
does not wait for physical document deletion.

## Dependency audit status

`npm audit --omit=dev` currently reports nine moderate transitive findings for
`uuid <11.1.1` through Firebase Admin's Firestore and Storage dependency trees.
They are temporarily accepted and are not resolved. The proposed
`npm audit fix --force` action would perform a breaking Firebase Admin downgrade
and must not be used. Current dependency ranges provide no non-breaking fix; a
future Firebase major upgrade must be evaluated and regression-tested separately.

## Local verification

From `functions/`:

```text
npm ci
npm run format
npm run lint
npm run typecheck
npm test
npm run test:emulator
npm run build
```

Firestore Emulator tests require Java 21.

Tests replace the OpenAI Responses network boundary with deterministic mocks and
exercise callable authentication/configuration ordering, privacy, strict output,
provider failures, reservation contention/expiry/refunds, project budgeting,
Firestore transaction adaptation, and server-only rule declarations. Production
code contains no fake model response or API-key fallback. GitHub Actions runs the
backend verification on Node 22.

## Official guidance verified on 2026-07-20

- GPT-5.6 model guidance and reasoning options:
  https://developers.openai.com/api/docs/guides/model-guidance?model=gpt-5.6
- Exact GPT-5.6 Sol model page (`gpt-5.6-sol`):
  https://developers.openai.com/api/docs/models/gpt-5.6-sol
- Responses API create contract:
  https://developers.openai.com/api/reference/resources/responses/methods/create
- Strict Structured Outputs and Node JSON Schema request shape:
  https://developers.openai.com/api/docs/guides/structured-outputs
- Reasoning configuration in Responses:
  https://developers.openai.com/api/docs/guides/reasoning
- Safety identifiers:
  https://developers.openai.com/api/docs/guides/safety-best-practices
- Data controls and Responses retention:
  https://developers.openai.com/api/docs/guides/your-data

Firebase implementation references:

- Secrets: https://firebase.google.com/docs/functions/config-env
- Callable functions: https://firebase.google.com/docs/functions/callable
- App Check enforcement: https://firebase.google.com/docs/app-check/cloud-functions
- Functions runtime controls: https://firebase.google.com/docs/functions/manage-functions
