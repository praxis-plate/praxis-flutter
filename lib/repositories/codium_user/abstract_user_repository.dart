import 'package:codium/repositories/codium_courses/models/models.dart';

abstract interface class IUserRepository {
  Future<User> getUser();
  Future<List<UserCourseStatistics>> getUserCourseStatistics();
  Future<List<UserCourseStatistics>> getUserAddedCoursesStatistics();
  Future<List<UserCourseStatistics>> getUserPassedCoursesStatistics();
  Future<UserStatistics> getUserStatistics();
  Future<List<ActivityCell>> getUserActivityCells();
  Future<void> addCourseToUser(String courseId);
  Future<void> removeCourseFromUser(String courseId);
  Future<void> buyCourse(String courseId);
}
