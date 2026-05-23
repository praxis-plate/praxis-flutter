import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:praxis/core/utils/duration.dart';
import 'package:praxis/core/widgets/widgets.dart';
import 'package:praxis/features/tasks/bloc/bloc.dart';
import 'package:praxis/features/tasks/widgets/widgets.dart';
import 'package:praxis/s.dart';

Future<void> showTaskSessionSummaryDialog({
  required BuildContext context,
  required SessionCompletedState sessionState,
  required LessonTaskSessionBloc sessionBloc,
  required VoidCallback onFinish,
}) {
  final s = S.of(context);
  final theme = Theme.of(context);

  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) => Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.zero,
      child: SizedBox.expand(
        child: Stack(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: SurfaceCard(
                  borderRadius: BorderRadius.circular(20),
                  padding: const EdgeInsets.all(20),
                  borderColor: theme.colorScheme.primary.withValues(
                    alpha: 0.24,
                  ),
                  backgroundColor: Color.alphaBlend(
                    theme.colorScheme.primary.withValues(alpha: 0.04),
                    theme.colorScheme.surfaceContainerHighest,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              dialogContext.pop();
                              onFinish();
                            },
                            icon: const Icon(Icons.arrow_back_ios),
                            visualDensity: VisualDensity.compact,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            Icons.celebration,
                            color: theme.colorScheme.primary,
                            size: 32,
                          ),
                          const SizedBox(width: 12),
                          Expanded(child: Text(s.taskSessionCompleteTitle)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        s.taskSessionCompleteMessage,
                        style: theme.textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 20),
                      SummaryRow(
                        icon: Icons.emoji_events,
                        label: s.taskSessionTotalXp,
                        value: '${sessionState.totalXpEarned} XP',
                        theme: theme,
                      ),
                      const SizedBox(height: 12),
                      SummaryRow(
                        icon: Icons.check_circle,
                        label: s.taskSessionAccuracy,
                        value:
                            '${sessionState.accuracyPercentage.toStringAsFixed(1)}%',
                        theme: theme,
                      ),
                      const SizedBox(height: 12),
                      SummaryRow(
                        icon: Icons.timer,
                        label: s.taskSessionTimeSpent,
                        value: DurationFormatter.formatSeconds(
                          sessionState.timeSpentSeconds,
                          s,
                        ),
                        theme: theme,
                      ),
                      const SizedBox(height: 12),
                      SummaryRow(
                        icon: Icons.task_alt,
                        label: s.taskSessionTasksCompleted,
                        value:
                            '${sessionState.correctTasks}/${sessionState.totalTasks}',
                        theme: theme,
                      ),
                      const SizedBox(height: 20),
                      Align(
                        alignment: Alignment.centerRight,
                        child:
                            BlocBuilder<
                              LessonTaskSessionBloc,
                              LessonTaskSessionState
                            >(
                              bloc: sessionBloc,
                              builder: (context, currentState) {
                                final isPersisting =
                                    currentState is SessionCompletedState &&
                                    currentState.isPersisting;

                                return ElevatedButton(
                                  onPressed: isPersisting
                                      ? null
                                      : () {
                                          dialogContext.pop();
                                          onFinish();
                                        },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: theme.colorScheme.primary,
                                    foregroundColor:
                                        theme.colorScheme.onPrimary,
                                  ),
                                  child: isPersisting
                                      ? SizedBox(
                                          width: 18,
                                          height: 18,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: theme.colorScheme.onSurface,
                                          ),
                                        )
                                      : Text(s.done),
                                );
                              },
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
