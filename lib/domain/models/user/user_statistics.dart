// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:codium/domain/models/models.dart';
import 'package:equatable/equatable.dart';

class UserStatistics extends Equatable {
  final String userId;

  final int currentStreak;
  final int maxStreak;
  final int points;
  final DateTime lastActiveDate;

  final Map<String, UserCourseStatistics> courses; // courseId → статистика

  int get totalSolvedTasks =>
      courses.values.fold(0, (sum, course) => sum + course.solvedTasks);

  Duration get totalLearningTime => courses.values.fold(
    Duration.zero,
    (sum, course) => sum + course.timeSpent,
  );

  const UserStatistics({
    required this.userId,
    required this.currentStreak,
    required this.maxStreak,
    required this.points,
    required this.lastActiveDate,
    required this.courses,
  });

  UserStatistics copyWith({
    String? userId,
    int? currentStreak,
    int? maxStreak,
    int? points,
    DateTime? lastActiveDate,
    Map<String, UserCourseStatistics>? courses,
  }) {
    return UserStatistics(
      userId: userId ?? this.userId,
      currentStreak: currentStreak ?? this.currentStreak,
      maxStreak: maxStreak ?? this.maxStreak,
      points: points ?? this.points,
      lastActiveDate: lastActiveDate ?? this.lastActiveDate,
      courses: courses ?? this.courses,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'currentStreak': currentStreak,
      'maxStreak': maxStreak,
      'points': points,
      'lastActiveDate': lastActiveDate.millisecondsSinceEpoch,
      'courses': courses,
    };
  }

  factory UserStatistics.fromMap(Map<String, dynamic> map) {
    return UserStatistics(
      userId: map['userId'] as String,
      currentStreak: map['currentStreak'] as int,
      maxStreak: map['maxStreak'] as int,
      points: map['points'] as int,
      lastActiveDate: DateTime.fromMillisecondsSinceEpoch(
        map['lastActiveDate'] as int,
      ),
      courses: Map<String, UserCourseStatistics>.from(
        map['courses'] as Map<String, UserCourseStatistics>,
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserStatistics.fromJson(String source) =>
      UserStatistics.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [userId, currentStreak, maxStreak, points, lastActiveDate, courses];
  }
}
