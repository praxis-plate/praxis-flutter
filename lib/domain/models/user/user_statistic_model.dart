import 'package:codium/domain/models/user/money.dart';
import 'package:equatable/equatable.dart';

class UserStatisticModel extends Equatable {
  final int userId;
  final int currentStreak;
  final int maxStreak;
  final Money balance;
  final DateTime lastActiveDate;

  const UserStatisticModel({
    required this.userId,
    required this.currentStreak,
    required this.maxStreak,
    required this.balance,
    required this.lastActiveDate,
  });

  UserStatisticModel copyWith({
    int? userId,
    int? currentStreak,
    int? maxStreak,
    Money? balance,
    DateTime? lastActiveDate,
  }) {
    return UserStatisticModel(
      userId: userId ?? this.userId,
      currentStreak: currentStreak ?? this.currentStreak,
      maxStreak: maxStreak ?? this.maxStreak,
      balance: balance ?? this.balance,
      lastActiveDate: lastActiveDate ?? this.lastActiveDate,
    );
  }

  @override
  List<Object?> get props => [
    userId,
    currentStreak,
    maxStreak,
    balance,
    lastActiveDate,
  ];

  @override
  bool get stringify => true;
}
