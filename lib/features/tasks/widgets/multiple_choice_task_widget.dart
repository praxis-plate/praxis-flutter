import 'package:codium/domain/models/task/task_models.dart';
import 'package:codium/features/tasks/bloc/bloc.dart';
import 'package:codium/features/tasks/bloc/task/task_bloc.dart';
import 'package:codium/features/tasks/widgets/task_hint_button.dart';
import 'package:codium/s.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MultipleChoiceTaskWidget extends StatefulWidget {
  final MultipleChoiceTaskModel task;

  const MultipleChoiceTaskWidget({super.key, required this.task});

  @override
  State<MultipleChoiceTaskWidget> createState() =>
      _MultipleChoiceTaskWidgetState();
}

class _MultipleChoiceTaskWidgetState extends State<MultipleChoiceTaskWidget> {
  String? _selectedOption;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
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
              color: theme.colorScheme.onSurfaceVariant,
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
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? theme.colorScheme.primaryContainer
                        : theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? theme.colorScheme.primary
                          : theme.colorScheme.outline.withValues(alpha: 0.3),
                      width: isSelected ? 2 : 1,
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
                              ? theme.colorScheme.surface
                              : theme.colorScheme.surface,
                          border: Border.all(
                            color: isSelected
                                ? theme.colorScheme.primary
                                : theme.colorScheme.outline,
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
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: isSelected
                                ? theme.colorScheme.onPrimaryContainer
                                : theme.colorScheme.onSurface,
                          ),
                        ),
                      ),
                      if (isSelected)
                        Icon(
                          Icons.check_circle,
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
                    ],
                  ),
                ),
              ),
            );
          }),
          const SizedBox(height: 24),
          TaskHintButton(taskId: widget.task.id),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: _selectedOption != null
                ? () {
                    context.read<TaskBloc>().add(
                      SubmitAnswerEvent(_selectedOption!),
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
            ),
            child: Text(
              s.taskSubmitButton,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: _selectedOption != null
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
}
