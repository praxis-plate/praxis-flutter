import 'package:equatable/equatable.dart';

class UpdateUserStatisticModel extends Equatable {
  final int id;
  final int? currentStreak;
  final int? maxStreak;
  final int? points;
  final DateTime? lastActiveDate;

  const UpdateUserStatisticModel({
    required this.id,
    this.currentStreak,
    this.maxStreak,
    this.points,
    this.lastActiveDate,
  });

  @override
  List<Object?> get props => [
    id,
    currentStreak,
    maxStreak,
    points,
    lastActiveDate,
  ];

  @override
  bool get stringify => true;
}
