import 'package:praxis/domain/models/achievement/achievement_data_model.dart';
import 'package:flutter/material.dart';

class AchievementCard extends StatelessWidget {
  final AchievementModel achievement;
  final VoidCallback? onTap;

  const AchievementCard({required this.achievement, this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isUnlocked = achievement.isUnlocked;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isUnlocked
              ? theme.colorScheme.primary.withValues(alpha: 0.05)
              : theme.cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isUnlocked
                ? theme.colorScheme.primary.withValues(alpha: 0.3)
                : theme.dividerColor,
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (achievement.iconUrl != null)
              _AchievementIcon(
                iconName: achievement.iconUrl!,
                isUnlocked: isUnlocked,
                theme: theme,
              ),
            const SizedBox(height: 12),
            Text(
              achievement.title,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: isUnlocked
                    ? theme.colorScheme.onSurface
                    : theme.colorScheme.onSurface.withValues(alpha: 0.4),
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            if (isUnlocked && achievement.unlockedAt != null) ...[
              const SizedBox(height: 4),
              Text(
                _formatDate(achievement.unlockedAt!),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Сегодня';
    } else if (difference.inDays == 1) {
      return 'Вчера';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} дн. назад';
    } else {
      return '${date.day}.${date.month}.${date.year}';
    }
  }
}

class _AchievementIcon extends StatelessWidget {
  final String iconName;
  final bool isUnlocked;
  final ThemeData theme;

  const _AchievementIcon({
    required this.iconName,
    required this.isUnlocked,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: isUnlocked
            ? theme.colorScheme.primary.withValues(alpha: 0.1)
            : theme.colorScheme.surfaceContainerHighest,
        shape: BoxShape.circle,
        border: Border.all(
          color: isUnlocked
              ? theme.colorScheme.primary
              : theme.colorScheme.onSurface.withValues(alpha: 0.2),
          width: 2,
        ),
      ),
      child: Center(
        child: Icon(
          _getIconData(iconName),
          size: 32,
          color: isUnlocked
              ? theme.colorScheme.primary
              : theme.colorScheme.onSurface.withValues(alpha: 0.3),
        ),
      ),
    );
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'first_steps':
      case 'first_course':
        return Icons.emoji_events;
      case 'category_master':
        return Icons.workspace_premium;
      case 'unstoppable':
        return Icons.local_fire_department;
      case 'early_bird':
        return Icons.wb_sunny;
      case 'night_owl':
        return Icons.nightlight_round;
      case 'speed_learner':
        return Icons.speed;
      default:
        return Icons.star;
    }
  }
}
