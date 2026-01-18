import 'package:codium/domain/models/user/money.dart';
import 'package:equatable/equatable.dart';

class UserStatisticModel extends Equatable {
  final int id;
  final String userId;
  final int currentStreak;
  final int maxStreak;
  final Money balance;
  final int experiencePoints;
  final DateTime lastActiveDate;

  const UserStatisticModel({
    required this.id,
    required this.userId,
    required this.currentStreak,
    required this.maxStreak,
    required this.balance,
    required this.experiencePoints,
    required this.lastActiveDate,
  });

  UserStatisticModel copyWith({
    int? id,
    String? userId,
    int? currentStreak,
    int? maxStreak,
    Money? balance,
    int? experiencePoints,
    DateTime? lastActiveDate,
  }) {
    return UserStatisticModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      currentStreak: currentStreak ?? this.currentStreak,
      maxStreak: maxStreak ?? this.maxStreak,
      balance: balance ?? this.balance,
      experiencePoints: experiencePoints ?? this.experiencePoints,
      lastActiveDate: lastActiveDate ?? this.lastActiveDate,
    );
  }

  @override
  List<Object?> get props => [
    id,
    userId,
    currentStreak,
    maxStreak,
    balance,
    experiencePoints,
    lastActiveDate,
  ];

  @override
  bool get stringify => true;
}
