# lib/AGENTS.md — Application code

This directory contains the Flutter application code. Follow Clean Architecture strictly.

## Architecture (Strict)

The project uses three layers with strict dependency direction:

Presentation (Flutter/UI) → Domain ← Data

### Layer responsibilities

Domain (`lib/domain/`)
- Pure business logic and domain models
- Interfaces only: repositories, data sources (as abstractions)
- No Flutter, no DB/network, no JSON annotations

Data (`lib/data/`)
- Implements Domain interfaces
- DTO/entities, mappers, data sources, caching, persistence, networking
- May depend on infrastructure libraries, but not on Presentation widgets

Presentation (`lib/features/`, `lib/app/`, `lib/core/`)
- Widgets, BLoC/Cubit, navigation, UI composition
- Depends on Domain use cases, never directly on Data implementation types

## Critical rules (always enforce)

1. Database access: ONLY in DataSource classes, NEVER in Repositories.
2. BLoC/Cubit depends on Use Cases, NEVER on Repositories directly.
3. Domain models must be pure (no JSON annotations, no infrastructure dependencies).
4. Keep dependency direction: Presentation → Domain ← Data.

## Code organization

- Use absolute `package:` imports based on the package name in `pubspec.yaml` (e.g., `package:praxis/...`). Do not use relative imports.
- Prefer barrel files only for public exports of a folder; avoid overusing barrels that hide dependencies.

## Code style (high signal)

- Prefer early returns and small functions; reduce nesting.
- No `dynamic` unless strictly unavoidable; keep type safety.
- No commented-out code.
- Logging: use the project’s single logging approach (see detailed standards).
- Error handling: return typed failures / domain errors rather than leaking raw exceptions across layers.

See `docs/praxis_code_quality_standards.md` for the full set of rules and examples.
