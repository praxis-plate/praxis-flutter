import 'package:codium/domain/models/user/money.dart';
import 'package:codium/domain/models/user/user_profile_model.dart';
import 'package:equatable/equatable.dart';

class FullUserProfileModel extends Equatable {
  final UserProfileModel profile;
  final Money balance;
  final List<int> purchasedCourseIds;
  final int currentStreak;
  final int maxStreak;

  const FullUserProfileModel({
    required this.profile,
    required this.balance,
    required this.purchasedCourseIds,
    required this.currentStreak,
    required this.maxStreak,
  });

  FullUserProfileModel copyWith({
    UserProfileModel? profile,
    Money? balance,
    List<int>? purchasedCourseIds,
    int? currentStreak,
    int? maxStreak,
  }) {
    return FullUserProfileModel(
      profile: profile ?? this.profile,
      balance: balance ?? this.balance,
      purchasedCourseIds: purchasedCourseIds ?? this.purchasedCourseIds,
      currentStreak: currentStreak ?? this.currentStreak,
      maxStreak: maxStreak ?? this.maxStreak,
    );
  }

  @override
  List<Object?> get props => [
    profile,
    balance,
    purchasedCourseIds,
    currentStreak,
    maxStreak,
  ];

  @override
  bool get stringify => true;
}
