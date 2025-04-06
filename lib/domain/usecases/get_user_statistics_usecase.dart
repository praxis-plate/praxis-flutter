import 'package:codium/core/exceptions/user_statistics_exception.dart';
import 'package:codium/domain/models/models.dart';
import 'package:codium/domain/repositories/abstract_user_statistics_repository.dart';

class GetUserStatisticsUseCase {
  final IUserStatisticsRepository _userStatisticsRepository;

  GetUserStatisticsUseCase(this._userStatisticsRepository);

  Future<UserStatistics> execute(String userId) async {
    try {
      return await _userStatisticsRepository.getStatisticsByUserId(userId);
    } catch (e) {
      throw UserStatisticsException(
          'Ошибка загрузки статистики: ${e.toString()}',);
    }
  }
}
