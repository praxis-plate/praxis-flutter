import 'package:codium/core/error/failure.dart';
import 'package:codium/core/exceptions/app_error.dart';
import 'package:codium/core/utils/result.dart';
import 'package:codium/data/datasources/remote/achievement_remote_datasource.dart';
import 'package:codium/data/entities/achievement_dto_extension.dart';
import 'package:codium/domain/models/achievement/achievement_data_model.dart';
import 'package:codium/domain/repositories/i_achievement_repository.dart';

class AchievementRepository implements IAchievementRepository {
  final AchievementRemoteDataSource _remoteDataSource;

  const AchievementRepository(this._remoteDataSource);

  @override
  Future<Result<List<AchievementModel>>> getUserAchievements(
    String userId,
  ) async {
    try {
      final achievementDtos = await _remoteDataSource.getUserAchievements();
      final achievements = achievementDtos
          .map((dto) => dto.toDomain())
          .toList();
      return Success(achievements);
    } on AppError catch (e) {
      return Failure(AppFailure.fromError(e));
    } catch (e) {
      return Failure(AppFailure.fromException(e as Exception));
    }
  }

  @override
  Future<Result<void>> unlockAchievement(
    String userId,
    int achievementId,
  ) async {
    try {
      final isUnlockedResult = await isAchievementUnlocked(
        userId,
        achievementId,
      );

      return isUnlockedResult.when(
        success: (isUnlocked) async {
          if (!isUnlocked) {
            await _remoteDataSource.unlockAchievement(achievementId);
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
    String userId,
    int achievementId,
  ) async {
    try {
      final isUnlocked = await _remoteDataSource.isAchievementUnlocked(
        achievementId,
      );
      return Success(isUnlocked);
    } on AppError catch (e) {
      return Failure(AppFailure.fromError(e));
    } catch (e) {
      return Failure(AppFailure.fromException(e as Exception));
    }
  }

  @override
  Future<Result<List<AchievementModel>>> getAllAchievements() async {
    try {
      final achievementDtos = await _remoteDataSource.getAllAchievements();
      final achievements = achievementDtos
          .map((dto) => dto.toDomain())
          .toList();
      return Success(achievements);
    } on AppError catch (e) {
      return Failure(AppFailure.fromError(e));
    } catch (e) {
      return Failure(AppFailure.fromException(e as Exception));
    }
  }
}
