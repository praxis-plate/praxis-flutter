import 'package:codium/domain/models/course/course.dart';
import 'package:codium/domain/models/course/course_module.dart';
import 'package:codium/domain/models/course/course_pricing.dart';
import 'package:codium/mocs/data/mock_course_tasks.dart';
import 'package:codium/mocs/data/mock_user.dart';

final mockCourses = List.generate(5, (i) {
  final tasks = mockTasks;

  final module = CourseModule(
    title: 'Модуль $i',
    description: 'Описание модуля $i',
    tasks: tasks,
    duration: Duration(minutes: tasks.length * 10),
  );

  return Course(
    id: 'course_$i',
    title: 'Курс $i',
    previewDescription: 'Превью текст $i',
    description: 'Полное описание курса $i',
    coverImage: '',
    author: mockUser,
    modules: [module],
    pricing: CoursePricing.free(),
    tasks: tasks,
  );
});
