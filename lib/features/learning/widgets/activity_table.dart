import 'package:codium/domain/models/learning/activity_cell.dart';
import 'package:codium/domain/models/learning/activity_day.dart';
import 'package:codium/domain/models/models.dart';
import 'package:codium/s.dart';
import 'package:flutter/material.dart';

class ActivityTable extends StatelessWidget {
  const ActivityTable({
    required this.activities,
    required this.userStatistics,
    super.key,
  });

  final List<ActivityCell> activities;
  final UserStatistics userStatistics;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: _StatisticsCard(
                number: userStatistics.maxStreak.toString(),
                label: s.streak,
                icon: Icons.local_fire_department,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _StatisticsCard(
                number: userStatistics.points.toString(),
                label: s.points,
                icon: Icons.star,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _StatisticsCard(
                number: userStatistics.totalSolvedTasks.toString(),
                label: s.solved,
                icon: Icons.check_circle,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _ActivityCalendar(activities: activities),
      ],
    );
  }
}

class _StatisticsCard extends StatelessWidget {
  const _StatisticsCard({
    required this.number,
    required this.label,
    required this.icon,
  });

  final String number;
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, size: 32, color: theme.colorScheme.primary),
          const SizedBox(height: 8),
          Text(
            number,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _ActivityCalendar extends StatelessWidget {
  const _ActivityCalendar({required this.activities});

  final List<ActivityCell> activities;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activityDays = activities.whereType<ActivityDay>().toList();

    if (activityDays.isEmpty) {
      return const SizedBox.shrink();
    }

    final last180Days = activityDays.length > 180
        ? activityDays.sublist(activityDays.length - 180)
        : activityDays;
    final weeks = _groupByWeeks(last180Days);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Activity',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          LayoutBuilder(
            builder: (context, constraints) {
              final availableWidth = constraints.maxWidth;
              final weekCount = weeks.length;
              const cellSpacing = 2.0;
              const weekSpacing = 4.0;
              final totalSpacing =
                  (weekCount - 1) * weekSpacing + (weekCount * 6 * cellSpacing);
              final cellSize =
                  ((availableWidth - totalSpacing) / (weekCount * 7)).clamp(
                    10.0,
                    16.0,
                  );

              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  for (var i = 0; i < weeks.length; i++) ...[
                    if (i > 0) const SizedBox(width: weekSpacing),
                    Column(
                      children: weeks[i].map((day) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: cellSpacing),
                          child: _ActivityCell(day: day, size: cellSize),
                        );
                      }).toList(),
                    ),
                  ],
                ],
              );
            },
          ),
          const SizedBox(height: 12),
          const Row(
            children: [
              _LegendCell(level: 0),
              SizedBox(width: 2),
              _LegendCell(level: 1),
              SizedBox(width: 2),
              _LegendCell(level: 2),
              SizedBox(width: 2),
              _LegendCell(level: 3),
              SizedBox(width: 2),
              _LegendCell(level: 4),
            ],
          ),
        ],
      ),
    );
  }

  List<List<ActivityDay>> _groupByWeeks(List<ActivityDay> days) {
    final weeks = <List<ActivityDay>>[];
    var currentWeek = <ActivityDay>[];

    for (var i = 0; i < days.length; i++) {
      final day = days[i];
      currentWeek.add(day);

      if (day.date.weekday == DateTime.sunday || i == days.length - 1) {
        while (currentWeek.length < 7) {
          currentWeek.add(
            ActivityDay(
              date: currentWeek.last.date.add(const Duration(days: 1)),
              activityCount: 0,
              value: 0,
            ),
          );
        }
        weeks.add(List.from(currentWeek));
        currentWeek.clear();
      }
    }

    return weeks;
  }
}

class _ActivityCell extends StatelessWidget {
  const _ActivityCell({required this.day, required this.size});

  final ActivityDay day;
  final double size;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final level = (day.value / 5 * 4).clamp(0, 4).toInt();

    Color getCellColor() {
      if (level == 0) {
        return theme.colorScheme.onSurface.withValues(alpha: 0.05);
      }
      final alphas = [0.2, 0.4, 0.6, 0.8, 1.0];
      return theme.colorScheme.primary.withValues(alpha: alphas[level]);
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: getCellColor(),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}

class _LegendCell extends StatelessWidget {
  const _LegendCell({required this.level});

  final int level;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Color getCellColor() {
      if (level == 0) {
        return theme.colorScheme.onSurface.withValues(alpha: 0.05);
      }
      final alphas = [0.2, 0.4, 0.6, 0.8, 1.0];
      return theme.colorScheme.primary.withValues(alpha: alphas[level]);
    }

    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: getCellColor(),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}
