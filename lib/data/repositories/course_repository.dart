import 'package:praxis/data/database/app_database.dart';
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
import 'package:praxis/data/entities/course_entity_extension.dart';
import 'package:praxis/data/mappers/course_structure_mapper.dart';
import 'package:praxis/domain/models/course/course_model.dart';
import 'package:praxis/domain/models/course/course_structure_lesson_model.dart';
import 'package:praxis/domain/models/course/course_structure_model.dart';
import 'package:praxis/domain/models/course/course_structure_module_model.dart';
import 'package:praxis/domain/repositories/i_course_repository.dart';

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
    final cachedCourse = await _courseLocalDataSource.getCourseById(id);

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
      await _courseLocalDataSource.replaceCourseDetailSnapshot(courseDetailDto);
      return Success(
        courseDetailDto.course.toDomain().copyWith(
          coverImage: courseDetailDto.course.coverImage,
        ),
      );
    } on AppError catch (e) {
      if (cachedCourse != null && _shouldUseCachedData(e)) {
        return Success(await _buildCachedCourseModelFromEntity(cachedCourse));
      }

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
    final cachedStructure = await _buildCachedCourseStructure(courseId);

    try {
      final structure = await _remoteDataSource.getTableOfContents(courseId);
      return Success(structure.toDomain());
    } on AppError catch (e) {
      if (cachedStructure != null && _shouldUseCachedData(e)) {
        return Success(cachedStructure);
      }

      return Failure(AppFailure.fromError(e));
    } catch (e) {
      return Failure(AppFailure.fromException(e));
    }
  }

  Future<CourseModel> _buildCachedCourseModelFromEntity(
    CourseEntity course,
  ) async {
    final lessons = await _lessonLocalDataSource.getLessonsByCourseId(
      course.id,
    );
    var totalTasks = 0;

    for (final lesson in lessons) {
      totalTasks += (await _taskLocalDataSource.getTasksByLessonId(
        lesson.id,
      )).length;
    }

    return course.toDomain().copyWith(
      totalLessons: lessons.length,
      totalTasks: totalTasks,
      coverImage: course.coverImage,
    );
  }

  Future<CourseStructureModel?> _buildCachedCourseStructure(
    int courseId,
  ) async {
    final course = await _courseLocalDataSource.getCourseById(courseId);
    final modules = await _moduleLocalDataSource.getModulesByCourseId(courseId);

    if (course == null || modules.isEmpty) {
      return null;
    }

    final sortedModules = List.of(modules)
      ..sort((a, b) => a.orderIndex.compareTo(b.orderIndex));
    final moduleModels = <CourseStructureModuleModel>[];

    for (final module in sortedModules) {
      final lessons = await _lessonLocalDataSource.getLessonsByModuleId(
        module.id,
      );
      final sortedLessons = List.of(lessons)
        ..sort((a, b) => a.orderIndex.compareTo(b.orderIndex));

      moduleModels.add(
        CourseStructureModuleModel(
          id: module.id,
          title: module.title,
          description: module.description,
          orderIndex: module.orderIndex,
          lessons: sortedLessons
              .map(
                (lesson) => CourseStructureLessonModel(
                  id: lesson.id,
                  title: lesson.title,
                  orderIndex: lesson.orderIndex,
                  durationMinutes: lesson.durationMinutes,
                ),
              )
              .toList(),
        ),
      );
    }

    return CourseStructureModel(
      courseId: course.id,
      title: course.title,
      modules: moduleModels,
    );
  }

  bool _shouldUseCachedData(AppError error) => error.canRetry;
}
