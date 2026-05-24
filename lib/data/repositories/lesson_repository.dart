import 'package:praxis/core/error/failure.dart';
import 'package:praxis/core/exceptions/app_error.dart';
import 'package:praxis/core/utils/result.dart';
import 'package:praxis/data/datasources/local/lesson_local_datasource.dart';
import 'package:praxis/data/datasources/remote/lesson_remote_datasource.dart';
import 'package:praxis/data/entities/lesson_dto_extension.dart';
import 'package:praxis/data/entities/lesson_entity_extension.dart';
import 'package:praxis/domain/models/lesson/lesson_model.dart';
import 'package:praxis/domain/repositories/i_lesson_repository.dart';

class LessonRepository implements ILessonRepository {
  final LessonRemoteDataSource _remoteDataSource;
  final LessonLocalDataSource _localDataSource;

  const LessonRepository(this._remoteDataSource, this._localDataSource);

  @override
  Future<Result<List<LessonModel>>> getLessonsByModuleId(int moduleId) async {
    final cachedLessons = await _localDataSource.getLessonsByModuleId(moduleId);

    try {
      final lessonDtos = await _remoteDataSource.getLessonsByModuleId(moduleId);
      await _localDataSource.upsertLessons(
        lessonDtos.map((lesson) => lesson.toCompanion()).toList(),
      );
      final models = lessonDtos.map((dto) => dto.toDomain()).toList();
      return Success(models);
    } on AppError catch (e) {
      if (cachedLessons.isNotEmpty && _shouldUseCachedData(e)) {
        final models = cachedLessons.map((entity) => entity.toDomain()).toList()
          ..sort((a, b) => a.orderIndex.compareTo(b.orderIndex));
        return Success(models);
      }

      return Failure(AppFailure.fromError(e));
    } catch (e) {
      return Failure(AppFailure.fromException(e));
    }
  }

  @override
  Future<Result<List<LessonModel>>> getLessonsByCourseId(int courseId) async {
    final cachedLessons = await _localDataSource.getLessonsByCourseId(courseId);

    try {
      final lessonDtos = await _remoteDataSource.getLessonsByCourseId(courseId);
      await _localDataSource.upsertLessons(
        lessonDtos.map((lesson) => lesson.toCompanion()).toList(),
      );
      final models = lessonDtos.map((dto) => dto.toDomain()).toList();
      return Success(models);
    } on AppError catch (e) {
      if (cachedLessons.isNotEmpty && _shouldUseCachedData(e)) {
        final models = cachedLessons.map((entity) => entity.toDomain()).toList()
          ..sort((a, b) => a.orderIndex.compareTo(b.orderIndex));
        return Success(models);
      }

      return Failure(AppFailure.fromError(e));
    } catch (e) {
      return Failure(AppFailure.fromException(e));
    }
  }

  @override
  Future<Result<LessonModel?>> getLessonById(int lessonId) async {
    final cachedLesson = await _localDataSource.getLessonById(lessonId);

    try {
      final lessonDto = await _remoteDataSource.getLessonById(lessonId);
      await _localDataSource.upsertLesson(lessonDto.toCompanion());
      final model = lessonDto.toDomain();
      return Success(model);
    } on AppError catch (e) {
      if (cachedLesson != null && _shouldUseCachedData(e)) {
        return Success(cachedLesson.toDomain());
      }

      return Failure(AppFailure.fromError(e));
    } catch (e) {
      return Failure(AppFailure.fromException(e));
    }
  }

  bool _shouldUseCachedData(AppError error) => error.canRetry;
}
