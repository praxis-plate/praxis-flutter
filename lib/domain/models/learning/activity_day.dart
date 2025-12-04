import 'package:equatable/equatable.dart';

class ActivityDay extends Equatable {
  final DateTime date;
  final int activityCount;
  final int value;

  const ActivityDay({
    required this.date,
    required this.activityCount,
    required this.value,
  });

  ActivityDay copyWith({DateTime? date, int? activityCount, int? value}) {
    return ActivityDay(
      date: date ?? this.date,
      activityCount: activityCount ?? this.activityCount,
      value: value ?? this.value,
    );
  }

  @override
  List<Object?> get props => [date, activityCount, value];

  @override
  bool get stringify => true;
}
