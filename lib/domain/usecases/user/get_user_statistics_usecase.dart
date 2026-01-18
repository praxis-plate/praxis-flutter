import 'package:codium/core/utils/result.dart';
import 'package:codium/domain/models/user/user_statistic_model.dart';
import 'package:codium/domain/repositories/i_user_statistics_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';

class GetUserStatisticsUseCase {
  final IUserStatisticsRepository _userStatisticsRepository;

  GetUserStatisticsUseCase(this._userStatisticsRepository);

  Future<Result<UserStatisticModel?>> call(String userId) async {
    final result = await _userStatisticsRepository.getByUserId(userId);

    return result.when(
      success: (statistics) {
        if (statistics == null) {
          GetIt.I<Talker>().info('User #$userId doesn\'t have statistics');
        }
        return Success(statistics);
      },
      failure: (failure) => Failure(failure),
    );
  }
}
