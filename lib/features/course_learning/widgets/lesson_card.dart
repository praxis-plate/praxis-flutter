import 'package:codium/core/utils/result.dart';
import 'package:codium/domain/models/lesson/lesson_model.dart';
import 'package:codium/domain/usecases/tasks/get_task_count_by_lesson_id_usecase.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LessonCard extends StatelessWidget {
  final LessonModel lesson;
  final GetTaskCountByLessonIdUseCase getTaskCountUseCase;

  const LessonCard({
    super.key,
    required this.lesson,
    required this.getTaskCountUseCase,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: ListTile(
        leading: Icon(
          Icons.play_circle_outline,
          color: theme.colorScheme.primary,
        ),
        title: Text(lesson.title),
        subtitle: _TaskCountSubtitle(
          lessonId: lesson.id,
          durationMinutes: lesson.durationMinutes,
          getTaskCountUseCase: getTaskCountUseCase,
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          context.pushNamed(
            'lesson-task-session',
            pathParameters: {'lessonId': lesson.id.toString()},
          );
        },
      ),
    );
  }
}

class _TaskCountSubtitle extends StatefulWidget {
  final int lessonId;
  final int durationMinutes;
  final GetTaskCountByLessonIdUseCase getTaskCountUseCase;

  const _TaskCountSubtitle({
    required this.lessonId,
    required this.durationMinutes,
    required this.getTaskCountUseCase,
  });

  @override
  State<_TaskCountSubtitle> createState() => _TaskCountSubtitleState();
}

class _TaskCountSubtitleState extends State<_TaskCountSubtitle> {
  int? _taskCount;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTaskCount();
  }

  Future<void> _loadTaskCount() async {
    final result = await widget.getTaskCountUseCase(widget.lessonId);

    if (!mounted) return;

    setState(() {
      _taskCount = result.dataOrNull;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_isLoading) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${widget.durationMinutes} min',
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(width: 8),
          const SizedBox(
            height: 12,
            width: 12,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ],
      );
    }

    final taskCountText = _taskCount != null ? ' • $_taskCount tasks' : '';
    return Text(
      '${widget.durationMinutes} min$taskCountText',
      style: theme.textTheme.bodySmall,
    );
  }
}
