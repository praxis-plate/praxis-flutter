import 'package:codium/domain/enums/task_type.dart';
import 'package:codium/domain/models/task/course_task.dart';

class SimpleCourseTask extends CourseTask {
  SimpleCourseTask({
    required super.id,
    required super.title,
    required super.content,
    required super.type,
    super.estimatedTime,
  });
}

final mockTasks = List.generate(5, (index) {
  return SimpleCourseTask(
    id: 'task_$index',
    title: 'Задание ${index + 1}',
    content: 'Контент задания ${index + 1}',
    type: TaskType.values[index % TaskType.values.length],
    estimatedTime: Duration(minutes: 5 + index * 5),
  );
});
