import 'package:codium/core/utils/result.dart';
import 'package:codium/domain/models/lesson/lesson_model.dart';
import 'package:codium/domain/usecases/tasks/get_task_count_by_lesson_id_usecase.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

class LessonCard extends StatefulWidget {
  final LessonModel lesson;

  const LessonCard({super.key, required this.lesson});

  @override
  State<LessonCard> createState() => _LessonCardState();
}

class _LessonCardState extends State<LessonCard> {
  int? _taskCount;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadTaskCount();
  }

  Future<void> _loadTaskCount() async {
    final useCase = GetIt.I<GetTaskCountByLessonIdUseCase>();
    final result = await useCase(widget.lesson.id);

    if (!mounted) return;

    if (result.isSuccess) {
      setState(() {
        _taskCount = result.dataOrNull!;
        _isLoading = false;
      });
    } else {
      setState(() {
        _error = result.failureOrNull!.message;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: ListTile(
        leading: Icon(
          Icons.play_circle_outline,
          color: theme.colorScheme.primary,
        ),
        title: Text(widget.lesson.title),
        subtitle: _buildSubtitle(theme),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          context.pushNamed(
            'lesson-task-session',
            pathParameters: {'lessonId': widget.lesson.id.toString()},
          );
        },
      ),
    );
  }

  Widget _buildSubtitle(ThemeData theme) {
    if (_isLoading) {
      return const SizedBox(
        height: 16,
        width: 16,
        child: CircularProgressIndicator(strokeWidth: 2),
      );
    }

    if (_error != null) {
      return Text(
        '${widget.lesson.durationMinutes} min',
        style: theme.textTheme.bodySmall,
      );
    }

    return Text(
      '${widget.lesson.durationMinutes} min • $_taskCount tasks',
      style: theme.textTheme.bodySmall,
    );
  }
}
