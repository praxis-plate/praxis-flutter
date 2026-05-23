import 'package:praxis/core/error/failure.dart';
import 'package:praxis/core/utils/result.dart';
import 'package:praxis/domain/models/user/full_user_profile_model.dart';
import 'package:praxis/domain/models/user/money.dart';
import 'package:praxis/domain/repositories/i_course_repository.dart';
import 'package:praxis/domain/repositories/i_user_repository.dart';
import 'package:praxis/domain/repositories/i_user_statistics_repository.dart';

class GetFullUserProfileUseCase {
  final IUserRepository _userRepository;
  final IUserStatisticsRepository _userStatisticsRepository;
  final ICourseRepository _courseRepository;

  GetFullUserProfileUseCase(
    this._userRepository,
    this._userStatisticsRepository,
    this._courseRepository,
  );

  Future<Result<FullUserProfileModel>> call(String userId) async {
    try {
      final profileResult = await _userRepository.getUserById(userId);
      if (profileResult.isFailure) {
        return Failure(profileResult.failureOrNull!);
      }

      final profile = profileResult.dataOrNull!;

      final statisticsResult = await _userStatisticsRepository.getByUserId(
        userId,
      );
      final statistics = statisticsResult.dataOrNull;
      final currentStreak = statistics?.currentStreak ?? 0;
      final maxStreak = statistics?.maxStreak ?? 0;
      final balance = statistics?.balance ?? Money.zero();

      final coursesResult = await _courseRepository.getEnrolledCourses(userId);
      final purchasedCourseIds = coursesResult.isSuccess
          ? coursesResult.dataOrNull!.map((course) => course.id).toList()
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
