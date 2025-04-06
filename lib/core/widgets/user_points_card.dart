import 'package:codium/domain/models/user_statistics.dart';
import 'package:codium/s.dart';
import 'package:flutter/material.dart';

class UserPointsCard extends StatelessWidget {
  const UserPointsCard({
    required this.userStatistics,
    super.key,
  });

  final UserStatistics userStatistics;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          children: [
            Text(
              S.of(context).yourBalance,
              style: theme.textTheme.titleSmall,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '${userStatistics.points}',
                  style: theme.textTheme.titleMedium,
                ),
                const Icon(Icons.bolt),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
