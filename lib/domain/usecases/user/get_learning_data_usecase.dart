import 'package:codium/domain/models/models.dart';
import 'package:codium/domain/repositories/abstract_course_repository.dart';
import 'package:codium/domain/repositories/abstract_user_statistics_repository.dart';
import 'package:codium/domain/usecases/activity/generate_activity_usecase.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';

class GetLearningDataUseCase {
  final IUserStatisticsRepository _userStatisticsRepository;
  final ICourseRepository _courseRepository;
  final GenerateActivityUsecase _generateActivityUsecase;

  GetLearningDataUseCase(
    this._userStatisticsRepository,
    this._courseRepository,
    this._generateActivityUsecase,
  );

  Future<LearningData> call(String userId) async {
    try {
      final activityCells = await _generateActivityUsecase();
      final userStatistics = await _userStatisticsRepository.get(userId);

      final Map<Course, UserCourseStatistics> courseMapping = {};
      for (final entry in userStatistics.courses.entries) {
        final courseId = entry.key;
        final userCourseStatistics = entry.value;
        final course = await _courseRepository.getCourseById(courseId);

        if (courseMapping.containsKey(course)) {
          continue;
        }

        courseMapping[course] = userCourseStatistics;
      }

      return LearningData(
        activityCells: activityCells,
        userStatistics: userStatistics,
        userCourseStatisticsByCourse: courseMapping,
      );
    } catch (e, st) {
      GetIt.I<Talker>().handle(e, st);
      rethrow;
    }
  }
}
