import 'package:praxis_client/praxis_client.dart';

class UserStatisticsRemoteDataSource {
  final Client _client;

  const UserStatisticsRemoteDataSource(this._client);

  Future<UserStatisticsDto> getUserStatistics() async {
    return await _client.userStatistics.get();
  }
}
