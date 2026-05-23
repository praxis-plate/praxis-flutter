import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:praxis/features/lesson/bloc/bloc.dart';
import 'package:praxis/features/lesson/widgets/lesson_content_view.dart';

class LessonContentScreen extends StatelessWidget {
  const LessonContentScreen({
    super.key,
    required this.lessonId,
    required this.courseId,
  });

  final String lessonId;
  final String courseId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.I<LessonContentBloc>()
        ..add(
          LoadLessonContent(lessonId: lessonId, userId: '', courseId: courseId),
        ),
      child: LessonContentView(lessonId: lessonId, courseId: courseId),
    );
  }
}
