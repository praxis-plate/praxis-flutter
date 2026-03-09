import 'package:codium/core/error/failure.dart';
import 'package:codium/core/exceptions/app_error.dart';
import 'package:codium/core/utils/result.dart';
import 'package:codium/data/datasources/remote/lesson_remote_datasource.dart';
import 'package:codium/domain/repositories/i_lesson_progress_repository.dart';

class LessonProgressRepository implements ILessonProgressRepository {
  final LessonRemoteDataSource _remoteDataSource;

  const LessonProgressRepository(this._remoteDataSource);

  @override
  Future<Result<void>> markComplete(
    int lessonId, {
    int timeSpentSeconds = 0,
  }) async {
    try {
      await _remoteDataSource.markComplete(
        lessonId,
        timeSpentSeconds: timeSpentSeconds,
      );
      return const Success(null);
    } on AppError catch (e) {
      return Failure(AppFailure.fromError(e));
    } catch (e) {
      return Failure(AppFailure.fromException(e));
    }
  }
}
