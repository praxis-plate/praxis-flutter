import 'package:codium/core/error/app_error_code.dart';
import 'package:codium/core/error/failure.dart';
import 'package:codium/core/exceptions/app_error.dart';
import 'package:codium/core/utils/result.dart';
import 'package:codium/data/datasources/remote/course_remote_datasource.dart';
import 'package:codium/data/entities/course_dto_extension.dart';
import 'package:codium/domain/models/course/course_model.dart';
import 'package:codium/domain/repositories/i_course_repository.dart';
import 'package:praxis_client/praxis_client.dart';

class CourseRepository implements ICourseRepository {
  final CourseRemoteDataSource _remoteDataSource;

  const CourseRepository(this._remoteDataSource);

  @override
  Future<Result<List<CourseModel>>> getCourses([int limit = 10]) async {
    try {
      final courseDtos = await _remoteDataSource.getAllCourses();
      final courses = courseDtos.map((dto) => dto.toDomain()).toList();
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
  Future<Result<CourseModel>> getCourseById(int id) async {
    try {
      final courseDetailDto = await _remoteDataSource.getCourseById(id);
      if (courseDetailDto == null) {
        return const Failure(
          AppFailure(
            code: AppErrorCode.apiNotFound,
            message: '',
            canRetry: false,
          ),
        );
      }
      return Success(courseDetailDto.toDomain());
    } on AppError catch (e) {
      return Failure(AppFailure.fromError(e));
    } catch (e) {
      return Failure(AppFailure.fromException(e as Exception));
    }
  }

  @override
  Future<Result<List<CourseModel>>> getEnrolledCourses(String userId) async {
    try {
      final courseDtos = await _remoteDataSource.getEnrolledCourses();
      final courses = courseDtos.map((dto) => dto.toDomain()).toList();
      return Success(courses);
    } on AppError catch (e) {
      return Failure(AppFailure.fromError(e));
    } catch (e) {
      return Failure(AppFailure.fromException(e as Exception));
    }
  }

  @override
  Future<Result<void>> enrollUserInCourse(String userId, int courseId) async {
    await _remoteDataSource.enrollUserInCourse(courseId);
    return const Success(null);
  }

  @override
  Future<Result<bool>> isUserEnrolled(String userId, int courseId) async {
    try {
      final enrolledCourses = await _remoteDataSource.getEnrolledCourses();
      final isEnrolled = enrolledCourses.any((course) => course.id == courseId);
      return Success(isEnrolled);
    } on AppError catch (e) {
      return Failure(AppFailure.fromError(e));
    } catch (e) {
      return Failure(AppFailure.fromException(e as Exception));
    }
  }

  @override
  Future<Result<CourseStructureDto>> getTableOfContents(int courseId) async {
    try {
      final structure = await _remoteDataSource.getTableOfContents(courseId);
      return Success(structure);
    } on AppError catch (e) {
      return Failure(AppFailure.fromError(e));
    } catch (e) {
      return Failure(AppFailure.fromException(e as Exception));
    }
  }
}
