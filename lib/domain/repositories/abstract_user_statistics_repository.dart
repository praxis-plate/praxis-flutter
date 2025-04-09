import 'package:codium/domain/models/models.dart';

abstract interface class IUserStatisticsRepository {
  Future<UserStatistics> get(String userId);
  Future<void> update(UserStatistics stats);
  
  Future<UserCourseStatistics> getUserCourseStatistics({
    required String userId, 
    required String courseId,
  });
  Future<UserCourseStatistics> createUserCourseStatistics({
    required String userId,
    required String courseId,
  });

  Future<bool> exists(String userId);
  Future<void> reset(String userId);
}