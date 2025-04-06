import 'package:codium/domain/models/models.dart';

abstract interface class IUserStatisticsRepository {
  Future<UserStatistics> getStatisticsByUserId(String userId);
  Future<Course> getCourseStatistics(
    String userId,
    String courseId,
  );
}
