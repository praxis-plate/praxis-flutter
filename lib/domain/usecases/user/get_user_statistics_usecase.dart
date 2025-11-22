import 'package:codium/core/exceptions/user_statistics_exception.dart';
import 'package:codium/domain/models/models.dart';
import 'package:codium/domain/repositories/abstract_user_statistics_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';

class GetUserStatisticsUseCase {
  final IUserStatisticsRepository _userStatisticsRepository;

  GetUserStatisticsUseCase(this._userStatisticsRepository);

  Future<UserStatistics> call(String userId) async {
    try {
      final statisticsExist = await _userStatisticsRepository.exists(userId);

      if (!statisticsExist) {
        final message = 'User #$userId doesn\'t have statistics';
        GetIt.I<Talker>().log(message);
        throw UserStatisticsException(message);
      }

      return await _userStatisticsRepository.get(userId);
    } catch (e) {
      rethrow;
    }
  }
}
