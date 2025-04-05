import 'package:codium/repositories/codium_courses/abstract_course_repository.dart';
import 'package:codium/repositories/codium_courses/models/models.dart';
import 'package:codium/repositories/codium_user/abstract_user_repository.dart';

class UserRepository implements IUserRepository {
  final ICourseRepository courseRepository;

  UserRepository({
    required this.courseRepository,
  });

  @override
  Future<User> getUser() async {
    return const User(
      id: '1',
      email: 'test@test.com',
      name: 'Test',
      imagePath: 'https://picsum.photos/200',
    );
  }

  @override
  Future<List<UserCourseStatistics>> getUserCourseStatistics() async {
    // TODO: implement getUserCourseStatistics
    final courses = await courseRepository.getCourses();
    return [
      UserCourseStatistics(
        course: courses.first,
        passedTasksCount: 2,
      ),
    ];
  }

  @override
  Future<List<UserCourseStatistics>> getUserAddedCoursesStatistics() async {
    // TODO: implement getUserAddedCoursesStatistics
    return [];
  }

  @override
  Future<List<UserCourseStatistics>> getUserPassedCoursesStatistics() async {
    // TODO: implement getUserPassedCoursesStatistics
    return [];
  }

  @override
  Future<UserStatistics> getUserStatistics() async {
    return UserStatistics(
      currentStreakInDays: 10,
      maxStreakInDays: 30,
      points: 100,
      solvedTasks: 4,
    );
  }

  @override
  Future<List<ActivityCell>> getUserActivityCells() async {
    return ActivityCell.getExampleList();
  }

  @override
  Future<void> addCourseToUser(String courseId) {
    // TODO: implement addCourseToUser
    throw UnimplementedError();
  }

  @override
  Future<void> removeCourseFromUser(String courseId) {
    // TODO: implement removeCourseFromUser
    throw UnimplementedError();
  }

  @override
  Future<void> buyCourse(String courseId) {
    // TODO: implement buyCourse
    throw UnimplementedError();
  }
}
