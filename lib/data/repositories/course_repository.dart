import 'package:codium/core/error/failure.dart';
import 'package:codium/core/exceptions/app_error.dart';
import 'package:codium/core/utils/result.dart';
import 'package:codium/data/entities/course_entity_extension.dart';
import 'package:codium/domain/datasources/i_course_local_datasource.dart';
import 'package:codium/domain/models/course/course_model.dart';
import 'package:codium/domain/repositories/i_course_repository.dart';

class CourseRepository implements ICourseRepository {
  final ICourseLocalDataSource _localDataSource;

  const CourseRepository(this._localDataSource);

  @override
  Future<Result<List<CourseModel>>> getCourses([int limit = 10]) async {
    try {
      final entities = await _localDataSource.getAllCourses();
      final courses = entities.map((e) => e.toDomain()).toList();
      final sortedCourses = List<CourseModel>.from(courses)
        ..sort((a, b) => b.rating.compareTo(a.rating));
      return Success(sortedCourses.take(limit).toList());
    } on AppError catch (e) {
      return Failure(AppFailure.fromError(e));
    } catch (e) {
      return Failure(AppFailure.fromException(e as Exception));
    }
  }

  @override
  Future<Result<CourseModel>> getCourseById(String id) async {
    try {
      final entity = await _localDataSource.getCourseById(int.parse(id));
      if (entity == null) {
        return Failure(
          AppFailure(
            code: AppErrorCode.apiNotFound,
            message: 'Course not found with id: $id',
            canRetry: false,
          ),
        );
      }
      return Success(entity.toDomain());
    } on AppError catch (e) {
      return Failure(AppFailure.fromError(e));
    } catch (e) {
      return Failure(AppFailure.fromException(e as Exception));
    }
  }

  @override
  Future<Result<List<CourseModel>>> getCoursesByCategory(
    String category,
  ) async {
    try {
      final entities = await _localDataSource.getCoursesByCategory(category);
      final courses = entities.map((e) => e.toDomain()).toList();
      final sortedCourses = List<CourseModel>.from(courses)
        ..sort((a, b) => b.rating.compareTo(a.rating));
      return Success(sortedCourses);
    } on AppError catch (e) {
      return Failure(AppFailure.fromError(e));
    } catch (e) {
      return Failure(AppFailure.fromException(e as Exception));
    }
  }
}
