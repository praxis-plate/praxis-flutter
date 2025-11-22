import 'dart:math';

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
      children: [
        GridWithMonths(activities: activities),
        const SizedBox(height: 16),
        const Divider(),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            StatisticsElement(
              number: userStatistics.maxStreak.toString(),
              label: s.streak,
            ),
            StatisticsElement(
              number: userStatistics.points.toString(),
              label: s.points,
            ),
            StatisticsElement(
              number: userStatistics.totalSolvedTasks.toString(),
              label: s.solved,
            ),
          ],
        ),
      ],
    );
  }
}

class GridWithMonths extends StatelessWidget {
  const GridWithMonths({required this.activities, super.key});

  final List<ActivityCell> activities;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: GridView.builder(
        scrollDirection: Axis.horizontal,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 8, // first element - month name
          crossAxisSpacing: 4,
          mainAxisSpacing: 4,
        ),
        itemCount: activities.length,
        itemBuilder: (context, index) {
          var cell = activities[index];

          if (cell is ActivityMonth) {
            return ActivityMonthNameGridCell(monthName: cell);
          }

          if (cell is ActivityDay) {
            return const ActivityDayGridCell();
          }

          return const SizedBox();
        },
      ),
    );
  }
}

class ActivityDayGridCell extends StatelessWidget {
  const ActivityDayGridCell({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withAlpha(Random().nextInt(206) + 50),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

class ActivityMonthNameGridCell extends StatelessWidget {
  const ActivityMonthNameGridCell({super.key, required this.monthName});

  final ActivityMonth monthName;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Text(monthName.name, style: theme.textTheme.labelSmall),
    );
  }
}

class StatisticsElement extends StatelessWidget {
  const StatisticsElement({
    required this.number,
    required this.label,
    super.key,
  });

  final String number;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Text(number, style: theme.textTheme.titleMedium),
        Text(label, style: theme.textTheme.labelMedium),
      ],
    );
  }
}
