import 'package:equatable/equatable.dart';

class UpdateUserStatisticModel extends Equatable {
  final int id;
  final int? currentStreak;
  final int? maxStreak;
  final int? coinBalance;
  final int? experiencePoints;
  final DateTime? lastActiveDate;

  const UpdateUserStatisticModel({
    required this.id,
    this.currentStreak,
    this.maxStreak,
    this.coinBalance,
    this.experiencePoints,
    this.lastActiveDate,
  });

  @override
  List<Object?> get props => [
    id,
    currentStreak,
    maxStreak,
    coinBalance,
    experiencePoints,
    lastActiveDate,
  ];

  @override
  bool get stringify => true;
}
