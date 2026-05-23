import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:praxis/features/lesson/bloc/bloc.dart';
import 'package:praxis/s.dart';

class LessonCompletionDialog extends StatelessWidget {
  const LessonCompletionDialog({super.key, required this.state});

  final LessonContentCompleted state;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);

    return AlertDialog(
      title: Text(s.lessonCompleted),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle, size: 64, color: theme.colorScheme.primary),
          const SizedBox(height: 16),
          Text(s.coinsEarned(state.coinsEarned)),
          if (state.achievements.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(s.achievementUnlocked),
            ...state.achievements.map((achievement) => Text(achievement.title)),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            context.pop();
            context.pop();
          },
          child: Text(s.ok),
        ),
      ],
    );
  }
}
