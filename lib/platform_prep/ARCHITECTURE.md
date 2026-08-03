# Application Platform Architecture

Reusable multi-product core under `lib/platform_prep/`. Product apps
(Savingor, future language-learning / psychology apps) supply modules, flags,
and live routing; they do not own platform internals.

**Stable public entry:** `PlatformFacade` (`bootstrap.facade`) for structure;
`PlatformQuery` (`bootstrap.platformQuery`) for read-only queries.
Import via `package:savingor_app/platform_prep/platform_prep.dart` or the
layer barrels (`platform/platform.dart`, `query/query.dart`, …).

Live GoRouter and UI remain owned by the product (`app_router.dart`, features).
Platform types are metadata only.

## Layers (inside → out)

| Layer | Type | Ownership |
|-------|------|-----------|
| Leaf services | catalogs, activation, lifecycle, discovery, module query, flags | Built once by `PlatformBootstrap`; real state lives here |
| Application | `PlatformApplication` | Owns the six public leaf surfaces (navigation + module APIs) |
| Runtime → Environment → Kernel | thin views | Each stores only its parent; leaf getters delegate |
| Facade | `PlatformFacade` | Stable structural entry over the kernel |
| Registry | `PlatformRegistry` | Central handle to facade / kernel / … / application |
| Discovery / Lifecycle / Activation | sibling APIs | Read-only views derived from registry or environment |
| Query | `PlatformQuery` | Single read-only query surface composing the siblings |
| Bootstrap | `PlatformBootstrap` | Composition root; product factory (e.g. `.savingor()`) |

Chain (identity preserved across getters):

```
Bootstrap
  └─ Application (leaf owner)
       └─ Runtime → Environment → Kernel → Facade → Registry
  └─ Discovery(registry), Lifecycle(environment), Activation(lifecycle)
  └─ Query(facade + registry + discovery + lifecycle + activation)
```

## Public APIs

- **Structure:** `PlatformFacade` → `kernel` / `environment` / `runtime` / `application`
- **Queries:** `PlatformQuery` (modules, routes, shell tabs, readiness)
- **Modules:** `AppModule`, registries/catalogs, activation/lifecycle/discovery/query services
- **Flags:** `FeatureFlagService` (+ local impl)
- **Navigation metadata:** route/shell-tab contributions and catalogs (not live routing)

Backwards-compatible constructors on Runtime/Environment/Kernel/Facade/Registry
still accept optional sibling references; when provided they must be identical
to the parent’s surfaces (asserted in debug).

## Extension points

1. **`AppModule`** — routes, shell tabs, module id
2. **`ModuleActivationRule` + `FeatureFlagService`** — which modules activate
3. **`PlatformBootstrap` factory** — product-specific composition (registry, rules, parity checks)
4. Product navigation adapters / parity validators (under `lib/savingor/`) — not live GoRouter

## Module boundaries

| Package area | Responsibility |
|--------------|----------------|
| `platform_prep/` | Reusable platform core (this tree) |
| `savingor/` | Savingor product modules, bootstrap provider, unused-by-live routing adapters |
| `app/`, `features/` | Live Flutter app, GoRouter, UI |

Do not move live routing ownership into `platform_prep`. Do not introduce a
second GoRouter from platform adapters without an explicit migration task.
