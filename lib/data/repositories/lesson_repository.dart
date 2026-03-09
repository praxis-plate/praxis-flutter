import 'package:codium/core/error/failure.dart';
import 'package:codium/core/exceptions/app_error.dart';
import 'package:codium/core/utils/result.dart';
import 'package:codium/data/datasources/remote/lesson_remote_datasource.dart';
import 'package:codium/data/entities/lesson_dto_extension.dart';
import 'package:codium/domain/models/lesson/lesson_model.dart';
import 'package:codium/domain/repositories/i_lesson_repository.dart';

class LessonRepository implements ILessonRepository {
  final LessonRemoteDataSource _remoteDataSource;

  const LessonRepository(this._remoteDataSource);

  @override
  Future<Result<List<LessonModel>>> getLessonsByModuleId(int moduleId) async {
    try {
      final lessonDtos = await _remoteDataSource.getLessonsByModuleId(moduleId);
      final models = lessonDtos.map((dto) => dto.toDomain()).toList();
      return Success(models);
    } on AppError catch (e) {
      return Failure(AppFailure.fromError(e));
    } catch (e) {
      return Failure(AppFailure.fromException(e));
    }
  }

  @override
  Future<Result<List<LessonModel>>> getLessonsByCourseId(int courseId) async {
    try {
      final lessonDtos = await _remoteDataSource.getLessonsByCourseId(courseId);
      final models = lessonDtos.map((dto) => dto.toDomain()).toList();
      return Success(models);
    } on AppError catch (e) {
      return Failure(AppFailure.fromError(e));
    } catch (e) {
      return Failure(AppFailure.fromException(e));
    }
  }

  @override
  Future<Result<LessonModel?>> getLessonById(int lessonId) async {
    try {
      final lessonDto = await _remoteDataSource.getLessonById(lessonId);
      final model = lessonDto.toDomain();
      return Success(model);
    } on AppError catch (e) {
      return Failure(AppFailure.fromError(e));
    } catch (e) {
      return Failure(AppFailure.fromException(e));
    }
  }
}
