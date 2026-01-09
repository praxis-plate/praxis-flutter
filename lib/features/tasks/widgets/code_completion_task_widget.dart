import 'package:codium/domain/models/task/task_models.dart';
import 'package:codium/features/tasks/bloc/bloc.dart';
import 'package:codium/features/tasks/bloc/task/task_bloc.dart';
import 'package:codium/features/tasks/widgets/task_hint_button.dart';
import 'package:codium/s.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CodeCompletionTaskWidget extends StatefulWidget {
  final CodeCompletionTaskModel task;

  const CodeCompletionTaskWidget({super.key, required this.task});

  @override
  State<CodeCompletionTaskWidget> createState() =>
      _CodeCompletionTaskWidgetState();
}

class _CodeCompletionTaskWidgetState extends State<CodeCompletionTaskWidget> {
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
    if (_inputControllers.length == 1) {
      return _inputControllers[0].text.trim();
    }
    return _inputControllers.map((c) => c.text.trim()).join(', ');
  }

  bool _isAnswerComplete() {
    return _inputControllers.every((c) => c.text.trim().isNotEmpty);
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    widget.task.questionText,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Chip(
                    label: Text(
                      widget.task.language.name.toUpperCase(),
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    backgroundColor: theme.colorScheme.secondaryContainer,
                    side: BorderSide.none,
                  ),
                  const SizedBox(height: 24),
                  Container(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: theme.colorScheme.outline.withValues(alpha: 0.3),
                      ),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: _buildCodeWithInputs(theme),
                  ),
                ],
              ),
            ),
          ),
          TaskHintButton(taskId: widget.task.id),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: _isAnswerComplete()
                ? () {
                    context.read<TaskBloc>().add(
                      SubmitAnswerEvent(_getUserAnswer()),
                    );
                  }
                : null,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
              disabledBackgroundColor:
                  theme.colorScheme.surfaceContainerHighest,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              minimumSize: const Size(double.infinity, 0),
            ),
            child: Text(
              s.taskSubmitButton,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: _isAnswerComplete()
                    ? theme.colorScheme.onPrimary
                    : theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
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
                filled: true,
                fillColor: theme.colorScheme.surface,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                isDense: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide: BorderSide(
                    color: theme.colorScheme.primary.withValues(alpha: 0.5),
                    width: 2,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide: BorderSide(
                    color: theme.colorScheme.primary.withValues(alpha: 0.5),
                    width: 2,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide: BorderSide(
                    color: theme.colorScheme.primary,
                    width: 2,
                  ),
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
