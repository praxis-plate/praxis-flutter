import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:praxis/domain/enums/task_type.dart';
import 'package:praxis/domain/models/task/task_models.dart';
import 'package:praxis/features/tasks/bloc/task/task_bloc.dart';
import 'package:praxis/features/tasks/bloc/task_hint/task_hint_cubit.dart';
import 'package:praxis/features/tasks/tasks/multiple_choice_task.dart';
import 'package:praxis/s.dart';

class _MockTaskBloc extends MockBloc<TaskEvent, TaskState>
    implements TaskBloc {}

class _MockTaskHintCubit extends MockCubit<TaskHintState>
    implements TaskHintCubit {}

void main() {
  late _MockTaskBloc bloc;
  late _MockTaskHintCubit hintCubit;

  setUp(() {
    bloc = _MockTaskBloc();
    hintCubit = _MockTaskHintCubit();
  });

  testWidgets('submits multiple-answer selections as a JSON array', (
    tester,
  ) async {
    when(() => bloc.state).thenReturn(TaskLoadedState(task: _task));
    when(() => hintCubit.state).thenReturn(const TaskHintInitial());
    whenListen(
      hintCubit,
      Stream.value(const TaskHintInitial()),
      initialState: const TaskHintInitial(),
    );

    await tester.pumpWidget(_TestApp(bloc: bloc, hintCubit: hintCubit));
    await tester.pump();

    await tester.tap(find.text('Map'));
    await tester.tap(find.text('List'));
    await tester.pump();
    await tester.tap(find.text('Submit Answer'));

    verify(() => bloc.add(const SubmitAnswerEvent('["List","Map"]'))).called(1);
  });
}

class _TestApp extends StatelessWidget {
  const _TestApp({required this.bloc, required this.hintCubit});

  final TaskBloc bloc;
  final TaskHintCubit hintCubit;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: S.localizationDelegates,
      supportedLocales: S.supportedLocales,
      home: MultiBlocProvider(
        providers: [
          BlocProvider.value(value: bloc),
          BlocProvider.value(value: hintCubit),
        ],
        child: Scaffold(body: MultipleChoiceTask(task: _task)),
      ),
    );
  }
}

final _task = MultipleChoiceTaskModel(
  id: 1,
  lessonId: 2,
  questionText: 'Select collection types',
  correctAnswer: '["List","Map"]',
  options: const ['List', 'Map', 'Class'],
  taskTypeValue: TaskType.multipleAnswer,
  difficultyLevel: 1,
  xpValue: 10,
  orderIndex: 0,
  topic: 'collections',
  createdAt: DateTime(2026, 5, 22),
);
