import 'package:codium/domain/repositories/abstract_course_repository.dart';
import 'package:codium/domain/repositories/abstract_user_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:talker/talker.dart';

class PurchaseCourseUseCase {
  final ICourseRepository _courseRepo;
  final IUserRepository _userRepo;

  PurchaseCourseUseCase({
    required ICourseRepository courseRepo,
    required IUserRepository userRepo,
  }) : _courseRepo = courseRepo, _userRepo = userRepo;

  Future<void> execute(String courseId) async {
    final course = await _courseRepo.getCourseById(courseId);
    final user = await _userRepo.getCurrentUser();

    if (user.balance < course.pricing.price) {
      GetIt.I<Talker>().error('User balance less than course price');
      return;
    }

    final newBalance = user.balance - course.pricing.price;
    final updatedUser = user.copyWith(balance: newBalance);

    await _userRepo.saveUser(updatedUser);
  }
}