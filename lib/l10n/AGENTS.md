# AGENTS — lib/l10n (Localization)

`app_localizations*.dart` files are generated output. Do not edit them by hand.

## Source of truth

- Edit only the ARB source files in this directory (e.g., `app_en.arb`, `app_ru.arb`).
- Generated Dart files will be overwritten on regeneration.

## Conventions

- Keep keys stable and descriptive. Do not rename keys unless the change is intentional and the usage is updated across the app.
- Prefer ICU MessageFormat for plurals/gender where needed (do not hardcode plural logic in Dart).
- Keep placeholders consistent across languages (same names and compatible formats).

## Regenerate (FVM)

Run from `praxis_flutter/`:

```bash
fvm flutter gen-l10n
