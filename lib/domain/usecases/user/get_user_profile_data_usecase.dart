import 'package:codium/core/utils/result.dart';
import 'package:codium/domain/models/user/user.dart';
import 'package:codium/domain/repositories/i_achievement_repository.dart';
import 'package:codium/domain/repositories/i_user_repository.dart';
import 'package:codium/domain/repositories/i_user_statistics_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';

class GetUserProfileDataUseCase {
  final IUserRepository _userRepository;
  final IUserStatisticsRepository _userStatisticsRepository;
  final IAchievementRepository _achievementRepository;

  const GetUserProfileDataUseCase({
    required IUserRepository userRepository,
    required IUserStatisticsRepository userStatisticsRepository,
    required IAchievementRepository achievementRepository,
  }) : _userRepository = userRepository,
       _userStatisticsRepository = userStatisticsRepository,
       _achievementRepository = achievementRepository;

  Future<Result<UserProfileDataModel>> call(int userId) async {
    final userResult = await _userRepository.getUserById(userId);

    return userResult.when(
      success: (user) async {
        final statsResult = await _userStatisticsRepository.getByUserId(userId);

        return statsResult.when(
          success: (stats) async {
            final achievementsResult = await _achievementRepository
                .getUserAchievements(userId);

            return achievementsResult.when(
              success: (achievements) {
                final coinBalance = stats?.balance.amount ?? 0;

                GetIt.I<Talker>().info(
                  '💰 Profile balance from statistics: userId=$userId, balance=$coinBalance',
                );

                return Success(
                  UserProfileDataModel(
                    user: user,
                    totalCoursesCompleted: 0,
                    totalLessonsCompleted: 0,
                    achievements: achievements,
                    currentStreak: stats?.currentStreak ?? 0,
                    coinBalance: coinBalance,
                  ),
                );
              },
              failure: (failure) => Failure(failure),
            );
          },
          failure: (failure) => Failure(failure),
        );
      },
      failure: (failure) => Failure(failure),
    );
  }
}
