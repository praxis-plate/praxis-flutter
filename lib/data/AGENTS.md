# lib/data/AGENTS.md — Data layer

Data implements Domain contracts and owns infrastructure concerns.

## Responsibilities

- Implement repository interfaces defined in Domain.
- Use DataSources for persistence/network calls.
- Map Data entities/DTOs ↔ Domain models via dedicated mappers.

## Critical rules

- Database access is ONLY allowed in DataSource classes. Repositories call DataSources and map to Domain.
- Repositories must not depend on concrete database types (e.g., AppDatabase); that belongs in DataSource.

## Models and mapping

- Domain models are NOT DTOs. Do not add JSON annotations or persistence fields to Domain models.
- Keep one model per persistence table/entity; avoid “mega models” that combine unrelated tables.
- Serialization belongs to DTO/entity types in Data layer, not Domain.

## Dependency injection

- Prefer interface-first wiring: Domain depends on abstractions; Data provides implementations.
- Keep constructors explicit; avoid service-locator anti-patterns in Data.

See `docs/praxis_code_quality_standards.md` for concrete examples and allowed patterns.
