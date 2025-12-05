import 'dart:async';

import 'package:codium/domain/models/models.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'achievement_notification_state.dart';

class AchievementNotificationCubit extends Cubit<AchievementNotificationState> {
  Timer? _hideTimer;

  AchievementNotificationCubit() : super(const AchievementNotificationHidden());

  void showAchievement(AchievementModel achievement) {
    _hideTimer?.cancel();

    emit(AchievementNotificationVisible(achievement: achievement));

    _hideTimer = Timer(const Duration(seconds: 3), () {
      hideAchievement();
    });
  }

  void hideAchievement() {
    _hideTimer?.cancel();
    emit(const AchievementNotificationHidden());
  }

  @override
  Future<void> close() {
    _hideTimer?.cancel();
    return super.close();
  }
}
