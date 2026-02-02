import 'package:codium/core/utils/result.dart';

abstract interface class ILessonProgressRepository {
  Future<Result<void>> markComplete(int lessonId, {int timeSpentSeconds = 0});
}
