import 'package:bloc_test/bloc_test.dart';
import 'package:codium/domain/models/course/course_model.dart';
import 'package:codium/domain/models/course/course_pricing.dart';
import 'package:codium/domain/models/course/course_statistics.dart';
import 'package:codium/domain/models/course/course_structure_lesson_model.dart';
import 'package:codium/domain/models/course/course_structure_model.dart';
import 'package:codium/domain/models/course/course_structure_module_model.dart';
import 'package:codium/domain/models/user/money.dart';
import 'package:codium/features/course_details/bloc/course_detail/course_detail_bloc.dart';
import 'package:codium/features/course_details/widgets/table_of_contents_content.dart';
import 'package:codium/s.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

class _MockCourseDetailBloc
    extends MockBloc<CourseDetailEvent, CourseDetailState>
    implements CourseDetailBloc {}

void main() {
  late _MockCourseDetailBloc bloc;

  setUp(() {
    bloc = _MockCourseDetailBloc();
  });

  testWidgets('blocks lesson session navigation for users without purchase', (
    tester,
  ) async {
    final state = CourseDetailLoadSuccessState(
      course: _course,
      isPurchased: false,
      tableOfContents: _tableOfContents,
    );
    when(() => bloc.state).thenReturn(state);
    whenListen(bloc, Stream.value(state), initialState: state);

    final router = _buildRouter(bloc);

    await tester.pumpWidget(_TestApp(router: router));
    await tester.pump();

    expect(find.text('Lesson 1'), findsOneWidget);

    await tester.tap(find.text('Lesson 1'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 250));

    expect(find.text('Purchase Course'), findsOneWidget);
    expect(router.routeInformationProvider.value.uri.path, '/');
    expect(find.text('lesson-session-1'), findsNothing);
  });

  testWidgets('allows lesson session navigation for purchased users', (
    tester,
  ) async {
    final state = CourseDetailLoadSuccessState(
      course: _course,
      isPurchased: true,
      tableOfContents: _tableOfContents,
    );
    when(() => bloc.state).thenReturn(state);
    whenListen(bloc, Stream.value(state), initialState: state);

    final router = _buildRouter(bloc);

    await tester.pumpWidget(_TestApp(router: router));
    await tester.pump();

    await tester.tap(find.text('Lesson 1'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 250));

    expect(find.text('lesson-session-1'), findsOneWidget);
    expect(router.canPop(), isTrue);

    router.pop();
    await tester.pumpAndSettle();

    expect(find.text('lesson-session-1'), findsNothing);
    expect(find.text('Lesson 1'), findsOneWidget);
  });
}

GoRouter _buildRouter(CourseDetailBloc bloc) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => BlocProvider.value(
          value: bloc,
          child: const Scaffold(body: TableOfContentsContent()),
        ),
      ),
      GoRoute(
        path: '/lesson/:lessonId/tasks',
        name: 'lesson-task-session',
        builder: (context, state) {
          final lessonId = state.pathParameters['lessonId']!;
          return Scaffold(body: Text('lesson-session-$lessonId'));
        },
      ),
    ],
  );
}

class _TestApp extends StatelessWidget {
  const _TestApp({required this.router});

  final GoRouter router;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      localizationsDelegates: S.localizationDelegates,
      supportedLocales: S.supportedLocales,
    );
  }
}

final _course = CourseModel(
  id: 1,
  title: 'Course',
  description: 'Description',
  author: 'Author',
  category: 'Category',
  priceInCoins: 100,
  durationMinutes: 60,
  rating: 4.5,
  createdAt: DateTime(2026, 3, 9),
  pricing: CoursePricing(price: Money.fromInt(100)),
  statistics: const CourseStatistics(
    averageRating: 4.5,
    totalEnrollments: 10,
    completionRate: 0.5,
  ),
);

const _tableOfContents = CourseStructureModel(
  courseId: 1,
  title: 'Course',
  modules: [
    CourseStructureModuleModel(
      id: 1,
      title: 'Module 1',
      description: 'Description',
      orderIndex: 0,
      lessons: [
        CourseStructureLessonModel(
          id: 1,
          title: 'Lesson 1',
          orderIndex: 0,
          durationMinutes: 10,
        ),
      ],
    ),
  ],
);
