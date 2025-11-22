# Error Handling System

## Обзор

Система обработки ошибок основана на кодах ошибок (`AppErrorCode`), а не на строковых сообщениях. Это позволяет UI слою самостоятельно решать, как локализовать и отображать ошибки.

## Архитектура

### 1. AppError (базовый класс)

```dart
abstract class AppError implements Exception {
  final AppErrorCode code;
  final String? message;
  final bool canRetry;
}
```

### 2. AppErrorCode (enum)

Все возможные коды ошибок:
- `networkTimeout`, `networkNoInternet`, `networkGeneral`
- `fileNotFound`, `filePermissionDenied`, `fileInsufficientStorage`, `fileCorrupted`, `fileGeneral`
- `databaseLocked`, `databaseConstraint`, `databaseMigration`, `databaseGeneral`
- `validationInvalid`
- `apiUnauthorized`, `apiForbidden`, `apiNotFound`, `apiGeneral`
- `rateLimitExceeded`
- `unknown`

### 3. Конкретные классы ошибок

Каждый тип ошибки имеет свой класс с именованными конструкторами:

```dart
const NetworkError.timeout()
const NetworkError.noInternet()
const FileSystemError.notFound()
const DatabaseError.locked()
// и т.д.
```

**Важно**: Бросайте правильные типы ошибок в местах, где они возникают:
```dart
// В DataSource или Repository
if (file == null) {
  throw const FileSystemError.notFound();
}

if (response.statusCode == 429) {
  throw const RateLimitError();
}
```

## Использование в BLoC

### В BLoC слое

```dart
try {
  // операция
} catch (e, st) {
  GetIt.I<Talker>().handle(e, st);  // ВАЖНО: Логирование через Talker
  final error = e is AppError ? e : const UnknownError();
  
  emit(SomeErrorState(
    errorCode: error.code,
    message: error.message,
    canRetry: error.canRetry,
  ));
}
```

**Обязательно**: 
- Все catch блоки должны логировать ошибки через `GetIt.I<Talker>().handle(e, st)`
- Если `e` это `AppError`, используем его напрямую
- Иначе конвертируем в `UnknownError`

### В State

```dart
final class SomeErrorState extends SomeState {
  final AppErrorCode errorCode;
  final String? message;
  final bool canRetry;

  const SomeErrorState({
    required this.errorCode,
    this.message,
    this.canRetry = false,
  });
}
```

## Использование в UI

### Локализация ошибок

Локализация реализована через:
- `.arb` файлы (`lib/l10n/app_en.arb`, `lib/l10n/app_ru.arb`)
- Extension `AppErrorCodeExtension` с методом `localizedMessage(context)`

```dart
import 'package:codium/core/exceptions/app_error_extensions.dart';

Widget build(BuildContext context) {
  return BlocBuilder<SomeBloc, SomeState>(
    builder: (context, state) {
      if (state is SomeErrorState) {
        // Используем message из state если есть, иначе берем локализованное
        final errorMessage = state.message ?? state.errorCode.localizedMessage(context);
        
        return ErrorDialog(
          message: errorMessage,
          canRetry: state.canRetry,
          onRetry: () => context.read<SomeBloc>().add(RetryEvent()),
        );
      }
      // ...
    },
  );
}
```

Extension автоматически использует текущую локаль из `BuildContext` и возвращает соответствующее сообщение из .arb файлов.

## Преимущества

1. **Типобезопасность**: Коды ошибок - это enum, нельзя ошибиться в написании
2. **Локализация**: UI слой решает, как локализовать сообщения
3. **Гибкость**: Можно добавлять новые коды без изменения BLoC
4. **Тестируемость**: Легко тестировать конкретные коды ошибок
5. **Чистота**: BLoC не знает о локализации, только о кодах

## Добавление новых ошибок

1. Добавить код в `AppErrorCode` enum
2. Создать конструктор в соответствующем классе ошибки
3. Добавить тексты в `.arb` файлы
4. Добавить case в `AppErrorCodeExtension.localizedMessage()`
5. Бросать эту ошибку явно в нужных местах (DataSource, Repository, UseCase)

**Пример**:
```dart
// 1. Добавить в AppErrorCode (lib/core/exceptions/app_error.dart)
enum AppErrorCode {
  // ...
  pdfTooLarge,
}

// 2. Создать конструктор (lib/core/exceptions/app_exception.dart)
class FileSystemError extends AppError {
  const FileSystemError.tooLarge({String? message})
      : super(
          code: AppErrorCode.pdfTooLarge,
          message: message,
          canRetry: false,
        );
}

// 3. Добавить в .arb файлы
// lib/l10n/app_en.arb
"errorPdfTooLarge": "File is too large. Maximum size is 50MB.",

// lib/l10n/app_ru.arb
"errorPdfTooLarge": "Файл слишком большой. Максимальный размер 50МБ.",

// 4. Добавить в extension (lib/core/exceptions/app_error_extensions.dart)
case AppErrorCode.pdfTooLarge:
  return l10n.errorPdfTooLarge;

// 5. Бросать явно
if (fileSize > maxSize) {
  throw const FileSystemError.tooLarge();
}
```
