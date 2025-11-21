import 'dart:convert';

import 'package:codium/domain/datasources/abstract_user_statistics_local_datasource.dart';
import 'package:codium/domain/models/models.dart';
import 'package:drift/drift.dart';

import 'app_database.dart';

class UserStatisticsLocalDataSource implements IUserStatisticsLocalDataSource {
  final AppDatabase _db;

  UserStatisticsLocalDataSource(this._db);

  @override
  Future<void> clearStatistics(String userId) async {
    await (_db.delete(
      _db.userStatisticsTable,
    )..where((tbl) => tbl.userId.equals(userId))).go();
  }

  @override
  Future<UserStatistics?> getStatistics(String userId) async {
    final entity = await (_db.select(
      _db.userStatisticsTable,
    )..where((tbl) => tbl.userId.equals(userId))).getSingleOrNull();

    if (entity == null) return null;

    final coursesMap = jsonDecode(entity.coursesJson) as Map<String, dynamic>;
    final courses = coursesMap.map(
      (key, value) => MapEntry(
        key,
        UserCourseStatistics(
          courseId: value['courseId'] as String,
          progress: (value['progress'] as num).toDouble(),
          totalTasks: (value['totalTasks'] as num).toInt(),
          solvedTasks: (value['solvedTasks'] as num).toInt(),
          timeSpent: Duration(
            milliseconds: (value['timeSpent'] as num).toInt(),
          ),
          lastActivity: DateTime.parse(value['lastActivity'] as String),
        ),
      ),
    );

    return UserStatistics(
      userId: entity.userId,
      currentStreak: entity.currentStreak,
      maxStreak: entity.maxStreak,
      points: entity.points,
      lastActiveDate: entity.lastActiveDate,
      courses: courses,
    );
  }

  @override
  Future<void> saveStatistics(UserStatistics statistics) async {
    final coursesJson = jsonEncode(
      statistics.courses.map(
        (key, value) => MapEntry(key, {
          'courseId': value.courseId,
          'progress': value.progress,
          'totalTasks': value.totalTasks,
          'solvedTasks': value.solvedTasks,
          'timeSpent': value.timeSpent.inMilliseconds,
          'lastActivity': value.lastActivity.toIso8601String(),
        }),
      ),
    );

    final existing = await (_db.select(
      _db.userStatisticsTable,
    )..where((tbl) => tbl.userId.equals(statistics.userId))).getSingleOrNull();

    if (existing == null) {
      await _db
          .into(_db.userStatisticsTable)
          .insert(
            UserStatisticsTableCompanion.insert(
              userId: statistics.userId,
              currentStreak: Value(statistics.currentStreak),
              maxStreak: Value(statistics.maxStreak),
              points: Value(statistics.points),
              lastActiveDate: statistics.lastActiveDate,
              coursesJson: coursesJson,
            ),
          );
    } else {
      await (_db.update(
        _db.userStatisticsTable,
      )..where((tbl) => tbl.userId.equals(statistics.userId))).write(
        UserStatisticsTableCompanion(
          currentStreak: Value(statistics.currentStreak),
          maxStreak: Value(statistics.maxStreak),
          points: Value(statistics.points),
          lastActiveDate: Value(statistics.lastActiveDate),
          coursesJson: Value(coursesJson),
        ),
      );
    }
  }
}
