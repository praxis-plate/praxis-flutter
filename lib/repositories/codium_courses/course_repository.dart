import 'package:codium/repositories/codium_courses/abstract_course_repository.dart';
import 'package:codium/repositories/codium_courses/models/course.dart';

class CourseRepository implements ICourseRepository {
  @override
  Future<List<Course>> getCourses() async {
    return [
      Course(
        title: 'Курс с вложенными задачами',
        previewDescription: 'Курс с задачами и подзадачами',
        imagePath: 'https://example.com/image.png',
        author: 'Автор курса',
        taskNodes: [
          TaskNode(
            task: Theory(
              title: 'Урок 1: Введение',
              textInMarkdown: '# Введение\nЭто теория.',
            ),
            subTasks: [
              TaskNode(
                task: Practice(
                  title: 'Практика 1.1: Первое задание',
                  textInMarkdown: '- Сделайте это\n- Потом это',
                ),
                subTasks: [
                  TaskNode(
                    task: Theory(
                      title: 'Урок 1.1.1: Детализация',
                      textInMarkdown: '## Детализация\nОписание.',
                    ),
                  ),
                ],
              ),
            ],
          ),
          TaskNode(
            task: Practice(
              title: 'Практика 2: Второе задание',
              textInMarkdown: 'Практическое задание 2.',
            ),
          ),
        ],
        price: 1999,
        duration: const Duration(hours: 10),
        ratingScores: 5,
      ),
    ];
  }

  @override
  Future<Course> getCourse(String courseId) async {
    final courses = await getCourses();
    return courses.first;
  }
}
