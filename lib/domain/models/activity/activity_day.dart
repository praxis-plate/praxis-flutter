import 'package:codium/domain/models/activity/activity_cell.dart';

class ActivityDay extends ActivityCell {
  final DateTime date;
  final int value;

  const ActivityDay({
    required this.date,
    required this.value,
  });
}
