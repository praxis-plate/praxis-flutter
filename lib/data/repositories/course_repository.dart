import 'package:codium/core/error/app_error_code.dart';
import 'package:codium/core/error/failure.dart';
import 'package:codium/core/exceptions/app_error.dart';
import 'package:codium/core/utils/result.dart';
import 'package:codium/data/database/app_database.dart';
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
        return const Failure(
          AppFailure(
            code: AppErrorCode.apiNotFound,
            message: '',
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

  @override
  Future<Result<List<CourseModel>>> getEnrolledCourses(int userId) async {
    try {
      final entities = await _localDataSource.getEnrolledCourses(userId);
      final courses = entities.map((e) => e.toDomain()).toList();
      return Success(courses);
    } on AppError catch (e) {
      return Failure(AppFailure.fromError(e));
    } catch (e) {
      return Failure(AppFailure.fromException(e as Exception));
    }
  }

  @override
  Future<Result<void>> enrollUserInCourse(int userId, int courseId) async {
    try {
      final companion = UserCourseCompanion.insert(
        userId: userId,
        courseId: courseId,
      );
      await _localDataSource.enrollUserInCourse(companion);
      return const Success(null);
    } on AppError catch (e) {
      return Failure(AppFailure.fromError(e));
    } catch (e) {
      return Failure(AppFailure.fromException(e as Exception));
    }
  }

  @override
  Future<Result<bool>> isUserEnrolled(int userId, int courseId) async {
    try {
      final isEnrolled = await _localDataSource.isUserEnrolled(
        userId,
        courseId,
      );
      return Success(isEnrolled);
    } on AppError catch (e) {
      return Failure(AppFailure.fromError(e));
    } catch (e) {
      return Failure(AppFailure.fromException(e as Exception));
    }
  }
}
