import 'package:codium/data/database/app_database.dart';
import 'package:codium/domain/datasources/i_user_statistics_local_datasource.dart';

class UserStatisticsLocalDataSource implements IUserStatisticsLocalDataSource {
  final AppDatabase _db;

  const UserStatisticsLocalDataSource(this._db);

  @override
  Future<UserStatisticEntity?> getStatisticsByUserId(String userId) async {
    return await _db.managers.userStatistic
        .filter((f) => f.userId.id(userId))
        .getSingleOrNull();
  }

  @override
  Future<UserStatisticEntity> insertStatistics(
    UserStatisticCompanion entry,
  ) async {
    return await _db.into(_db.userStatistic).insertReturning(entry);
  }

  @override
  Future<void> updateStatistics(UserStatisticCompanion entry) async {
    if (!entry.id.present) {
      throw ArgumentError('UserStatistic id must be present for update');
    }

    final int id = entry.id.value;

    await (_db.update(
      _db.userStatistic,
    )..where((t) => t.id.equals(id))).write(entry);
  }

  @override
  Future<void> deleteStatistics(String userId) async {
    await _db.managers.userStatistic
        .filter((f) => f.userId.id(userId))
        .delete();
  }
}
