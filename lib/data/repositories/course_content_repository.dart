import 'package:codium/core/error/app_error_code.dart';
import 'package:codium/core/error/failure.dart';
import 'package:codium/core/exceptions/app_error.dart';
import 'package:codium/core/utils/result.dart';
import 'package:codium/data/database/app_database.dart';
import 'package:codium/data/entities/course_entity_extension.dart';
import 'package:codium/domain/datasources/i_course_local_datasource.dart';
import 'package:codium/domain/datasources/i_lesson_local_datasource.dart';
import 'package:codium/domain/datasources/i_module_local_datasource.dart';
import 'package:codium/domain/models/course_content/course_content_model.dart';
import 'package:codium/domain/models/course_content/table_of_contents_model.dart';
import 'package:codium/domain/repositories/i_course_content_repository.dart';

class CourseContentRepository implements ICourseContentRepository {
  final ICourseLocalDataSource _courseLocalDataSource;
  final IModuleLocalDataSource _moduleLocalDataSource;
  final ILessonLocalDataSource _lessonLocalDataSource;

  const CourseContentRepository(
    this._courseLocalDataSource,
    this._moduleLocalDataSource,
    this._lessonLocalDataSource,
  );

  @override
  Future<Result<CourseContentModel>> getCourseContentById(int id) async {
    try {
      final entity = await _courseLocalDataSource.getCourseById(id);

      if (entity == null) {
        return const Failure(
          AppFailure(
            code: AppErrorCode.apiNotFound,
            message: '',
            canRetry: false,
          ),
        );
      }

      final tocResult = await _buildTableOfContents(id);
      final course = CourseContentModel.fromCourse(
        entity.toDomain(),
        tableOfContents: tocResult.tableOfContents,
        totalLessons: tocResult.totalLessons,
      );
      return Success(course);
    } on AppError catch (e) {
      return Failure(AppFailure.fromError(e));
    } catch (e) {
      return Failure(AppFailure.fromException(e));
    }
  }

  Future<TableOfContentsModel> _buildTableOfContents(int courseId) async {
    final modules = await _moduleLocalDataSource.getModulesByCourseId(courseId);
    modules.sort((a, b) => a.orderIndex.compareTo(b.orderIndex));
    final lessons = await _lessonLocalDataSource.getLessonsByCourseId(courseId);

    lessons.sort((a, b) {
      final moduleOrder = a.moduleId.compareTo(b.moduleId);
      if (moduleOrder != 0) {
        return moduleOrder;
      }
      return a.orderIndex.compareTo(b.orderIndex);
    });

    final lessonsByModule = <int, List<LessonEntity>>{};
    for (final lesson in lessons) {
      lessonsByModule.putIfAbsent(lesson.moduleId, () => []).add(lesson);
    }

    final buffer = StringBuffer();
    var totalLessons = 0;

    for (final module in modules) {
      buffer.writeln('# ${module.title}');

      final moduleLessons =
          lessonsByModule[module.id] ?? const <LessonEntity>[];
      for (final lesson in moduleLessons) {
        buffer.writeln('* ${lesson.title}');
        totalLessons += 1;
      }
    }

    return TableOfContentsModel(
      tableOfContents: buffer.toString().trimRight(),
      totalLessons: totalLessons,
    );
  }
}
