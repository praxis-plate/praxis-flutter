part of 'achievement_notification_cubit.dart';

abstract class AchievementNotificationState extends Equatable {
  const AchievementNotificationState();

  @override
  List<Object?> get props => [];
}

class AchievementNotificationHidden extends AchievementNotificationState {
  const AchievementNotificationHidden();
}

class AchievementNotificationVisible extends AchievementNotificationState {
  final AchievementModel achievement;

  const AchievementNotificationVisible({required this.achievement});

  @override
  List<Object?> get props => [achievement];
}
