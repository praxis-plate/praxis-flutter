import 'package:codium/data/database/app_database.dart';
import 'package:codium/data/seed/course_seed_data.dart';
import 'package:codium/data/seed/dart_tasks_seed_data.dart';
import 'package:codium/data/seed/javascript_tasks_seed_data.dart';
import 'package:codium/data/seed/lesson_seed_data.dart';
import 'package:codium/data/seed/module_seed_data.dart';
import 'package:codium/data/seed/python_tasks_seed_data.dart';
import 'package:codium/data/seed/task_seed_data.dart';
import 'package:get_it/get_it.dart';

class TaskDatabaseSeeder {
  final AppDatabase _db;

  TaskDatabaseSeeder(this._db);

  Future<void> seedDatabase() async {
    final hasData = await _checkIfDataExists();
    if (hasData) {
      return;
    }

    await _seedCourses();
  }

  Future<bool> _checkIfDataExists() async {
    final courses = await _db.managers.course.get();
    return courses.isNotEmpty;
  }

  Future<void> _seedCourses() async {
    final courses = CourseSeedData.getCourses();

    for (final courseCompanion in courses) {
      final courseId = await _db.managers.course.create((o) => courseCompanion);

      final courseEntity = await _db.managers.course
          .filter((f) => f.id(courseId))
          .getSingle();
      await _seedModulesForCourse(courseEntity.id, courseEntity.title);
    }
  }

  Future<void> _seedModulesForCourse(int courseId, String courseTitle) async {
    final modules = ModuleSeedData.getModulesForCourse(courseId, courseTitle);

    for (final moduleCompanion in modules) {
      final moduleId = await _db.managers.module.create((o) => moduleCompanion);

      final moduleEntity = await _db.managers.module
          .filter((f) => f.id(moduleId))
          .getSingle();
      await _seedLessonsForModule(moduleEntity.id, moduleEntity.title);
    }
  }

  Future<void> _seedLessonsForModule(int moduleId, String moduleTitle) async {
    final lessons = LessonSeedData.getLessonsForModule(moduleId, moduleTitle);

    for (final lessonCompanion in lessons) {
      final lessonId = await _db.managers.lesson.create((o) => lessonCompanion);

      final lessonEntity = await _db.managers.lesson
          .filter((f) => f.id(lessonId))
          .getSingle();
      await _seedTasksForLesson(
        lessonEntity.id,
        lessonEntity.title,
        moduleTitle,
      );
    }
  }

  Future<void> _seedTasksForLesson(
    int lessonId,
    String lessonTitle,
    String moduleTitle,
  ) async {
    final tasks = TaskSeedData.getTasksForLesson(
      lessonId,
      lessonTitle,
      moduleTitle,
    );

    for (final taskCompanion in tasks) {
      await _db.managers.task.create((o) => taskCompanion);
    }

    await _seedLanguageSpecificTasks(lessonId, moduleTitle);
  }

  Future<void> _seedLanguageSpecificTasks(
    int lessonId,
    String moduleTitle,
  ) async {
    final topic = moduleTitle.toLowerCase().replaceAll(' ', '_');

    final dartTasks = DartTasksSeedData.getDartSpecificTasks(lessonId, topic);
    for (final taskCompanion in dartTasks) {
      await _db.managers.task.create((o) => taskCompanion);
    }

    final pythonTasks = PythonTasksSeedData.getPythonSpecificTasks(
      lessonId,
      topic,
    );
    for (final taskCompanion in pythonTasks) {
      await _db.managers.task.create((o) => taskCompanion);
    }

    final jsTasks = JavaScriptTasksSeedData.getJavaScriptSpecificTasks(
      lessonId,
      topic,
    );
    for (final taskCompanion in jsTasks) {
      await _db.managers.task.create((o) => taskCompanion);
    }
  }
}

Future<void> seedTasksIfNeeded() async {
  final db = GetIt.I<AppDatabase>();
  final seeder = TaskDatabaseSeeder(db);
  await seeder.seedDatabase();
}
