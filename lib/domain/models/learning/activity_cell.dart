import 'package:equatable/equatable.dart';

class ActivityCell extends Equatable {
  final DateTime date;
  final int level;

  const ActivityCell({required this.date, required this.level});

  ActivityCell copyWith({DateTime? date, int? level}) {
    return ActivityCell(date: date ?? this.date, level: level ?? this.level);
  }

  @override
  List<Object?> get props => [date, level];

  @override
  bool get stringify => true;
}
