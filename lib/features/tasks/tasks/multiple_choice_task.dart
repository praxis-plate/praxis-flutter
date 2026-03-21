import 'package:codium/domain/models/task/task_models.dart';
import 'package:codium/features/tasks/bloc/bloc.dart';
import 'package:codium/features/tasks/bloc/task/task_bloc.dart';
import 'package:codium/features/tasks/widgets/task_view_layout.dart';
import 'package:codium/features/tasks/widgets/submit_task_button.dart';
import 'package:codium/features/tasks/widgets/task_hint_button.dart';
import 'package:codium/s.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MultipleChoiceTask extends StatefulWidget {
  final MultipleChoiceTaskModel task;

  const MultipleChoiceTask({super.key, required this.task});

  @override
  State<MultipleChoiceTask> createState() => _MultipleChoiceTaskState();
}

class _MultipleChoiceTaskState extends State<MultipleChoiceTask> {
  String? _selectedOption;

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
            s.taskSelectOption,
            style: theme.textTheme.titleMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.85),
            ),
          ),
          const SizedBox(height: 12),
          ...widget.task.options.asMap().entries.map((entry) {
            final index = entry.key;
            final option = entry.value;
            final isSelected = _selectedOption == option;

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: InkWell(
                onTap: () {
                  setState(() {
                    _selectedOption = option;
                  });
                },
                borderRadius: BorderRadius.circular(12),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? theme.colorScheme.primary.withValues(alpha: 0.08)
                        : theme.cardColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? theme.colorScheme.primary
                          : theme.dividerColor.withValues(alpha: 0.6),
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
                          color: theme.colorScheme.surface,
                          border: Border.all(
                            color: isSelected
                                ? theme.colorScheme.primary
                                : theme.dividerColor.withValues(alpha: 0.6),
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            String.fromCharCode(65 + index),
                            style: theme.textTheme.titleSmall?.copyWith(
                              color: isSelected
                                  ? theme.colorScheme.primary
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
                            color: isSelected
                                ? theme.colorScheme.primary
                                : theme.colorScheme.onSurface,
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
            onPressed: _selectedOption != null
                ? () {
                    context.read<TaskBloc>().add(
                      SubmitAnswerEvent(_selectedOption!),
                    );
                  }
                : null,
          ),
        ],
      ),
    );
  }
}
