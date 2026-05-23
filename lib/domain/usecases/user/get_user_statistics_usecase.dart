import 'package:praxis/core/utils/result.dart';
import 'package:praxis/domain/models/user/user_statistic_model.dart';
import 'package:praxis/domain/repositories/i_user_statistics_repository.dart';

class GetUserStatisticsUseCase {
  final IUserStatisticsRepository _userStatisticsRepository;

  GetUserStatisticsUseCase(this._userStatisticsRepository);

  Future<Result<UserStatisticModel?>> call(String userId) async {
    final result = await _userStatisticsRepository.getByUserId(userId);

    return result.when(
      success: (statistics) => Success(statistics),
      failure: (failure) => Failure(failure),
    );
  }
}
