import 'package:praxis/core/error/app_error_code.dart';
import 'package:praxis/core/error/failure.dart';
import 'package:praxis/core/exceptions/app_error.dart';
import 'package:praxis/core/utils/result.dart';
import 'package:praxis/data/datasources/local/course_local_datasource.dart';
import 'package:praxis/data/datasources/local/lesson_local_datasource.dart';
import 'package:praxis/data/datasources/local/module_local_datasource.dart';
import 'package:praxis/data/datasources/local/task_local_datasource.dart';
import 'package:praxis/data/datasources/remote/course_remote_datasource.dart';
import 'package:praxis/data/entities/course_dto_extension.dart';
import 'package:praxis/data/entities/lesson_dto_extension.dart';
import 'package:praxis/data/entities/module_dto_extension.dart';
import 'package:praxis/data/entities/task_dto_extension.dart';
import 'package:praxis/data/mappers/course_structure_mapper.dart';
import 'package:praxis/domain/models/course/course_model.dart';
import 'package:praxis/domain/models/course/course_structure_model.dart';
import 'package:praxis/domain/repositories/i_course_repository.dart';
import 'package:praxis_client/praxis_client.dart';

class CourseRepository implements ICourseRepository {
  final CourseRemoteDataSource _remoteDataSource;
  final CourseLocalDataSource _courseLocalDataSource;
  final ModuleLocalDataSource _moduleLocalDataSource;
  final LessonLocalDataSource _lessonLocalDataSource;
  final TaskLocalDataSource _taskLocalDataSource;

  const CourseRepository(
    this._remoteDataSource,
    this._courseLocalDataSource,
    this._moduleLocalDataSource,
    this._lessonLocalDataSource,
    this._taskLocalDataSource,
  );

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
      return Failure(AppFailure.fromException(e));
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
      await _syncCourseDetail(courseDetailDto);
      return Success(courseDetailDto.toDomain());
    } on AppError catch (e) {
      return Failure(AppFailure.fromError(e));
    } catch (e) {
      return Failure(AppFailure.fromException(e));
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
      return Failure(AppFailure.fromException(e));
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
      return Failure(AppFailure.fromException(e));
    }
  }

  @override
  Future<Result<CourseStructureModel>> getTableOfContents(int courseId) async {
    try {
      final structure = await _remoteDataSource.getTableOfContents(courseId);
      return Success(structure.toDomain());
    } on AppError catch (e) {
      return Failure(AppFailure.fromError(e));
    } catch (e) {
      return Failure(AppFailure.fromException(e));
    }
  }

  Future<void> _syncCourseDetail(CourseDetailDto detail) async {
    await _upsertCourse(detail.course);

    for (final module in detail.modules) {
      await _upsertModule(module);
    }

    for (final lesson in detail.lessons) {
      await _upsertLesson(lesson);
    }

    for (final task in detail.tasks) {
      await _upsertTask(task);
    }
  }

  Future<void> _upsertCourse(CourseDto dto) async {
    final existing = await _courseLocalDataSource.getCourseById(dto.id);
    final companion = dto.toCompanion();
    if (existing == null) {
      await _courseLocalDataSource.insertCourse(companion);
    } else {
      await _courseLocalDataSource.updateCourse(companion);
    }
  }

  Future<void> _upsertModule(ModuleDto dto) async {
    final existing = await _moduleLocalDataSource.getModuleById(dto.id);
    final companion = dto.toCompanion();
    if (existing == null) {
      await _moduleLocalDataSource.insertModule(companion);
    } else {
      await _moduleLocalDataSource.updateModule(companion);
    }
  }

  Future<void> _upsertLesson(LessonDto dto) async {
    final existing = await _lessonLocalDataSource.getLessonById(dto.id);
    final companion = dto.toCompanion();
    if (existing == null) {
      await _lessonLocalDataSource.insertLesson(companion);
    } else {
      await _lessonLocalDataSource.updateLesson(companion);
    }
  }

  Future<void> _upsertTask(TaskDto dto) async {
    final existing = await _taskLocalDataSource.getTaskById(dto.id);
    final companion = dto.toCompanion();
    if (existing == null) {
      await _taskLocalDataSource.insertTask(companion);
    } else {
      await _taskLocalDataSource.updateTask(companion);
    }
  }
}
