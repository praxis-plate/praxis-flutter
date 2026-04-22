import 'package:praxis/domain/models/achievement/achievement_data_model.dart';
import 'package:praxis/domain/models/user/user_profile_model.dart';
import 'package:equatable/equatable.dart';

class UserProfileDataModel extends Equatable {
  final UserProfileModel user;
  final int totalCoursesCompleted;
  final int totalLessonsCompleted;
  final List<AchievementModel> achievements;
  final int currentStreak;
  final int coinBalance;

  const UserProfileDataModel({
    required this.user,
    required this.totalCoursesCompleted,
    required this.totalLessonsCompleted,
    required this.achievements,
    required this.currentStreak,
    required this.coinBalance,
  });

  @override
  List<Object?> get props => [
    user,
    totalCoursesCompleted,
    totalLessonsCompleted,
    achievements,
    currentStreak,
    coinBalance,
  ];

  @override
  bool get stringify => true;
}
