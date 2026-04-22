import 'package:praxis/core/bloc/achievement_notification/achievement_notification_cubit.dart';
import 'package:praxis/core/bloc/auth/auth_bloc.dart';
import 'package:praxis/core/bloc/locale/locale.dart';
import 'package:praxis/core/bloc/theme/theme_cubit.dart';
import 'package:praxis/core/bloc/user_profile/user_profile_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppInitializer extends StatelessWidget {
  const AppInitializer({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ThemeCubit(
            GetIt.I<SharedPreferences>(),
            PlatformDispatcher.instance.platformBrightness,
          ),
        ),
        BlocProvider(
          create: (context) => LocaleCubit(GetIt.I<SharedPreferences>()),
        ),
        BlocProvider(create: (context) => GetIt.I<AuthBloc>(), lazy: false),
        BlocProvider(
          create: (context) => GetIt.I<UserProfileBloc>(),
          lazy: false,
        ),
        BlocProvider(
          create: (context) => GetIt.I<AchievementNotificationCubit>(),
        ),
      ],
      child: child,
    );
  }
}
