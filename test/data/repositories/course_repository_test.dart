import 'package:codium/core/exceptions/app_exception.dart';
import 'package:codium/data/repositories/course_repository.dart';
import 'package:codium/domain/datasources/abstract_course_datasource.dart';
import 'package:codium/mocs/data/mock_courses.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'course_repository_test.mocks.dart';

@GenerateMocks([ICourseDataSource])
void main() {
  late CourseRepository repository;
  late MockICourseDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockICourseDataSource();
    repository = CourseRepository(mockDataSource);
  });

  group('CourseRepository', () {
    group('getCourses', () {
      test('should return list of courses from datasource', () async {
        when(
          mockDataSource.fetchCourses(any),
        ).thenAnswer((_) async => mockCourses);

        final result = await repository.getCourses();

        expect(result, mockCourses);
        verify(mockDataSource.fetchCourses(10)).called(1);
      });

      test('should throw ApiError when datasource fails', () async {
        when(
          mockDataSource.fetchCourses(any),
        ).thenThrow(Exception('Network error'));

        expect(() => repository.getCourses(), throwsA(isA<ApiError>()));
      });
    });

    group('getCourseById', () {
      test('should return course from datasource', () async {
        final course = mockCourses.first;
        when(
          mockDataSource.fetchCourseById(any),
        ).thenAnswer((_) async => course);

        final result = await repository.getCourseById(course.id);

        expect(result, course);
        verify(mockDataSource.fetchCourseById(course.id)).called(1);
      });

      test('should throw ApiError when course not found', () async {
        when(
          mockDataSource.fetchCourseById(any),
        ).thenThrow(Exception('Course not found'));

        expect(
          () => repository.getCourseById('invalid_id'),
          throwsA(isA<ApiError>()),
        );
      });
    });
  });
}
