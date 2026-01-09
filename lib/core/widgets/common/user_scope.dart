import 'package:codium/domain/models/user/user_profile_model.dart';
import 'package:flutter/material.dart';

class UserScope extends InheritedWidget {
  const UserScope({super.key, required this.user, required super.child});

  final UserProfileModel user;

  static UserProfileModel of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<UserScope>();
    assert(scope != null, 'UserScope not found in widget tree');
    return scope!.user;
  }

  static UserProfileModel? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<UserScope>()?.user;

  @override
  bool updateShouldNotify(UserScope oldWidget) => user != oldWidget.user;
}
