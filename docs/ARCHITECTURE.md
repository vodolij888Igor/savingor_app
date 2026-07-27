# Savingor — Architecture Overview

This document describes the current small-scale Flutter architecture used in the Savingor (Savingor) MVP and a simple set of rules for future contributors.

## Project layout (relevant folders)

- `lib/main.dart` — App entry; uses `MaterialApp.router` with `appRouter`.
- `lib/app/router/app_router.dart` — Central GoRouter configuration and routes.
- `lib/app/presentation/` — UI layer (screens, widgets):
  - `screens/` — Feature screens (Deals, Deal details, Scanner, Shopping).
  - `widgets/` — Reusable UI pieces (e.g. `bottom_nav_shell.dart`).
- `lib/app/domain/models/` — Plain data models (e.g. `deal.dart`).
- `lib/app/data/mock/` — Mock data used by the MVP (e.g. `mock_deals.dart`).

## Current routing (go_router)

- `/` → `HomeScreen` (entry card view).
- ShellRoute (bottom nav) wraps the three tab routes so bottom navigation persists:
  - `/deals` → Deals list screen (`DealsMapScreen`).
  - `/deals/:id` → Deal details screen (`DealDetailsScreen`).
  - `/scanner` → Receipt Scanner placeholder.
  - `/shopping` → Shopping List placeholder.

Notes on navigation rules:

- The `BottomNavShell` determines the active tab by inspecting the current location (e.g. `location.startsWith('/deals')`).
- Deal list cards navigate to `/deals/{id}` (string id on the `Deal` model).
- Route builders may return a small "not found" scaffold if an id lookup fails.

## Data layer plan

- MVP uses `mock_deals.dart` in `lib/app/data/mock/` for rapid iteration.
- Future plan:
  - Add a repository layer `lib/app/data/repository/` that provides an interface and maps to either mock or remote backends.
  - Backends (v0.2+): simple REST API (FastAPI recommended) exposing deals, favorites, and receipts endpoints.

## UI & coding rules

- Keep UI changes localized to `lib/app/presentation/...` unless a cross-cutting change is required.
- Prefer minimal diffs and avoid wide refactors during rapid MVP iterations.
- Do not add packages without explicit approval — prefer built-in Flutter SDK where possible.
- Keep `flutter analyze` clean: fix `prefer_const_constructors` and other lints when easy.
- Prefer `const` constructors and small widget functions.
- Keep files focused and small (one widget/screen per file where sensible).

## Bottom navigation shell rules

- The app uses `go_router` with a `ShellRoute` so the bottom bar is persistent across main tabs.
- ShellRoute children should be simple `GoRoute`s for the tabs and for nested detail routes (e.g. `/deals/:id`).
- When returning from a detail route, the shell should keep the same selected tab.

## Testing & verification

- Use `flutter analyze` locally before pushing changes. The CI should mirror the same analyzer settings.
- Run `flutter run` and exercise the bottom nav, deal details, and filters to ensure navigation and UI remain consistent.

## Contributors — quick rules

- When implementing features: prefer stateful screen-local state for simple filters. Add providers or state management later if warranted.
- Document API contract changes in `docs/` and keep the `PRODUCT_BRIEF.md` and `ARCHITECTURE.md` in sync with code.
