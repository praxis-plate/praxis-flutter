import 'package:praxis/core/utils/result.dart';
import 'package:praxis/domain/models/user/user_statistic_model.dart';
import 'package:praxis/domain/repositories/i_user_statistics_repository.dart';
import 'package:praxis/domain/usecases/activity/generate_activity_usecase.dart';

class GetLearningDataUseCase {
  final IUserStatisticsRepository _userStatisticsRepository;
  final GenerateActivityUsecase _generateActivityUsecase;

  GetLearningDataUseCase(
    this._userStatisticsRepository,
    this._generateActivityUsecase,
  );

  Future<Result<UserStatisticModel?>> call(String userId) async {
    await _generateActivityUsecase();
    final result = await _userStatisticsRepository.getByUserId(userId);

    return result.when(
      success: (statistics) => Success(statistics),
      failure: (failure) => Failure(failure),
    );
  }
}
