import 'dart:async';

import 'package:codium/domain/models/achievement/achievement_data_model.dart';
import 'package:codium/s.dart';
import 'package:flutter/material.dart';

class AchievementNotification extends StatefulWidget {
  final AchievementModel achievement;
  final VoidCallback onDismiss;

  const AchievementNotification({
    required this.achievement,
    required this.onDismiss,
    super.key,
  });

  @override
  State<AchievementNotification> createState() =>
      _AchievementNotificationState();
}

class _AchievementNotificationState extends State<AchievementNotification>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  Timer? _dismissTimer;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );

    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _controller.forward();

    _dismissTimer = Timer(const Duration(seconds: 3), () {
      _dismiss();
    });
  }

  @override
  void dispose() {
    _dismissTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _dismiss() {
    _controller.reverse().then((_) {
      widget.onDismiss();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _dismiss,
      child: Container(
        color: Colors.black.withValues(alpha: 0.5),
        child: Center(
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: _NotificationCard(achievement: widget.achievement),
            ),
          ),
        ),
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final AchievementModel achievement;

  const _NotificationCard({required this.achievement});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 32),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _AchievementIcon(iconName: achievement.iconUrl ?? ''),
          const SizedBox(height: 16),
          Text(
            s.achievementUnlocked,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            achievement.title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.primary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            achievement.description,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 16),
          const _Confetti(),
        ],
      ),
    );
  }
}

class _AchievementIcon extends StatelessWidget {
  final String iconName;

  const _AchievementIcon({required this.iconName});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.1),
        shape: BoxShape.circle,
        border: Border.all(color: theme.colorScheme.primary, width: 3),
      ),
      child: Center(
        child: Icon(
          _getIconData(iconName),
          size: 40,
          color: theme.colorScheme.primary,
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

class _Confetti extends StatelessWidget {
  const _Confetti();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('🎉', style: theme.textTheme.titleLarge),
        const SizedBox(width: 8),
        Text('✨', style: theme.textTheme.titleLarge),
        const SizedBox(width: 8),
        Text('🎊', style: theme.textTheme.titleLarge),
      ],
    );
  }
}
