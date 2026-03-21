import 'package:praxis/domain/models/task/task_models.dart';
import 'package:praxis/features/tasks/bloc/bloc.dart';
import 'package:praxis/features/tasks/bloc/task/task_bloc.dart';
import 'package:praxis/features/tasks/widgets/widgets.dart';
import 'package:praxis/s.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CodeCompletionTask extends StatefulWidget {
  final CodeCompletionTaskModel task;

  const CodeCompletionTask({super.key, required this.task});

  @override
  State<CodeCompletionTask> createState() => _CodeCompletionTaskState();
}

class _CodeCompletionTaskState extends State<CodeCompletionTask> {
  late final List<TextEditingController> _inputControllers;
  late final List<String> _codeParts;
  late final int _placeholderCount;

  @override
  void initState() {
    super.initState();
    _parseCodeTemplate();
  }

  void _parseCodeTemplate() {
    final template = widget.task.codeTemplate;
    _codeParts = template.split('___');
    _placeholderCount = _codeParts.length - 1;
    _inputControllers = List.generate(
      _placeholderCount,
      (_) => TextEditingController(),
    );

    for (final controller in _inputControllers) {
      controller.addListener(() {
        setState(() {});
      });
    }
  }

  @override
  void dispose() {
    for (final controller in _inputControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  String _getUserAnswer() {
    final buffer = StringBuffer();
    for (int i = 0; i < _codeParts.length; i++) {
      buffer.write(_codeParts[i]);
      if (i < _inputControllers.length) {
        buffer.write(_inputControllers[i].text.trim());
      }
    }
    return buffer.toString().trim();
  }

  bool _isAnswerComplete() {
    return _inputControllers.every((c) => c.text.trim().isNotEmpty);
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
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: Chip(
              label: Text(
                widget.task.language.name.toUpperCase(),
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              color: WidgetStatePropertyAll(theme.colorScheme.primary),
              side: BorderSide.none,
            ),
          ),
          const SizedBox(height: 4),
          CodeCompletionInputCard(
            codeParts: _codeParts,
            inputControllers: _inputControllers,
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
            onPressed: _isAnswerComplete()
                ? () {
                    context.read<TaskBloc>().add(
                      SubmitAnswerEvent(_getUserAnswer()),
                    );
                  }
                : null,
          ),
        ],
      ),
    );
  }

}
