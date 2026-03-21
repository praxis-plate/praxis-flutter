import 'package:codium/core/error/failure.dart';
import 'package:codium/core/exceptions/app_error.dart';
import 'package:codium/core/utils/result.dart';
import 'package:codium/data/database/app_database.dart';
import 'package:codium/data/datasources/local/lesson_progress_local_datasource.dart';
import 'package:codium/data/datasources/remote/lesson_remote_datasource.dart';
import 'package:codium/data/entities/lesson_progress_entity_extension.dart';
import 'package:codium/domain/models/lesson_progress/create_lesson_progress_model.dart';
import 'package:codium/domain/models/lesson_progress/lesson_progress_model.dart';
import 'package:codium/domain/repositories/i_lesson_progress_repository.dart';
import 'package:drift/drift.dart';

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
        await _localDataSource.updateLessonProgress(
          LessonProgressCompanion(
            id: Value(existing.id),
            lessonId: Value(lessonId),
            userId: Value(userId),
            isCompleted: const Value(true),
            completedAt: Value(DateTime.now()),
            timeSpentSeconds: Value(timeSpentSeconds),
          ),
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
