import 'package:praxis/core/utils/result.dart';
import 'package:praxis/domain/models/achievement/achievement_data_model.dart';
import 'package:praxis/domain/repositories/i_achievement_repository.dart';
import 'package:praxis/domain/repositories/i_user_statistics_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';

class CheckStreakAndAwardAchievementUseCase {
  static const int _unstoppableStreakThreshold = 30;
  static const int _unstoppableAchievementId = 30;

  final IUserStatisticsRepository _userStatisticsRepository;
  final IAchievementRepository _achievementRepository;

  const CheckStreakAndAwardAchievementUseCase({
    required IUserStatisticsRepository userStatisticsRepository,
    required IAchievementRepository achievementRepository,
  }) : _userStatisticsRepository = userStatisticsRepository,
       _achievementRepository = achievementRepository;

  Future<Result<AchievementModel?>> call(String userId) async {
    final userStatsResult = await _userStatisticsRepository.getByUserId(userId);

    if (userStatsResult.isFailure) {
      return Failure(userStatsResult.failureOrNull!);
    }

    final userStats = userStatsResult.dataOrNull;
    if (userStats == null) {
      return const Success(null);
    }

    final streak = userStats.currentStreak;
    if (streak < _unstoppableStreakThreshold) {
      return const Success(null);
    }

    final isUnlockedResult = await _achievementRepository.isAchievementUnlocked(
      userId,
      _unstoppableAchievementId,
    );

    if (isUnlockedResult.isFailure) {
      return Failure(isUnlockedResult.failureOrNull!);
    }

    final isUnlocked = isUnlockedResult.dataOrNull!;
    if (isUnlocked) {
      return const Success(null);
    }

    final unlockResult = await _achievementRepository.unlockAchievement(
      userId,
      _unstoppableAchievementId,
    );

    if (unlockResult.isFailure) {
      return Failure(unlockResult.failureOrNull!);
    }

    final allAchievementsResult = await _achievementRepository
        .getAllAchievements();

    if (allAchievementsResult.isFailure) {
      return Failure(allAchievementsResult.failureOrNull!);
    }

    final achievement = allAchievementsResult.dataOrNull!.firstWhere(
      (a) => a.id == _unstoppableAchievementId,
    );

    GetIt.I<Talker>().info(
      'Unstoppable achievement unlocked for user $userId with streak $streak',
    );

    return Success(achievement);
  }
}
