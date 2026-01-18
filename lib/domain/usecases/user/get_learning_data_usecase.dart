import 'package:codium/core/utils/result.dart';
import 'package:codium/domain/models/user/user_statistic_model.dart';
import 'package:codium/domain/repositories/i_user_statistics_repository.dart';
import 'package:codium/domain/usecases/activity/generate_activity_usecase.dart';

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
