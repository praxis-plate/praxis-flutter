import 'package:codium/core/widgets/widgets.dart';
import 'package:codium/domain/models/task/task_models.dart';
import 'package:codium/features/features.dart';
import 'package:codium/s.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TextInputTask extends StatefulWidget {
  final TextInputTaskModel task;

  const TextInputTask({super.key, required this.task});

  @override
  State<TextInputTask> createState() => _TextInputTaskState();
}

class _TextInputTaskState extends State<TextInputTask> {
  late final TextEditingController _answerController;

  @override
  void initState() {
    super.initState();
    _answerController = TextEditingController();
    _answerController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);

    return TaskViewLayout(
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            widget.task.questionText,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          GlassTextField(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: _answerController,
              style: theme.textTheme.bodyLarge,
              decoration: InputDecoration(
                hintText: s.taskEnterAnswer,
                hintStyle: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant.withValues(
                    alpha: 0.5,
                  ),
                ),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
      footer: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TaskHintButton(taskId: widget.task.id),
          const SizedBox(height: 12),
          SubmitTaskButton(
            label: s.taskSubmitButton,
            onPressed: _answerController.text.trim().isNotEmpty
                ? () {
                    context.read<TaskBloc>().add(
                      SubmitAnswerEvent(_answerController.text.trim()),
                    );
                  }
                : null,
          ),
        ],
      ),
    );
  }
}
