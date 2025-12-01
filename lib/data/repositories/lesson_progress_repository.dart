import 'package:codium/core/error/failure.dart';
import 'package:codium/core/exceptions/app_error.dart';
import 'package:codium/core/utils/result.dart';
import 'package:codium/data/entities/lesson_progress_entity_extension.dart';
import 'package:codium/domain/datasources/i_lesson_progress_local_datasource.dart';
import 'package:codium/domain/models/lesson_progress/create_lesson_progress_model.dart';
import 'package:codium/domain/models/lesson_progress/lesson_progress_model.dart';
import 'package:codium/domain/models/lesson_progress/update_lesson_progress_model.dart';
import 'package:codium/domain/repositories/i_lesson_progress_repository.dart';

class LessonProgressRepository implements ILessonProgressRepository {
  final ILessonProgressLocalDataSource _localDataSource;

  const LessonProgressRepository(this._localDataSource);

  @override
  Future<Result<List<LessonProgressModel>>> getCourseLessonProgress(
    int userId,
    int courseId,
  ) async {
    try {
      final entities = await _localDataSource.getCourseLessonProgress(
        userId,
        courseId,
      );
      final progressList = entities.map((e) => e.toDomain()).toList();
      return Success(progressList);
    } on AppError catch (e) {
      return Failure(AppFailure.fromError(e));
    } catch (e) {
      return Failure(AppFailure.fromException(e as Exception));
    }
  }

  @override
  Future<Result<LessonProgressModel?>> getLessonProgress(
    int userId,
    int lessonId,
  ) async {
    try {
      final entity = await _localDataSource.getLessonProgress(userId, lessonId);
      return Success(entity?.toDomain());
    } on AppError catch (e) {
      return Failure(AppFailure.fromError(e));
    } catch (e) {
      return Failure(AppFailure.fromException(e as Exception));
    }
  }

  @override
  Future<Result<void>> markLessonComplete(int userId, int lessonId) async {
    try {
      final existingEntity = await _localDataSource.getLessonProgress(
        userId,
        lessonId,
      );

      if (existingEntity != null) {
        final updateModel = UpdateLessonProgressModel(
          id: existingEntity.id,
          isCompleted: true,
          completedAt: DateTime.now(),
        );
        await _localDataSource.updateLessonProgress(updateModel.toCompanion());
      } else {
        final createModel = CreateLessonProgressModel(
          lessonId: lessonId,
          userId: userId,
          isCompleted: true,
          completedAt: DateTime.now(),
          timeSpentSeconds: 0,
        );
        await _localDataSource.insertLessonProgress(createModel.toCompanion());
      }
      return const Success(null);
    } on AppError catch (e) {
      return Failure(AppFailure.fromError(e));
    } catch (e) {
      return Failure(AppFailure.fromException(e as Exception));
    }
  }

  @override
  Future<Result<void>> updateLessonProgress(
    UpdateLessonProgressModel progress,
  ) async {
    try {
      await _localDataSource.updateLessonProgress(progress.toCompanion());
      return const Success(null);
    } on AppError catch (e) {
      return Failure(AppFailure.fromError(e));
    } catch (e) {
      return Failure(AppFailure.fromException(e as Exception));
    }
  }
}
