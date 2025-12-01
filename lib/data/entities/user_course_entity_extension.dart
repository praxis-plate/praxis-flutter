import 'package:codium/data/database/app_database.dart';
import 'package:codium/domain/models/user/user_course_model.dart';

extension UserCourseEntityExtension on UserCourseEntity {
  UserCourseModel toDomain() {
    return UserCourseModel(
      id: id,
      userId: userId,
      courseId: courseId,
      enrolledAt: enrolledAt,
      isCompleted: isCompleted,
      completedAt: completedAt,
    );
  }
}
