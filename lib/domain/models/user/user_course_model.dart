import 'package:equatable/equatable.dart';

class UserCourseModel extends Equatable {
  final int id;
  final String userId;
  final int courseId;
  final DateTime enrolledAt;
  final bool isCompleted;
  final DateTime? completedAt;

  const UserCourseModel({
    required this.id,
    required this.userId,
    required this.courseId,
    required this.enrolledAt,
    required this.isCompleted,
    this.completedAt,
  });

  UserCourseModel copyWith({
    int? id,
    String? userId,
    int? courseId,
    DateTime? enrolledAt,
    bool? isCompleted,
    DateTime? completedAt,
  }) {
    return UserCourseModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      courseId: courseId ?? this.courseId,
      enrolledAt: enrolledAt ?? this.enrolledAt,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    userId,
    courseId,
    enrolledAt,
    isCompleted,
    completedAt,
  ];

  @override
  bool get stringify => true;
}
