import 'package:codium/core/error/failure.dart';
import 'package:codium/core/exceptions/app_error.dart';
import 'package:codium/core/utils/result.dart';
import 'package:codium/data/entities/achievement_entity_extension.dart';
import 'package:codium/domain/datasources/i_achievement_local_datasource.dart';
import 'package:codium/domain/models/achievement/achievement_data_model.dart';
import 'package:codium/domain/repositories/i_achievement_repository.dart';

class AchievementRepository implements IAchievementRepository {
  final IAchievementLocalDataSource _achievementDataSource;

  const AchievementRepository(this._achievementDataSource);

  @override
  Future<Result<List<AchievementModel>>> getUserAchievements(int userId) async {
    try {
      final entities = await _achievementDataSource.getUserAchievements(userId);
      final achievements = entities.map((e) => e.toDomain()).toList();
      return Success(achievements);
    } on AppError catch (e) {
      return Failure(AppFailure.fromError(e));
    } catch (e) {
      return Failure(AppFailure.fromException(e as Exception));
    }
  }

  @override
  Future<Result<void>> unlockAchievement(int userId, int achievementId) async {
    try {
      final isUnlockedResult = await isAchievementUnlocked(
        userId,
        achievementId,
      );

      return isUnlockedResult.when(
        success: (isUnlocked) async {
          if (!isUnlocked) {
            await _achievementDataSource.insertUserAchievement(
              userId,
              achievementId,
              DateTime.now(),
            );
          }
          return const Success(null);
        },
        failure: (failure) => Failure(failure),
      );
    } on AppError catch (e) {
      return Failure(AppFailure.fromError(e));
    } catch (e) {
      return Failure(AppFailure.fromException(e as Exception));
    }
  }

  @override
  Future<Result<bool>> isAchievementUnlocked(
    int userId,
    int achievementId,
  ) async {
    try {
      final achievement = await _achievementDataSource.getUserAchievement(
        userId,
        achievementId,
      );
      return Success(achievement != null);
    } on AppError catch (e) {
      return Failure(AppFailure.fromError(e));
    } catch (e) {
      return Failure(AppFailure.fromException(e as Exception));
    }
  }

  @override
  Future<Result<List<AchievementModel>>> getAllAchievements() async {
    try {
      final entities = await _achievementDataSource.getAllAchievements();
      final achievements = entities.map((e) => e.toDomain()).toList();
      return Success(achievements);
    } on AppError catch (e) {
      return Failure(AppFailure.fromError(e));
    } catch (e) {
      return Failure(AppFailure.fromException(e as Exception));
    }
  }
}
