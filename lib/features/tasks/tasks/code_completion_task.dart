import 'package:codium/core/widgets/widgets.dart';
import 'package:codium/domain/models/task/task_models.dart';
import 'package:codium/features/tasks/bloc/bloc.dart';
import 'package:codium/features/tasks/bloc/task/task_bloc.dart';
import 'package:codium/features/tasks/widgets/submit_task_button.dart';
import 'package:codium/features/tasks/widgets/task_hint_button.dart';
import 'package:codium/features/tasks/widgets/task_view_layout.dart';
import 'package:codium/s.dart';
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
          GlassCard(
            borderRadius: BorderRadius.circular(12),
            padding: const EdgeInsets.all(16),
            child: _buildCodeWithInputs(theme),
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

  Widget _buildCodeWithInputs(ThemeData theme) {
    final widgets = <Widget>[];

    for (int i = 0; i < _codeParts.length; i++) {
      if (_codeParts[i].isNotEmpty) {
        widgets.add(
          SelectableText(
            _codeParts[i],
            style: theme.textTheme.bodyMedium?.copyWith(
              fontFamily: 'monospace',
              fontSize: 14,
              height: 1.5,
              color: theme.colorScheme.onSurface,
            ),
          ),
        );
      }

      if (i < _inputControllers.length) {
        widgets.add(
          IntrinsicWidth(
            child: GlassTextField(
              borderRadius: BorderRadius.circular(8),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: TextField(
                controller: _inputControllers[i],
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontFamily: 'monospace',
                  fontSize: 14,
                  height: 1.5,
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
                decoration: InputDecoration(
                  constraints: const BoxConstraints(minWidth: 100),
                  hintText: '...',
                  hintStyle: theme.textTheme.bodyMedium?.copyWith(
                    fontFamily: 'monospace',
                    fontSize: 14,
                    color: theme.colorScheme.onSurfaceVariant.withValues(
                      alpha: 0.5,
                    ),
                  ),
                  isDense: true,
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
        );
      }
    }

    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: widgets,
    );
  }
}
