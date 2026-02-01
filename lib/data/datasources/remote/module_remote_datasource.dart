import 'package:praxis_client/praxis_client.dart';

class ModuleRemoteDataSource {
  final Client _client;

  const ModuleRemoteDataSource(this._client);

  Future<List<ModuleDto>> getModulesByCourseId(int courseId) async {
    return await _client.module.get(courseId);
  }
}
