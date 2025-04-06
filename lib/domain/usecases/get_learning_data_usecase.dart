import 'package:codium/domain/models/models.dart';
import 'package:codium/domain/repositories/abstract_course_repository.dart';
import 'package:codium/domain/repositories/abstract_user_statistics_repository.dart';
import 'package:codium/domain/usecases/generate_activity_usecase.dart';
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

  Future<LearningData> execute(String userId) async {
    try {
      final activityCells = await _generateActivityUsecase.execute();
      final userStatistics = await _userStatisticsRepository.getStatisticsByUserId(userId);
      final courses = await _courseRepository.getCourses();

      final Map<Course, UserCourseStatistics> courseMapping = {};
      for (final course in courses) {
        final stats = userStatistics.courses[course.id];
        if (stats != null) {
          courseMapping[course] = stats;
        }
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