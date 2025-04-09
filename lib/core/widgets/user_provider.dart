import 'package:codium/domain/models/models.dart';
import 'package:flutter/material.dart';

class UserProvider extends InheritedWidget {
  final User user;

  const UserProvider({
    super.key,
    required this.user,
    required super.child,
  });

  static User of(BuildContext context) {
    final provider = context.dependOnInheritedWidgetOfExactType<UserProvider>();
    return provider!.user;
  }

  @override
  bool updateShouldNotify(UserProvider oldWidget) {
    return user != oldWidget.user;
  }
}