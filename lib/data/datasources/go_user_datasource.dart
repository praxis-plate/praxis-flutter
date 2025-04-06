import 'package:codium/domain/datasources/abstract_user_datasource.dart';
import 'package:codium/domain/models/user.dart';

class GoUserDatasource implements IUserDataSource {
  @override
  Future<User?> fetchCourseById({required String id}) {
    // TODO: implement fetchCourseById
    throw UnimplementedError();
  }
}