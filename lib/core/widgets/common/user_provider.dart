import 'package:codium/domain/models/user/full_user_profile_model.dart';
import 'package:flutter/material.dart';

class UserProvider extends InheritedWidget {
  final FullUserProfileModel user;

  const UserProvider({super.key, required this.user, required super.child});

  static FullUserProfileModel of(BuildContext context) {
    final provider = context.dependOnInheritedWidgetOfExactType<UserProvider>();
    assert(provider != null, 'UserProvider not found in widget tree');
    return provider!.user;
  }

  static FullUserProfileModel? maybeOf(BuildContext context) {
    final provider = context.dependOnInheritedWidgetOfExactType<UserProvider>();
    return provider?.user;
  }

  @override
  bool updateShouldNotify(UserProvider oldWidget) {
    return user != oldWidget.user;
  }
}
