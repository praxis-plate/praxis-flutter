import 'package:flutter/material.dart';
import 'package:praxis/core/widgets/widgets.dart';
import 'package:praxis/s.dart';

class TaskFeedbackHero extends StatelessWidget {
  const TaskFeedbackHero({
    super.key,
    required this.isCorrect,
    required this.shiftState,
    required this.label,
    required this.title,
    required this.subtitle,
    required this.xpEarned,
    required this.accentColor,
    required this.backgroundColor,
    required this.illustrationRotation,
    required this.illustrationAlignment,
    required this.badgeBackgroundColor,
  });

  final bool isCorrect;
  final ShiftState shiftState;
  final String label;
  final String title;
  final String? subtitle;
  final int xpEarned;
  final Color accentColor;
  final Color backgroundColor;
  final double illustrationRotation;
  final Alignment illustrationAlignment;
  final Color badgeBackgroundColor;

  @override
  Widget build(BuildContext context) {
    if (isCorrect) {
      return _CorrectFeedbackHeroCard(
        shiftState: shiftState,
        title: title,
        xpEarned: xpEarned,
        accentColor: accentColor,
        backgroundColor: backgroundColor,
        illustrationRotation: illustrationRotation,
        badgeBackgroundColor: badgeBackgroundColor,
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 360;

        return Stack(
          clipBehavior: Clip.none,
          children: [
            SurfaceCard(
              padding: EdgeInsets.fromLTRB(20, 20, isCompact ? 20 : 124, 20),
              borderRadius: BorderRadius.circular(24),
              borderColor: accentColor.withValues(alpha: 0.28),
              backgroundColor: backgroundColor,
              boxShadow: const [],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _FeedbackHeroCopy(
                    isCorrect: false,
                    label: label,
                    title: title,
                    subtitle: subtitle,
                    xpEarned: xpEarned,
                    accentColor: accentColor,
                    badgeBackgroundColor: badgeBackgroundColor,
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      _FeedbackAccentDot(color: accentColor),
                      const SizedBox(width: 8),
                      _FeedbackAccentDot(
                        color: accentColor.withValues(alpha: 0.55),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Container(
                          height: 2,
                          color: accentColor.withValues(alpha: 0.14),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              top: isCompact ? -4 : 14,
              right: isCompact ? 14 : 10,
              child: _FeedbackHeroSticker(
                shiftState: shiftState,
                accentColor: accentColor,
                illustrationRotation: illustrationRotation,
                compact: isCompact,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _CorrectFeedbackHeroCard extends StatelessWidget {
  const _CorrectFeedbackHeroCard({
    required this.shiftState,
    required this.title,
    required this.xpEarned,
    required this.accentColor,
    required this.backgroundColor,
    required this.illustrationRotation,
    required this.badgeBackgroundColor,
  });

  final ShiftState shiftState;
  final String title;
  final int xpEarned;
  final Color accentColor;
  final Color backgroundColor;
  final double illustrationRotation;
  final Color badgeBackgroundColor;

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
      borderRadius: BorderRadius.circular(24),
      borderColor: accentColor.withValues(alpha: 0.28),
      backgroundColor: backgroundColor,
      boxShadow: const [],
      child: Column(
        children: [
          _FeedbackHeroSticker(
            shiftState: shiftState,
            accentColor: accentColor,
            illustrationRotation: illustrationRotation,
            compact: false,
            framed: false,
          ),
          const SizedBox(height: 18),
          _FeedbackHeroCopy(
            isCorrect: true,
            label: '',
            title: title,
            subtitle: null,
            xpEarned: xpEarned,
            accentColor: accentColor,
            badgeBackgroundColor: badgeBackgroundColor,
          ),
        ],
      ),
    );
  }
}

class _FeedbackHeroCopy extends StatelessWidget {
  const _FeedbackHeroCopy({
    required this.isCorrect,
    required this.label,
    required this.title,
    required this.subtitle,
    required this.xpEarned,
    required this.accentColor,
    required this.badgeBackgroundColor,
  });

  final bool isCorrect;
  final String label;
  final String title;
  final String? subtitle;
  final int xpEarned;
  final Color accentColor;
  final Color badgeBackgroundColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: isCorrect
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        if (!isCorrect)
          DecoratedBox(
            decoration: BoxDecoration(
              color: badgeBackgroundColor,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              child: Text(
                label,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: accentColor,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        const SizedBox(height: 16),
        Text(
          title,
          style: theme.textTheme.headlineSmall?.copyWith(
            color: accentColor,
            fontWeight: FontWeight.w900,
            height: 1.05,
          ),
          textAlign: isCorrect ? TextAlign.center : TextAlign.start,
        ),
        if (isCorrect && xpEarned > 0) ...[
          const SizedBox(height: 14),
          DecoratedBox(
            decoration: BoxDecoration(
              color: badgeBackgroundColor,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.stars_rounded, size: 18, color: accentColor),
                  const SizedBox(width: 8),
                  Text(
                    S.of(context).taskXpEarned(xpEarned),
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: accentColor,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
        if (subtitle != null) ...[
          const SizedBox(height: 8),
          Text(
            subtitle!,
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ],
    );
  }
}

class _FeedbackHeroSticker extends StatelessWidget {
  const _FeedbackHeroSticker({
    required this.shiftState,
    required this.accentColor,
    required this.illustrationRotation,
    required this.compact,
    this.framed = true,
  });

  final ShiftState shiftState;
  final Color accentColor;
  final double illustrationRotation;
  final bool compact;
  final bool framed;

  @override
  Widget build(BuildContext context) {
    final sticker = Transform.rotate(
      angle: illustrationRotation,
      child: ShiftAsset(
        shiftState,
        width: compact ? 82 : 136,
        height: compact ? 82 : 136,
      ),
    );

    if (!framed) {
      return sticker;
    }

    return DecoratedBox(
      decoration: BoxDecoration(
        color: accentColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Padding(padding: const EdgeInsets.all(8), child: sticker),
    );
  }
}

class _FeedbackAccentDot extends StatelessWidget {
  const _FeedbackAccentDot({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
