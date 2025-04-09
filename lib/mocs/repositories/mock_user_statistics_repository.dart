import 'dart:async';

import 'package:codium/core/exceptions/user_statistics_exception.dart';
import 'package:codium/domain/models/models.dart';
import 'package:codium/domain/repositories/abstract_user_statistics_repository.dart';
import 'package:codium/mocs/data/mock_courses.dart';
import 'package:codium/mocs/data/mock_user_statistics.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';

class MockUserStatisticsRepository implements IUserStatisticsRepository {
  final _delay = const Duration(milliseconds: 300);

  @override
  Future<UserCourseStatistics> createUserCourseStatistics({
    required String userId,
    required String courseId,
  }) async {
    await Future.delayed(_delay);

    if (!mockUserStatistics.courses.containsKey(courseId)) {
      final newStats = UserCourseStatistics(
        courseId: courseId,
        progress: 0,
        totalTasks:
            mockCourses.firstWhere((c) => c.id == courseId).tasks.length,
        solvedTasks: 0,
        timeSpent: Duration.zero,
        lastActivity: DateTime.now(),
      );

      mockUserStatistics = mockUserStatistics.copyWith(
        courses: {...mockUserStatistics.courses, courseId: newStats},
      );

      GetIt.I<Talker>().log(mockUserStatistics.courses.entries.toString());
    }

    return mockUserStatistics.courses[courseId]!;
  }

  @override
  Future<bool> exists(String userId) async {
    await Future.delayed(_delay);
    return userId == 'mock_1';
  }

  @override
  Future<UserStatistics> get(String userId) async {
    await Future.delayed(const Duration(milliseconds: 300));

    if (userId == 'mock_1') {
      return mockUserStatistics;
    } else {
      throw UserStatisticsException('User not found');
    }
  }

  @override
  Future<UserCourseStatistics> getUserCourseStatistics({
    required String userId,
    required String courseId,
  }) async {
    await Future.delayed(_delay);

    if (userId != 'mock_1') {
      throw UserStatisticsException('User not found');
    }

    if (!mockUserStatistics.courses.containsKey(courseId) ||
        mockUserStatistics.courses[courseId] == null) {
      throw UserStatisticsException('Course statistics not found');
    }

    return mockUserStatistics.courses[courseId]!;
  }

  @override
  Future<void> reset(String userId) async {
    await Future.delayed(_delay);

    if (userId == 'mock_1') {
      mockUserStatistics = mockUserStatistics.copyWith(
        courses: {},
        currentStreak: 0,
        maxStreak: 0,
        points: 0,
        lastActiveDate: DateTime.now(),
      );
    }

    throw UnimplementedError();
  }

  @override
  Future<void> update(UserStatistics userStatistics) async {
    await Future.delayed(_delay);
    mockUserStatistics = userStatistics;
  }
}
