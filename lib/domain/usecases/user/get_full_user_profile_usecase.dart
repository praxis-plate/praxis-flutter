import 'package:codium/core/error/failure.dart';
import 'package:codium/core/utils/result.dart';
import 'package:codium/domain/models/user/full_user_profile_model.dart';
import 'package:codium/domain/models/user/money.dart';
import 'package:codium/domain/models/user/user_profile_model.dart';
import 'package:codium/domain/repositories/i_course_repository.dart';
import 'package:codium/domain/repositories/i_user_statistics_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';

class GetFullUserProfileUseCase {
  final IUserStatisticsRepository _userStatisticsRepository;
  final ICourseRepository _courseRepository;

  GetFullUserProfileUseCase(
    this._userStatisticsRepository,
    this._courseRepository,
  );

  Future<Result<FullUserProfileModel>> call(UserProfileModel profile) async {
    try {
      final statisticsResult = await _userStatisticsRepository.getByUserId(
        profile.id,
      );

      final statistics = statisticsResult.dataOrNull;
      final currentStreak = statistics?.currentStreak ?? 0;
      final maxStreak = statistics?.maxStreak ?? 0;
      final balance = statistics?.balance ?? Money.zero();

      GetIt.I<Talker>().info(
        '💰 User balance from statistics: userId=${profile.id}, balance=${balance.amount}',
      );

      final coursesResult = await _courseRepository.getEnrolledCourses(
        profile.id,
      );
      final purchasedCourseIds = coursesResult.isSuccess
          ? coursesResult.dataOrNull!.map((c) => c.id).toList()
          : <int>[];

      return Success(
        FullUserProfileModel(
          profile: profile,
          balance: balance,
          purchasedCourseIds: purchasedCourseIds,
          currentStreak: currentStreak,
          maxStreak: maxStreak,
        ),
      );
    } catch (e) {
      return Failure(AppFailure.fromException(e));
    }
  }
}
