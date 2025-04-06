import 'package:codium/domain/datasources/abstract_auth_datasource.dart';
import 'package:codium/domain/models/models.dart';

class GoAuthDatasource implements IAuthDataSource {
  @override
  Future<User?> signIn({required String email, required String password}) {
    // TODO: implement signIn
    throw UnimplementedError();
  }

  @override
  Future<User?> signUp({required String email, required String password}) {
    // TODO: implement signUp
    throw UnimplementedError();
  }

  @override
  Future<void> signOut() {
    // TODO: implement signOut
    throw UnimplementedError();
  }
}
