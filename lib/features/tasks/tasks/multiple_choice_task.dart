import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:praxis/domain/enums/task_type.dart';
import 'package:praxis/domain/models/task/task_models.dart';
import 'package:praxis/features/tasks/bloc/bloc.dart';
import 'package:praxis/features/tasks/bloc/task/task_bloc.dart';
import 'package:praxis/features/tasks/widgets/submit_task_button.dart';
import 'package:praxis/features/tasks/widgets/task_hint_button.dart';
import 'package:praxis/features/tasks/widgets/task_view_layout.dart';
import 'package:praxis/s.dart';

class MultipleChoiceTask extends StatefulWidget {
  final MultipleChoiceTaskModel task;

  const MultipleChoiceTask({super.key, required this.task});

  @override
  State<MultipleChoiceTask> createState() => _MultipleChoiceTaskState();
}

class _MultipleChoiceTaskState extends State<MultipleChoiceTask> {
  String? _selectedOption;
  final Set<String> _selectedOptions = {};

  bool get _isMultipleAnswer => widget.task.taskType == TaskType.multipleAnswer;

  bool _isSelected(String option) {
    if (_isMultipleAnswer) {
      return _selectedOptions.contains(option);
    }

    return _selectedOption == option;
  }

  void _selectOption(String option) {
    setState(() {
      if (_isMultipleAnswer) {
        if (!_selectedOptions.add(option)) {
          _selectedOptions.remove(option);
        }
        return;
      }

      _selectedOption = option;
    });
  }

  String _buildAnswer() {
    if (!_isMultipleAnswer) {
      return _selectedOption!;
    }

    final orderedOptions = widget.task.options
        .where(_selectedOptions.contains)
        .toList();
    return jsonEncode(orderedOptions);
  }

  bool get _canSubmit {
    if (_isMultipleAnswer) {
      return _selectedOptions.isNotEmpty;
    }

    return _selectedOption != null;
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
          Text(
            _isMultipleAnswer ? s.taskSelectOptions : s.taskSelectOption,
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          ...widget.task.options.asMap().entries.map((entry) {
            final index = entry.key;
            final option = entry.value;
            final isSelected = _isSelected(option);
            final selectedColor = theme.colorScheme.primary;
            final selectedBackgroundColor = Color.alphaBlend(
              selectedColor.withValues(alpha: 0.08),
              theme.cardColor,
            );
            final unselectedBorderColor = theme.dividerColor.withValues(
              alpha: 0.6,
            );

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: InkWell(
                onTap: () => _selectOption(option),
                borderRadius: BorderRadius.circular(12),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? selectedBackgroundColor
                        : theme.cardColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? selectedColor : unselectedBorderColor,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelected
                              ? selectedColor.withValues(alpha: 0.12)
                              : theme.colorScheme.surface,
                          border: Border.all(
                            color: isSelected
                                ? selectedColor
                                : unselectedBorderColor,
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            String.fromCharCode(65 + index),
                            style: theme.textTheme.titleSmall?.copyWith(
                              color: isSelected
                                  ? selectedColor
                                  : theme.colorScheme.onSurface,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          option,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
      footer: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TaskHintButton(taskId: widget.task.id),
          const SizedBox(height: 12),
          SubmitTaskButton(
            label: s.taskSubmitButton,
            onPressed: _canSubmit
                ? () {
                    context.read<TaskBloc>().add(
                      SubmitAnswerEvent(_buildAnswer()),
                    );
                  }
                : null,
          ),
        ],
      ),
    );
  }
}
