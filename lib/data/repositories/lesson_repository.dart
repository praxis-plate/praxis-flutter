import 'package:codium/core/error/failure.dart';
import 'package:codium/core/exceptions/app_error.dart';
import 'package:codium/core/utils/result.dart';
import 'package:codium/data/entities/lesson_entity_extension.dart';
import 'package:codium/domain/datasources/i_lesson_local_datasource.dart';
import 'package:codium/domain/models/lesson/create_lesson_model.dart';
import 'package:codium/domain/models/lesson/lesson_model.dart';
import 'package:codium/domain/models/lesson/update_lesson_model.dart';
import 'package:codium/domain/repositories/i_lesson_repository.dart';

class LessonRepository implements ILessonRepository {
  final ILessonLocalDataSource _localDataSource;

  const LessonRepository(this._localDataSource);

  @override
  Future<Result<List<LessonModel>>> getLessonsByModuleId(int moduleId) async {
    try {
      final entities = await _localDataSource.getLessonsByModuleId(moduleId);
      final models = entities.map((e) => e.toDomain()).toList();
      return Success(models);
    } on AppError catch (e) {
      return Failure(AppFailure.fromError(e));
    } catch (e) {
      return Failure(AppFailure.fromException(e as Exception));
    }
  }

  @override
  Future<Result<List<LessonModel>>> getLessonsByCourseId(int courseId) async {
    try {
      final entities = await _localDataSource.getLessonsByCourseId(courseId);
      final models = entities.map((e) => e.toDomain()).toList();
      return Success(models);
    } on AppError catch (e) {
      return Failure(AppFailure.fromError(e));
    } catch (e) {
      return Failure(AppFailure.fromException(e as Exception));
    }
  }

  @override
  Future<Result<LessonModel?>> getLessonById(int lessonId) async {
    try {
      final entity = await _localDataSource.getLessonById(lessonId);
      return Success(entity?.toDomain());
    } on AppError catch (e) {
      return Failure(AppFailure.fromError(e));
    } catch (e) {
      return Failure(AppFailure.fromException(e as Exception));
    }
  }

  @override
  Future<Result<void>> create(CreateLessonModel model) async {
    try {
      await _localDataSource.insertLesson(model.toCompanion());
      return const Success(null);
    } on AppError catch (e) {
      return Failure(AppFailure.fromError(e));
    } catch (e) {
      return Failure(AppFailure.fromException(e as Exception));
    }
  }

  @override
  Future<Result<void>> update(UpdateLessonModel model) async {
    try {
      await _localDataSource.updateLesson(model.toCompanion());
      return const Success(null);
    } on AppError catch (e) {
      return Failure(AppFailure.fromError(e));
    } catch (e) {
      return Failure(AppFailure.fromException(e as Exception));
    }
  }
}
