import 'package:codium/domain/models/models.dart';
import 'package:codium/domain/repositories/abstract_course_repository.dart';
import 'package:codium/domain/repositories/abstract_user_repository.dart';
import 'package:codium/domain/repositories/abstract_user_statistics_repository.dart';
import 'package:decimal/decimal.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';

class PurchaseCourseUseCase {
  final ICourseRepository _courseRepository;
  final IUserRepository _userRepository;
  final IUserStatisticsRepository _userStatisticsRepository;

  PurchaseCourseUseCase({
    required ICourseRepository courseRepository,
    required IUserRepository userRepository,
    required IUserStatisticsRepository userStatisticsRepository,
  }) : _courseRepository = courseRepository,
       _userRepository = userRepository,
       _userStatisticsRepository = userStatisticsRepository;

  Future<User> call(String courseId) async {
    try {
      final course = await _courseRepository.getCourseById(courseId);
      final user = await _userRepository.getCurrentUser();

      if (user.purchasedCourseIds.contains(course.id)) {
        GetIt.I<Talker>().log(
          'User #${user.id} already has course #${course.id}',
        );
        return user;
      }

      if (user.balance.amount < course.pricing.price.amount) {
        GetIt.I<Talker>().log(
          'User #${user.id} balance amount less than course price amount #${course.id}: ${user.balance.amount} < ${course.pricing.price.amount}',
        );
        return user;
      }

      Decimal newBalanceAmount =
          user.balance.amount - course.pricing.price.amount;
      final updatedUser = user.copyWith(
        balance: user.balance.copyWith(amount: newBalanceAmount),
        purchasedCourseIds: [...user.purchasedCourseIds, courseId],
      );

      GetIt.I<Talker>().log('Successful bought');

      await _userStatisticsRepository.createUserCourseStatistics(
        userId: user.id,
        courseId: courseId,
      );

      await _userRepository.saveUser(updatedUser);
      return updatedUser;
    } on Exception catch (_) {
      rethrow;
    }
  }
}
