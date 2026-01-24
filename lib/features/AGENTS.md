# lib/features/AGENTS.md — Feature modules (Presentation)

Each feature should be self-contained and depend only on Domain abstractions/use cases.

## Structure

- Feature-specific widgets: `lib/features/<feature>/widgets/` (sibling to `view/`)
- Shared widgets: `lib/core/widgets/`

Prefer the rule:
- Used by one feature → keep inside that feature.
- Used by multiple features → promote to `lib/core/`.

## Widgets

- Avoid “widget functions” for complex UI; use dedicated Widget classes for readability/testability.
- Keep screens in `view/` and compose smaller widgets from `widgets/`.

## Localization

- Extract localization and theme early inside `build()` (avoid repeated calls and deep nesting).
- Do not hardcode user-facing strings; use the localization mechanism.

## State management

- BLoC/Cubit depends on Domain use cases; do not inject repositories directly into BLoC/Cubit.

See `docs/codium_code_quality_standards.md` for detailed UI conventions.
