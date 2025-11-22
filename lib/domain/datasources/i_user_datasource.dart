import 'package:codium/domain/models/models.dart';

abstract interface class IUserDataSource {
  Future<User?> fetchCourseById({required String id});
}
