# lib/domain/AGENTS.md — Domain layer

Domain must remain pure and framework-agnostic.

## Non-negotiables

- No imports from Flutter/UI, persistence, networking, JSON annotations, database entities, or generated code.
- Define abstractions here (repository interfaces, data source interfaces if used as contracts).
- Domain models are pure Dart types (no DTO concerns).

## Use cases

- Use Cases orchestrate business logic and are the ONLY entry point from Presentation into Domain logic.
- Keep use cases small; compose when needed.
- Prefer explicit input/output types and domain-specific errors.

## Error model

- Do not throw raw infrastructure exceptions from Domain.
- Use domain-specific error/failure types; map infrastructure errors in Data layer.

## Naming and clarity

- Use intention-revealing names; avoid abbreviations.
- Keep public APIs stable and predictable.

If you need details (examples, patterns), open `docs/praxis_code_quality_standards.md`.
