import 'package:codium/core/error/app_error_code.dart';
import 'package:codium/core/error/failure.dart';
import 'package:codium/core/utils/result.dart';
import 'package:codium/domain/enums/coin_transaction_type.dart';
import 'package:codium/domain/models/coin_transaction/create_coin_transaction_model.dart';
import 'package:codium/domain/repositories/i_coin_transaction_repository.dart';
import 'package:codium/domain/repositories/i_course_repository.dart';
import 'package:codium/domain/repositories/i_user_statistics_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';

class PurchaseCourseUseCase {
  final ICourseRepository _courseRepository;
  final IUserStatisticsRepository _userStatisticsRepository;
  final ICoinTransactionRepository _coinTransactionRepository;

  PurchaseCourseUseCase({
    required ICourseRepository courseRepository,
    required IUserStatisticsRepository userStatisticsRepository,
    required ICoinTransactionRepository coinTransactionRepository,
  }) : _courseRepository = courseRepository,
       _userStatisticsRepository = userStatisticsRepository,
       _coinTransactionRepository = coinTransactionRepository;

  Future<Result<void>> call(String userId, int courseId) async {
    final courseResult = await _courseRepository.getCourseById(courseId);
    if (courseResult.isFailure) {
      return Failure(courseResult.failureOrNull!);
    }

    final course = courseResult.dataOrNull!;

    final isEnrolledResult = await _courseRepository.isUserEnrolled(
      userId,
      courseId,
    );
    if (isEnrolledResult.isFailure) {
      return Failure(isEnrolledResult.failureOrNull!);
    }

    if (isEnrolledResult.dataOrNull == true) {
      return const Failure(
        AppFailure(
          code: AppErrorCode.validationInvalid,
          message: 'Course already purchased',
          canRetry: false,
        ),
      );
    }

    final statisticsResult = await _userStatisticsRepository.getByUserId(
      userId,
    );
    if (statisticsResult.isFailure) {
      return Failure(statisticsResult.failureOrNull!);
    }

    final statistics = statisticsResult.dataOrNull;
    if (statistics == null) {
      return const Failure(
        AppFailure(
          code: AppErrorCode.apiNotFound,
          message: 'User statistics not found',
          canRetry: false,
        ),
      );
    }

    final currentBalance = statistics.balance.amount;

    GetIt.I<Talker>().info(
      '💰 Balance check: available=$currentBalance, '
      'required=${course.priceInCoins}, courseId=${course.id}',
    );

    if (currentBalance < course.priceInCoins) {
      GetIt.I<Talker>().warning(
        '❌ Insufficient balance: need ${course.priceInCoins - currentBalance} more coins',
      );
      return const Failure(
        AppFailure(
          code: AppErrorCode.insufficientBalance,
          message: 'Insufficient balance to purchase course',
          canRetry: false,
        ),
      );
    }

    final transactionResult = await _coinTransactionRepository.create(
      CreateCoinTransactionModel(
        userId: userId,
        amount: -course.priceInCoins,
        type: CoinTransactionType.coursePurchase,
        relatedEntityId: courseId.toString(),
      ),
    );

    if (transactionResult.isFailure) {
      return Failure(transactionResult.failureOrNull!);
    }

    final enrollResult = await _courseRepository.enrollUserInCourse(
      userId,
      courseId,
    );
    if (enrollResult.isFailure) {
      return Failure(enrollResult.failureOrNull!);
    }

    GetIt.I<Talker>().info(
      'Course purchased successfully: $courseId by user: $userId',
    );
    return const Success(null);
  }
}
