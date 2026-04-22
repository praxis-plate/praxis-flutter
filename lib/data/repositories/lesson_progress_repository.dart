import 'package:praxis/core/error/failure.dart';
import 'package:praxis/core/exceptions/app_error.dart';
import 'package:praxis/core/utils/result.dart';
import 'package:praxis/data/datasources/local/lesson_progress_local_datasource.dart';
import 'package:praxis/data/datasources/remote/lesson_remote_datasource.dart';
import 'package:praxis/data/entities/lesson_progress_entity_extension.dart';
import 'package:praxis/domain/models/lesson_progress/create_lesson_progress_model.dart';
import 'package:praxis/domain/models/lesson_progress/lesson_progress_model.dart';
import 'package:praxis/domain/models/lesson_progress/update_lesson_progress_model.dart';
import 'package:praxis/domain/repositories/i_lesson_progress_repository.dart';

class LessonProgressRepository implements ILessonProgressRepository {
  final LessonRemoteDataSource _remoteDataSource;
  final LessonProgressLocalDataSource _localDataSource;

  const LessonProgressRepository(
    this._remoteDataSource,
    this._localDataSource,
  );

  @override
  Future<Result<void>> markComplete(
    int lessonId, {
    required String userId,
    int timeSpentSeconds = 0,
  }) async {
    try {
      await _remoteDataSource.markComplete(
        lessonId,
        timeSpentSeconds: timeSpentSeconds,
      );

      final existing = await _localDataSource.getLessonProgress(
        userId,
        lessonId,
      );
      if (existing == null) {
        final model = CreateLessonProgressModel(
          lessonId: lessonId,
          userId: userId,
          isCompleted: true,
          completedAt: DateTime.now(),
          timeSpentSeconds: timeSpentSeconds,
        );
        await _localDataSource.insertLessonProgress(model.toCompanion());
      } else {
        final updateModel = UpdateLessonProgressModel(
          id: existing.id,
          isCompleted: true,
          completedAt: DateTime.now(),
          timeSpentSeconds: timeSpentSeconds,
        );
        await _localDataSource.updateLessonProgress(
          updateModel.toCompanion(),
        );
      }

      return const Success(null);
    } on AppError catch (e) {
      return Failure(AppFailure.fromError(e));
    } catch (e) {
      return Failure(AppFailure.fromException(e));
    }
  }

  @override
  Future<Result<List<LessonProgressModel>>> getCourseLessonProgress(
    String userId,
    int courseId,
  ) async {
    try {
      final result = await _localDataSource.getCourseLessonProgress(
        userId,
        courseId,
      );
      return Success(result.map((e) => e.toDomain()).toList());
    } catch (e) {
      return Failure(AppFailure.fromException(e));
    }
  }
}
