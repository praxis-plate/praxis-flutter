import 'package:codium/core/widgets/common/glass_card.dart';
import 'package:codium/features/tasks/bloc/task_hint/task_hint_cubit.dart';
import 'package:codium/s.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TaskHintButton extends StatefulWidget {
  final int taskId;
  final int maxHints;

  const TaskHintButton({super.key, required this.taskId, this.maxHints = 3});

  @override
  State<TaskHintButton> createState() => _TaskHintButtonState();
}

class _TaskHintButtonState extends State<TaskHintButton> {
  int _hintsUsed = 0;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);
    final hintsRemaining = widget.maxHints - _hintsUsed;

    return BlocListener<TaskHintCubit, TaskHintState>(
      listener: (context, state) {
        if (state is TaskHintLoaded) {
          setState(() {
            _hintsUsed++;
          });
          _showHintDialog(context, state.hint);
        } else if (state is TaskHintError) {
          _showErrorDialog(context, state.message);
        }
      },
      child: BlocBuilder<TaskHintCubit, TaskHintState>(
        builder: (context, state) {
          final isLoading = state is TaskHintLoading;
          final canRequestHint = hintsRemaining > 0 && !isLoading;

          return SizedBox(
            height: 48,
            child: GlassCard(
              borderRadius: BorderRadius.circular(12),
              padding: EdgeInsets.zero,
              enabled: canRequestHint,
              borderColor: canRequestHint
                  ? theme.colorScheme.primary.withValues(alpha: 0.5)
                  : theme.colorScheme.outline.withValues(alpha: 0.3),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: canRequestHint
                      ? () {
                          context
                              .read<TaskHintCubit>()
                              .requestHint(widget.taskId);
                        }
                      : null,
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Center(
                      child: isLoading
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: theme.colorScheme.primary,
                              ),
                            )
                          : Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.lightbulb_outline,
                                  size: 20,
                                  color: canRequestHint
                                      ? theme.colorScheme.primary
                                      : theme.colorScheme.onSurfaceVariant,
                                ),
                                const SizedBox(width: 8),
                                Flexible(
                                  child: Text(
                                    '${s.taskHintButton} ($hintsRemaining/${widget.maxHints})',
                                    style: theme.textTheme.labelLarge?.copyWith(
                                      color: canRequestHint
                                          ? theme.colorScheme.primary
                                          : theme.colorScheme.onSurfaceVariant,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showHintDialog(BuildContext context, String hint) {
    final s = S.of(context);
    final theme = Theme.of(context);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.lightbulb, color: theme.colorScheme.primary),
            const SizedBox(width: 8),
            Text(
              s.taskHintTitle,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  hint,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 16,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        s.taskHintPenalty,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.read<TaskHintCubit>().reset();
            },
            child: Text(s.ok),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    final s = S.of(context);
    final theme = Theme.of(context);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.error_outline, color: theme.colorScheme.error),
            const SizedBox(width: 8),
            Text(
              s.taskError,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.error,
              ),
            ),
          ],
        ),
        content: Text(message, style: theme.textTheme.bodyLarge),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.read<TaskHintCubit>().reset();
            },
            child: Text(s.ok),
          ),
        ],
      ),
    );
  }
}
