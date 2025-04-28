import 'package:codium/core/widgets/user_provider.dart';
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
    final user = UserProvider.of(context);

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
              style: theme.textTheme.titleSmall?.copyWith(
                color: theme.colorScheme.surface,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  user.balance.format(),
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.surface,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
