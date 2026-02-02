# test/AGENTS.md — Tests

Write tests for business logic and critical user flows. Avoid flaky tests.

## What to test

- Unit tests: repositories and use cases
- Widget tests: critical UI components
- Integration tests: main user flows

Minimum coverage target: 80% for critical logic (use cases/repositories).

## Conventions

- Prefer Arrange/Act/Assert (Given/When/Then) structure.
- Use stable fixtures; avoid random time/network dependencies.
- If you use property-based tests, label them clearly (see detailed standards).

## Commands

- Run all tests: `flutter test`
- If a task mentions a specific suite, run the smallest relevant subset first, then the full suite.

See `docs/codium_code_quality_standards.md` for additional test conventions.
