import 'package:codium/data/database/app_database.dart';
import 'package:codium/domain/datasources/datasources.dart';
import 'package:drift/drift.dart';

class UserStatisticsLocalDataSource implements IUserStatisticsLocalDataSource {
  final AppDatabase _db;

  const UserStatisticsLocalDataSource(this._db);

  @override
  Future<UserStatisticEntity?> getStatistics(int userId) async {
    return await _db.managers.userStatistic
        .filter((f) => f.userId.id(userId))
        .getSingleOrNull();
  }

  @override
  Future<void> updateStatistics(UserStatisticCompanion entry) async {
    if (!entry.id.present) {
      throw ArgumentError('Module id must be present for update');
    }

    final int id = entry.id.value;

    await (_db.update(
      _db.userStatistic,
    )..where((t) => t.id.equals(id))).write(entry);
  }

  @override
  Future<void> clearStatistics(int userId) async {
    await _db
        .into(_db.userStatistic)
        .insertOnConflictUpdate(
          UserStatisticCompanion(
            userId: Value(userId),
            currentStreak: const Value(0),
            maxStreak: const Value(0),
            points: const Value(0),
            lastActiveDate: Value(DateTime.now()),
          ),
        );
  }
}
