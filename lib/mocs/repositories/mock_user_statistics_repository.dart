import 'dart:async';

import 'package:codium/domain/models/models.dart';
import 'package:codium/domain/repositories/abstract_user_statistics_repository.dart';
import 'package:codium/mocs/data/mock_courses.dart';
import 'package:codium/mocs/data/mock_user_statistics.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';

class MockUserStatisticsRepository implements IUserStatisticsRepository {
  @override
  Future<UserStatistics> getStatisticsByUserId(String userId) async {
    await Future.delayed(const Duration(milliseconds: 300));

    GetIt.I<Talker>().error('userId: $userId');

    if (userId == 'mock_1') {
      return mockUserStatistics;
    } else {
      throw Exception('User not found');
    }
  }

  @override
  Future<Course> getCourseStatistics(String userId, String courseId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return mockCourses.firstWhere((course) => course.id == courseId);
  }
}
