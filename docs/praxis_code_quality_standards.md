# Praxis Code Quality Standards

This document defines code quality, architecture, and development style requirements for the Praxis Flutter project.

## Repository Constraints

- **Do not modify `packages/praxis_client`.**

## Architecture: Clean Architecture (Strict)

The project follows Clean Architecture with three layers. **NEVER violate layer boundaries.**

### Layer Structure

**Domain Layer** (`lib/domain/`)
- Pure business logic and domain models
- Interfaces only: `IRepository`, `IDataSource` (abstract interface classes)
- Zero dependencies on external frameworks or infrastructure
- Pure Dart classes without annotations

**Data Layer** (`lib/data/`)
- Implements domain interfaces
- DataSources: direct database/API access
- Repositories: orchestrate DataSources, convert DTO → Domain
- DTOs with serialization annotations

**Presentation Layer** (`lib/features/`)
- BLoC/Cubit for state management
- UI widgets and screens
- Navigation and routing

### Critical Rules

1. **Database Access**: ONLY in DataSource classes, NEVER in Repositories
2. **BLoC/Cubit Dependencies**: ONLY Use Cases, NEVER Repositories directly
3. **Domain Models**: Must be pure (no JSON annotations, no infrastructure dependencies)
4. **Dependency Direction**: Presentation → Domain ← Data (Data depends on Domain interfaces)

## Code Organization Rules

### Imports: Always Absolute

**MANDATORY**: Use `package:praxis/...` imports, NEVER relative paths.

```dart
// ✅ CORRECT
import 'package:praxis/domain/models/pdf_library/pdf_book.dart';

// ❌ WRONG - will be rejected
import '../../../domain/models/pdf_library/pdf_book.dart';
```

### Barrel Files

When a directory contains multiple related files, create a barrel file (same name as directory) to export them:

```dart
// lib/domain/models/pdf_library/pdf_library.dart
export 'pdf_book.dart';
export 'bookmark.dart';
export 'reading_progress.dart';
```

Then import: `import 'package:praxis/domain/models/pdf_library/pdf_library.dart';`

### Widget Organization

**Feature-specific widgets**: `lib/features/<feature>/widgets/` (на одном уровне с `view/`)
**Shared widgets**: `lib/core/widgets/`

Structure:
```
lib/features/pdf_reader/
├── bloc/
├── view/
│   └── pdf_reader_screen.dart
└── widgets/
    ├── bookmarks_panel.dart
    ├── page_navigation.dart
    └── widgets.dart  # Barrel file
```

Decision rule:
- Used by ONE feature only → `lib/features/<feature>/widgets/`
- Used by MULTIPLE features → `lib/core/widgets/`

Example:
```dart
// ❌ WRONG: feature-specific widget in core
// lib/core/widgets/pdf_book_card.dart

// ❌ WRONG: widgets inside view folder
// lib/features/library/view/widgets/pdf_book_card.dart

// ✅ CORRECT: widgets on same level as view
// lib/features/library/widgets/pdf_book_card.dart
```

### Widget Functions: Forbidden

**CRITICAL**: Functions MUST NOT return widgets. Extract to separate Widget classes instead.

Reason: Widget-returning functions break Flutter DevTools widget tree, navigation analytics, and hot reload.

**Exceptions** (ONLY these cases):
1. Builder callbacks that accept builder parameter (e.g., `builder: (context) => ...`)
2. Single-use inline functions passed directly to builder parameters (NOT reused elsewhere)

```dart
// ❌ WRONG: Reusable function returning widget
class PdfReaderScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(),
        _buildContent(),
        _buildFooter(),
      ],
    );
  }
  
  Widget _buildHeader() {
    return Container(
      child: Text('Header'),
    );
  }
  
  Widget _buildContent() {
    return Expanded(
      child: Text('Content'),
    );
  }
}

// ✅ CORRECT: Separate widget classes
class PdfReaderScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _PdfReaderHeader(),
        _PdfReaderContent(),
        _PdfReaderFooter(),
      ],
    );
  }
}

class _PdfReaderHeader extends StatelessWidget {
  const _PdfReaderHeader();
  
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('Header'),
    );
  }
}

class _PdfReaderContent extends StatelessWidget {
  const _PdfReaderContent();
  
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Text('Content'),
    );
  }
}

// ✅ CORRECT: Builder callback (exception)
GoRoute(
  path: '/pdf-reader',
  builder: (context, state) => PdfReaderScreen(),
)

// ✅ CORRECT: Single-use inline function in builder parameter (exception)
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) {
    return ListTile(
      title: Text(items[index].title),
    );
  },
)

// ✅ CORRECT: Single-use function passed to builder parameter (exception)
Widget _buildListItem(BuildContext context, int index) {
  return ListTile(
    title: Text(items[index].title),
  );
}

ListView.builder(
  itemCount: items.length,
  itemBuilder: _buildListItem, // Used ONLY in builder parameter
)
```

Benefits: Proper widget tree in DevTools, better hot reload, accurate navigation tracking, const optimization.

### Database Access: DataSource Only

**CRITICAL**: Database access is ONLY allowed in DataSource classes.

Rules:
1. DataSource: Direct DB access via Drift Managers API (`db.managers.pdfBooks`)
2. Repository: Calls DataSource, converts Entity → Domain
3. Repository NEVER has `AppDatabase` dependency
4. **DataSource methods accept Companion for insert/update (Drift pattern)**
5. **Repository uses Create/Update models, NOT read models for writing**

**Model Organization:**
- Organize models by repository in separate folders
- Read models: `LessonProgressModel` (from Entity, has `copyWith`)
- Create models: `CreateLessonProgressModel` (for insert, NO id field)
- Update models: `UpdateLessonProgressModel` (for update, nullable fields, has `toCompanion` with `Value.absent()`)

```dart
// ✅ CORRECT: Separate models for read/create/update
// lib/domain/models/lesson_progress/lesson_progress_model.dart
class LessonProgressModel extends Equatable {
  final int id;
  final int lessonId;
  final String userId;
  final bool isCompleted;
  final DateTime? completedAt;
  final int timeSpentSeconds;
  
  LessonProgressModel copyWith({...}) { ... }
}

// lib/domain/models/lesson_progress/create_lesson_progress_model.dart
class CreateLessonProgressModel extends Equatable {
  final int lessonId;        // NO id field
  final String userId;
  final bool isCompleted;
  final DateTime? completedAt;
  final int timeSpentSeconds;
}

// lib/domain/models/lesson_progress/update_lesson_progress_model.dart
class UpdateLessonProgressModel extends Equatable {
  final int id;              // Required for update
  final bool? isCompleted;   // Nullable - only update if provided
  final DateTime? completedAt;
  final int? timeSpentSeconds;
}

// ✅ CORRECT: Extensions with Companion
extension CreateLessonProgressModelExtension on CreateLessonProgressModel {
  LessonProgressCompanion toCompanion() {
    return LessonProgressCompanion.insert(
      lessonId: lessonId,
      userId: userId,
      isCompleted: Value(isCompleted),
      completedAt: Value(completedAt),
      timeSpentSeconds: Value(timeSpentSeconds),
    );
  }
}

extension UpdateLessonProgressModelExtension on UpdateLessonProgressModel {
  LessonProgressCompanion toCompanion() {
    return LessonProgressCompanion(
      id: Value(id),
      isCompleted: isCompleted != null ? Value(isCompleted!) : const Value.absent(),
      completedAt: completedAt != null ? Value(completedAt) : const Value.absent(),
      timeSpentSeconds: timeSpentSeconds != null ? Value(timeSpentSeconds!) : const Value.absent(),
    );
  }
}

// ✅ CORRECT: DataSource accepts Companion
abstract interface class ILessonProgressLocalDataSource {
  Future<LessonProgressEntity> insertLessonProgress(LessonProgressCompanion entry);
  Future<void> updateLessonProgress(LessonProgressCompanion entry);
}

// ✅ CORRECT: Repository uses Create/Update models
class LessonProgressRepository {
  Future<Result<void>> markLessonComplete(String userId, int lessonId) async {
    try {
      final createModel = CreateLessonProgressModel(
        lessonId: lessonId,
        userId: userId,
        isCompleted: true,
        completedAt: DateTime.now(),
        timeSpentSeconds: 0,
      );
      await _localDataSource.insertLessonProgress(createModel.toCompanion());
      return const Success(null);
    } on AppError catch (e) {
      return Failure(AppFailure.fromError(e));
    }
  }
  
  Future<Result<void>> updateLessonProgress(UpdateLessonProgressModel progress) async {
    try {
      await _localDataSource.updateLessonProgress(progress.toCompanion());
      return const Success(null);
    } on AppError catch (e) {
      return Failure(AppFailure.fromError(e));
    }
  }
}

// ❌ WRONG: Using read model for writing
class LessonProgressRepository {
  Future<Result<void>> markLessonComplete(String userId, int lessonId) async {
    final model = LessonProgressModel(id: 0, ...); // NEVER use read model for writing
    await _localDataSource.insertLessonProgress(model.toEntity());
  }
}

// ❌ WRONG: Repository with DB dependency
class PdfRepository implements IPdfRepository {
  final AppDatabase _db; // NEVER do this
}
```

**Benefits:**
- Drift Companion pattern for partial updates (`Value.absent()`)
- No id field in Create models (auto-increment)
- Update models with nullable fields for partial updates
- Clear separation: read vs write operations
- Repository doesn't create read models for writing

### JSON Serialization

All models that interact with external data (API, storage) MUST have `fromJson` and `toJson`:

```dart
class SearchSource extends Equatable {
  final String title;
  final String snippet;
  final String url;
  
  const SearchSource({
    required this.title,
    required this.snippet,
    required this.url,
  });
  
  factory SearchSource.fromJson(Map<String, dynamic> json) {
    return SearchSource(
      title: json['title'] as String,
      snippet: json['snippet'] as String,
      url: json['url'] as String,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'snippet': snippet,
      'url': url,
    };
  }
  
  @override
  List<Object?> get props => [title, snippet, url];
  
  @override
  bool get stringify => true;
}
```

### DTO vs Domain Models

**DTOs** (Data layer only):
- Used for API/DB data exchange
- Contains serialization annotations
- May include technical/API-specific fields
- NEVER used outside Data layer

**Domain Models** (Domain + Presentation):
- Pure business entities
- No infrastructure dependencies or annotations
- Extends `Equatable` with `stringify: true`
- MUST have `copyWith` method for immutability
- MUST have `Model` suffix (e.g., `UserProfileModel`, `AchievementModel`)

```dart
// ✅ Domain model template
class PdfBookModel extends Equatable {
  final String id;
  final String title;
  final String? author;
  final String filePath;
  final int totalPages;
  final int currentPage;
  
  const PdfBookModel({
    required this.id,
    required this.title,
    this.author,
    required this.filePath,
    required this.totalPages,
    this.currentPage = 0,
  });
  
  PdfBookModel copyWith({
    String? id,
    String? title,
    String? author,
    String? filePath,
    int? totalPages,
    int? currentPage,
  }) {
    return PdfBookModel(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      filePath: filePath ?? this.filePath,
      totalPages: totalPages ?? this.totalPages,
      currentPage: currentPage ?? this.currentPage,
    );
  }
  
  @override
  List<Object?> get props => [id, title, author, filePath, totalPages, currentPage];
  
  @override
  bool get stringify => true;
}
```

### Model Aggregation: One Model Per Table

**CRITICAL**: Domain models MUST map 1:1 to database tables. NEVER create aggregate models in Repository.

**Problem**: Aggregate models violate Single Responsibility Principle and create tight coupling.

```dart
// ❌ WRONG: Aggregate model combining multiple tables
class UserModel {
  final String id;
  final String email;
  final Money balance;              // from UserStatistic table
  final List<String> purchasedCourseIds;  // from UserCourse table
}

// ❌ WRONG: Repository aggregates data
class UserRepository {
  Future<Result<UserModel>> getUserById(String userId) async {
    final user = await _userDataSource.getUserById(userId);
    final statistic = await _statisticDataSource.getUserStatistic(userId);
    final courses = await _courseDataSource.getUserCourses(userId);
    
    return Success(UserModel(
      id: user.id,
      email: user.email,
      balance: Money(amount: statistic.points),
      purchasedCourseIds: courses.map((c) => c.courseId).toList(),
    ));
  }
}
```

**Solution**: Create separate models for each table, aggregate in UseCase.

```dart
// ✅ CORRECT: One model per table
class UserProfileModel extends Equatable {
  final String id;
  final String email;
  final String name;
  final DateTime createdAt;
}

class UserStatisticModel extends Equatable {
  final String userId;
  final int currentStreak;
  final int maxStreak;
  final Money balance;
}

class UserCourseModel extends Equatable {
  final String id;
  final String userId;
  final String courseId;
  final DateTime enrolledAt;
}

// ✅ CORRECT: Aggregate model for presentation (optional)
class FullUserProfileModel extends Equatable {
  final UserProfileModel profile;
  final Money balance;
  final List<String> purchasedCourseIds;
  final int currentStreak;
}

// ✅ CORRECT: Each Repository handles one table
class UserRepository {
  Future<Result<UserProfileModel>> getUserProfile(String userId);
}

class UserStatisticRepository {
  Future<Result<UserStatisticModel>> getUserStatistic(String userId);
}

class UserCourseRepository {
  Future<Result<List<UserCourseModel>>> getUserCourses(String userId);
}

// ✅ CORRECT: UseCase aggregates data
class GetFullUserProfileUseCase {
  final IUserRepository _userRepo;
  final IUserStatisticRepository _statisticRepo;
  final IUserCourseRepository _courseRepo;

  Future<Result<FullUserProfileModel>> call(String userId) async {
    final profileResult = await _userRepo.getUserProfile(userId);
    if (profileResult.isFailure) return Failure(profileResult.failureOrNull!);

    final statisticResult = await _statisticRepo.getUserStatistic(userId);
    if (statisticResult.isFailure) return Failure(statisticResult.failureOrNull!);

    final coursesResult = await _courseRepo.getUserCourses(userId);
    if (coursesResult.isFailure) return Failure(coursesResult.failureOrNull!);

    return Success(FullUserProfileModel(
      profile: profileResult.dataOrNull!,
      balance: statisticResult.dataOrNull!.balance,
      purchasedCourseIds: coursesResult.dataOrNull!.map((c) => c.courseId).toList(),
      currentStreak: statisticResult.dataOrNull!.currentStreak,
    ));
  }
}
```

**Benefits:**
- Each Repository has single responsibility
- Easy to test individual repositories
- Can reuse parts (only balance, only courses)
- UseCase contains business logic of aggregation
- Follows Clean Architecture principles
- No tight coupling between tables

### Dependency Injection: Interface-First

**CRITICAL**: ALL DataSources, Services, and Repositories MUST have interfaces. Register ONLY interfaces in GetIt.

**Repositories** (Domain layer):
- Interface in `lib/domain/repositories/`
- Implementation in `lib/data/repositories/`

```dart
// lib/domain/repositories/i_auth_repository.dart
abstract interface class IAuthRepository {
  Future<User> signIn(String email, String password);
  Future<User> getUserProfile();
}

// lib/data/repositories/auth_repository_impl.dart
class AuthRepository implements IAuthRepository {
  final IAuthDataSource _authDataSource;

  const AuthRepository(this._authDataSource);

  @override
  Future<User> signIn(String email, String password) async {
    final userDto = await _authDataSource.signIn(email, password);
    return userDto.toDomain();
  }
}
```

**DataSources** (Domain layer interfaces, Data layer implementations):
- Interface in `lib/domain/datasources/`
- Implementation in `lib/data/datasources/local/` or `lib/data/datasources/remote/`

```dart
// lib/domain/datasources/i_auth_datasource.dart
abstract interface class IAuthDataSource {
  Future<UserDto> signIn(String email, String password);
  Future<UserDto> getUserProfile();
}

// lib/data/datasources/local/local_auth_datasource.dart
class LocalAuthDataSource implements IAuthDataSource {
  final AppDatabase _db;
  
  const LocalAuthDataSource(this._db);
  
  @override
  Future<UserDto> signIn(String email, String password) async {
    // Implementation
  }
}
```

**Services** (Domain layer):
- Interface in `lib/domain/services/`
- Implementation in `lib/core/services/`

```dart
// lib/domain/services/i_connectivity_service.dart
abstract interface class IConnectivityService {
  Future<bool> isConnected();
  Stream<bool> get connectivityStream;
}

// lib/core/services/connectivity_service.dart
class ConnectivityService implements IConnectivityService {
  final Connectivity _connectivity;
  
  const ConnectivityService(this._connectivity);
  
  @override
  Future<bool> isConnected() async {
    // Implementation
  }
}
```

**GetIt Registration** (ONLY interfaces):

```dart
// lib/dependency_injection.dart

// ❌ WRONG: Registering concrete classes
getIt.registerLazySingleton(() => LocalAuthDataSource(getIt()));
getIt.registerLazySingleton(() => AuthRepository(getIt()));

// ✅ CORRECT: Register interfaces
getIt.registerLazySingleton<IAuthDataSource>(
  () => LocalAuthDataSource(getIt()),
);
getIt.registerLazySingleton<IAuthRepository>(
  () => AuthRepository(getIt()),
);
getIt.registerLazySingleton<IConnectivityService>(
  () => ConnectivityService(getIt()),
);
```

Benefits: Testability (easy mocking), flexibility (swap implementations), follows SOLID principles.

## Code Style

### Naming Conventions

- Classes: `PascalCase` (`PdfBook`, `AiRepository`)
- Methods/variables: `camelCase` (`getAllBooks`, `currentPage`)
- Constants: `lowerCamelCase` (`maxRetries`, `defaultTimeout`)
- Private fields: prefix with `_` (`_db`, `_authDataSource`)
- **Interfaces**: prefix with `I` (`IAuthRepository`, `IPdfDataSource`, `IConnectivityService`)
- **Implementations**: NO prefix, NO `Impl` suffix (`AuthRepository`, `LocalAuthDataSource`, `ConnectivityService`)
- **BLoC Events**: MUST end with `Event` suffix (`LoadTaskEvent`, `SubmitAnswerEvent`, `RequestHintEvent`)
- **BLoC States**: MUST end with `State` suffix (`TaskLoadingState`, `TaskLoadedState`, `TaskErrorState`)
- **Use Cases**: Organize in feature-specific subfolders (`lib/domain/usecases/tasks/`, `lib/domain/usecases/auth/`)

```dart
// ✅ CORRECT: Interface with I prefix
abstract interface class IAuthRepository { }
abstract interface class IPdfDataSource { }
abstract interface class IConnectivityService { }

// ✅ CORRECT: Implementation without I, without Impl
class AuthRepository implements IAuthRepository { }
class LocalAuthDataSource implements IPdfDataSource { }
class ConnectivityService implements IConnectivityService { }

// ❌ WRONG: Implementation with Impl suffix
class AuthRepositoryImpl implements IAuthRepository { }
class PdfDataSourceImpl implements IPdfDataSource { }

// ❌ WRONG: Interface without I prefix
abstract interface class AuthRepository { }
abstract interface class PdfDataSource { }

// ✅ CORRECT: BLoC Events with Event suffix
class LoadTaskEvent extends TaskEvent { }
class SubmitAnswerEvent extends TaskEvent { }

// ❌ WRONG: BLoC Events without Event suffix
class LoadTask extends TaskEvent { }
class SubmitAnswer extends TaskEvent { }

// ✅ CORRECT: BLoC States with State suffix
class TaskLoadingState extends TaskState { }
class TaskLoadedState extends TaskState { }

// ❌ WRONG: BLoC States without State suffix
class TaskLoading extends TaskState { }
class TaskLoaded extends TaskState { }
```

### Equatable Props: Avoid Redundant Overrides

**CRITICAL**: When extending Equatable, define `props` in the parent class if all subclasses have empty props. Do NOT override empty props in every subclass.

```dart
// ❌ WRONG: Redundant empty props in every subclass
abstract class TaskEvent extends Equatable {
  const TaskEvent();
}

class LoadTask extends TaskEvent {
  final int taskId;
  const LoadTask(this.taskId);
  @override
  List<Object> get props => [taskId];
}

class RequestHint extends TaskEvent {
  const RequestHint();
  @override
  List<Object> get props => [];  // Redundant!
}

class RetryTask extends TaskEvent {
  const RetryTask();
  @override
  List<Object> get props => [];  // Redundant!
}

// ✅ CORRECT: Define empty props once in parent
abstract class TaskEvent extends Equatable {
  const TaskEvent();
  
  @override
  List<Object> get props => [];  // Default empty props
}

class LoadTask extends TaskEvent {
  final int taskId;
  const LoadTask(this.taskId);
  @override
  List<Object> get props => [taskId];  // Override only when needed
}

class RequestHint extends TaskEvent {
  const RequestHint();
  // No override needed - uses parent's empty props
}

class RetryTask extends TaskEvent {
  const RetryTask();
  // No override needed - uses parent's empty props
}
```

### Comments: Forbidden

**CRITICAL**: Code MUST be self-documenting. Comments are FORBIDDEN.

Rules:
1. Use descriptive names for classes, methods, and variables
2. Extract complex logic into well-named methods
3. Use domain-specific terminology in naming
4. NEVER write explanatory comments

```dart
// ❌ WRONG: Any comment
// Get all books
Future<List<PdfBook>> getAllBooks() async { ... }

// ❌ WRONG: Explaining logic with comment
// Retry with exponential backoff to handle Gemini API rate limits (60 req/min)
Future<String> _retryRequest() async { ... }

// ✅ CORRECT: Self-documenting method name
Future<String> _retryRequestWithExponentialBackoffForRateLimit() async { ... }

// ✅ CORRECT: Extract to named method
Future<List<PdfBook>> getFavoriteBooks() async {
  final allBooks = await getAllBooks();
  return _filterOnlyFavorites(allBooks);
}

List<PdfBook> _filterOnlyFavorites(List<PdfBook> books) {
  return books.where((book) => book.isFavorite).toList();
}
```

Benefits: Forces clear naming, eliminates outdated comments, improves code readability, prevents comment rot.

### Type Safety: No Dynamic

**CRITICAL**: NEVER use `dynamic` type except for JSON deserialization.

Rules:
1. Always specify explicit types for variables, parameters, and return values
2. Use generics (`List<T>`, `Map<K, V>`) instead of `dynamic`
3. ONLY exception: `fromJson(Map<String, dynamic> json)` and `fromMap(Map<String, dynamic> map)`

```dart
// ❌ WRONG: Using dynamic
dynamic getUserData() async { ... }

List<dynamic> items = [];

void processData(dynamic data) { ... }

AchievementModel _entityToDomain(dynamic entity) {
  return AchievementModel(
    id: entity.id as int,  // Runtime cast - dangerous!
    title: entity.title as String,
  );
}

// ✅ CORRECT: Explicit types
Future<UserModel> getUserData() async { ... }

List<AchievementModel> items = [];

void processData(AchievementModel data) { ... }

// ✅ CORRECT: Extension for type-safe conversion
extension AchievementEntityExtension on AchievementEntity {
  AchievementModel toDomain() {
    return AchievementModel(
      id: id,  // Compile-time type safety
      title: title,
    );
  }
}

// ✅ CORRECT: Only exception - JSON deserialization
factory UserModel.fromJson(Map<String, dynamic> json) {
  return UserModel(
    id: json['id'] as int,
    name: json['name'] as String,
  );
}
```

Benefits: Compile-time type checking, better IDE autocomplete, prevents runtime errors, clearer code intent.

### Logging: Talker Only

**NEVER use `print()`. Use Talker from GetIt:**

```dart
// ❌ WRONG
print('Error: ${e.toString()}');

// ✅ CORRECT
final talker = GetIt.I<Talker>();
talker.debug('Starting operation...');
talker.info('Operation completed');
talker.warning('Deprecated method used');
talker.error('Operation failed', e, stackTrace);
```

### Commented Code: Forbidden

**NEVER leave commented-out code.** Use feature flags instead:

```dart
// ❌ WRONG: Commented code
// final filteredBooks = books.where((b) => b.isFavorite).toList();
// return filteredBooks;

// ✅ CORRECT: Feature flag
// lib/core/config/feature_flags.dart
class FeatureFlags {
  static const bool enableFavoriteFilter = false;
  static const bool enableWebSearch = true;
}

// Usage
if (FeatureFlags.enableFavoriteFilter) {
  return books.where((b) => b.isFavorite).toList();
}
```

### Error Handling

**CRITICAL**: Use `Result<T>` pattern for explicit error handling. NEVER throw exceptions from Repository/UseCase methods.

#### Result Pattern (Mandatory)

All Repository and UseCase methods MUST return `Result<T>` instead of throwing exceptions.

```dart
// lib/core/utils/result.dart
sealed class Result<T> {
  const Result();
}

final class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);
}

final class Failure<T> extends Result<T> {
  final AppFailure failure;
  const Failure(this.failure);
}
```

**Repository implementation:**

```dart
// ❌ WRONG: Throwing exceptions
class UserRepository implements IUserRepository {
  @override
  Future<User> getUserById(String userId) async {
    try {
      final entity = await _dataSource.getUserById(userId);
      return entity.toDomain();
    } catch (e) {
      throw NetworkError.general(message: 'Failed to fetch user');
    }
  }
}

// ✅ CORRECT: Returning Result
class UserRepository implements IUserRepository {
  @override
  Future<Result<User>> getUserById(String userId) async {
    try {
      final entity = await _dataSource.getUserById(userId);
      return Success(entity.toDomain());
    } on NetworkError catch (e) {
      return Failure(AppFailure.fromError(e));
    } on DatabaseError catch (e) {
      return Failure(AppFailure.fromError(e));
    } catch (e) {
      return Failure(AppFailure.fromException(e as Exception));
    }
  }
}
```

**UseCase implementation:**

```dart
// ✅ CORRECT: UseCase returns Result
class GetUserNameUseCase {
  final IUserRepository _repository;

  const GetUserNameUseCase(this._repository);

  Future<Result<String>> call(String userId) async {
    final result = await _repository.getUserById(userId);

    return result.when(
      success: (user) => Success(user.name),
      failure: (failure) => Failure(failure),
    );
  }
}
```

**BLoC handling:**

```dart
// ✅ CORRECT: Pattern matching with when()
class UserBloc extends Bloc<UserEvent, UserState> {
  final GetUserNameUseCase _getUserNameUseCase;

  UserBloc(this._getUserNameUseCase) : super(UserInitial()) {
    on<LoadUser>(_onLoadUser);
  }

  Future<void> _onLoadUser(LoadUser event, Emitter<UserState> emit) async {
    emit(UserLoading());

    final result = await _getUserNameUseCase(event.userId);

    result.when(
      success: (name) => emit(UserLoaded(name: name)),
      failure: (failure) => emit(
        UserError(
          message: failure.message,
          canRetry: failure.canRetry,
        ),
      ),
    );
  }
}
```

**Benefits:**
- Compile-time guarantee of error handling
- No unexpected exceptions
- Clear success/failure flow
- Better testability
- Type-safe error information

#### Typed Exceptions (Internal Use Only)

Use typed exceptions ONLY inside DataSource/Repository for catching specific errors. NEVER expose them outside Data layer.

```dart
// ✅ CORRECT: Catch typed exceptions, return Result
class UserRepository implements IUserRepository {
  @override
  Future<Result<User>> getUserById(String userId) async {
    try {
      final entity = await _dataSource.getUserById(userId);
      return Success(entity.toDomain());
    } on NetworkError catch (e) {
      return Failure(AppFailure.fromError(e));
    } on DatabaseError catch (e) {
      return Failure(AppFailure.fromError(e));
    }
  }
}

// ❌ WRONG: String matching
try {
  await _repository.getUserById(userId);
} catch (e) {
  if (e.toString().contains('network error')) {
    // Handle error
  }
}
```

### Early Returns: Reduce Nesting

**CRITICAL**: Use early returns to reduce nesting and improve code readability. Check for failure conditions first and return early.

Rules:
1. Check for failure/error conditions first
2. Return early on failure
3. Keep the happy path at the lowest indentation level
4. Avoid deep nesting with multiple if-else blocks

```dart
// ❌ WRONG: Deep nesting with multiple if-else
Future<void> _onCheckAuthStatus(
  CheckAuthStatus event,
  Emitter<AuthState> emit,
) async {
  emit(const AuthLoadingState());

  final result = await _checkAuthStatusUseCase();

  if (result.isSuccess) {
    final user = result.dataOrNull;
    if (user != null) {
      final fullProfileResult = await _getFullUserProfileUseCase(user);
      if (fullProfileResult.isSuccess) {
        final fullProfile = fullProfileResult.dataOrNull!;
        emit(
          AuthAuthenticatedState(
            user: fullProfile.profile,
            balance: fullProfile.balance,
            purchasedCourseIds: fullProfile.purchasedCourseIds,
            currentStreak: fullProfile.currentStreak,
            maxStreak: fullProfile.maxStreak,
          ),
        );
      } else {
        emit(const AuthUnauthenticatedState());
      }
    } else {
      emit(const AuthUnauthenticatedState());
    }
  } else {
    emit(const AuthUnauthenticatedState());
  }
}

// ✅ CORRECT: Early returns with flat structure
Future<void> _onCheckAuthStatus(
  CheckAuthStatus event,
  Emitter<AuthState> emit,
) async {
  emit(const AuthLoadingState());

  final result = await _checkAuthStatusUseCase();

  if (!result.isSuccess) {
    emit(const AuthUnauthenticatedState());
    return;
  }

  final user = result.dataOrNull;
  if (user == null) {
    emit(const AuthUnauthenticatedState());
    return;
  }

  final fullProfileResult = await _getFullUserProfileUseCase(user);
  if (!fullProfileResult.isSuccess) {
    emit(const AuthUnauthenticatedState());
    return;
  }

  final fullProfile = fullProfileResult.dataOrNull!;
  emit(
    AuthAuthenticatedState(
      user: fullProfile.profile,
      balance: fullProfile.balance,
      purchasedCourseIds: fullProfile.purchasedCourseIds,
      currentStreak: fullProfile.currentStreak,
      maxStreak: fullProfile.maxStreak,
    ),
  );
}
```

**Benefits:**
- Easier to read and understand
- Reduced cognitive load
- Clear separation of error handling and happy path
- Less indentation makes code more maintainable
- Easier to add new validation checks

## Use Cases Pattern

**BLoC MUST use Use Cases, NEVER Repositories directly.**

```dart
// ❌ WRONG: BLoC depends on Repository
class AiExplanationBloc extends Bloc<AiExplanationEvent, AiExplanationState> {
  final IAiRepository _aiRepository;
  
  AiExplanationBloc(this._aiRepository) : super(AiExplanationInitial());
}

// ✅ CORRECT: BLoC depends on Use Case
class AiExplanationBloc extends Bloc<AiExplanationEvent, AiExplanationState> {
  final ExplainTextUseCase _explainTextUseCase;
  
  AiExplanationBloc(this._explainTextUseCase) : super(AiExplanationInitial());
}
```

Use Case structure:

```dart
// lib/domain/usecases/explain_text_usecase.dart
class ExplainTextUseCase {
  final IAiRepository _aiRepository;
  final IStorageRepository _storageRepository;
  
  const ExplainTextUseCase(this._aiRepository, this._storageRepository);
  
  Future<Explanation> call({
    required String text,
    required String context,
    required String pdfBookId,
    required int pageNumber,
  }) async {
    final explanationText = await _aiRepository.explainText(
      text: text,
      context: context,
    );
    
    final explanation = Explanation(
      id: const Uuid().v4(),
      pdfBookId: pdfBookId,
      pageNumber: pageNumber,
      selectedText: text,
      explanation: explanationText,
      createdAt: DateTime.now(),
    );
    
    await _storageRepository.saveExplanation(explanation);
    return explanation;
  }
}
```

Benefits: Encapsulates business logic, enables reuse, simplifies testing, allows combining multiple repositories.

## Testing Requirements

- Unit tests: All repositories and use cases
- Widget tests: Critical UI components
- Integration tests: Main user flows
- Property-based tests: Use format `// Feature: name, Property N: description`
- Minimum coverage: 80%

## Security

**API Keys**: Use `envied` package with obfuscation:

```dart
// .env (add to .gitignore)
GEMINI_API_KEY=your_key_here

// lib/core/config/env_config.dart
@Envied(path: '.env')
abstract class EnvConfig {
  @EnviedField(varName: 'GEMINI_API_KEY', obfuscate: true)
  static final String geminiApiKey = _EnvConfig.geminiApiKey;
}
```

## Performance

- Use `const` constructors wherever possible
- Lazy loading for large lists
- Cache frequently accessed data
- Always dispose BLoC and controllers
- Monitor memory leaks in DevTools

## Localization (i18n)

**CRITICAL**: ALL user-facing strings MUST be localized. NEVER hardcode strings in UI code.

Localization files:
- `lib/l10n/app_en.arb` - English strings
- `lib/l10n/app_ru.arb` - Russian strings

### Extract S.of(context) and Theme in build()

**MANDATORY**: Extract `S.of(context)` and `Theme.of(context)` to local variables at the start of `build()` method.

```dart
// ❌ WRONG: Repeated S.of(context) calls
@override
Widget build(BuildContext context) {
  return Column(
    children: [
      Text(S.of(context).title),
      Text(S.of(context).subtitle),
      ElevatedButton(
        onPressed: () {},
        child: Text(S.of(context).buttonLabel),
      ),
    ],
  );
}

// ✅ CORRECT: Extract to variable
@override
Widget build(BuildContext context) {
  final s = S.of(context);
  final theme = Theme.of(context);
  
  return Column(
    children: [
      Text(s.title, style: theme.textTheme.headlineMedium),
      Text(s.subtitle, style: theme.textTheme.bodyMedium),
      ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.colorScheme.primary,
        ),
        child: Text(s.buttonLabel),
      ),
    ],
  );
}
```

Benefits: Cleaner code, better performance (single InheritedWidget lookup), easier to read.

### Adding New Strings

1. Add key-value to both `app_en.arb` and `app_ru.arb`
2. Run `fvm flutter gen-l10n` to regenerate
3. Use via `S.of(context).yourKey`

Exception: Debug/development logs can use English strings.

## Code Analysis

**CRITICAL**: After implementing any feature, ALWAYS run `fvm flutter analyze` and fix ALL errors and warnings.

Rules:
1. Run `fvm flutter analyze` after completing feature implementation
2. Fix ALL analysis errors (blocking issues)
3. Fix ALL analysis warnings (potential issues)
4. NEVER commit code with analysis errors or warnings
5. If analysis shows issues, fix them before proceeding

```bash
# Run analysis
fvm flutter analyze

# Expected output for clean code:
# Analyzing praxis...
# No issues found!
```

Common analysis issues to watch for:
- Unused imports
- Missing return types
- Unused variables
- Type mismatches
- Deprecated API usage
- Missing required parameters
- Dead code

Benefits: Catches bugs early, enforces type safety, maintains code quality, prevents runtime errors.

## Pre-Commit Checklist

- Clean Architecture layers respected
- Absolute imports used (`package:praxis/...`)
- DB access only in DataSource
- All DataSources, Services, Repositories have interfaces
- GetIt registers interfaces, not concrete classes
- Models have `fromJson`/`toJson`
- All user-facing strings localized in `.arb` files
- `S.of(context)` and `Theme.of(context)` extracted to variables in `build()`
- No widget-returning functions (use Widget classes instead)
- Tests pass
- **`fvm flutter analyze` passes with no errors or warnings**
- App builds and runs with `fvm flutter`
- No API keys in code
- No commented-out code
- No `print()` statements (use Talker)
