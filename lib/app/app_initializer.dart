import 'package:codium/core/bloc/auth/auth_bloc.dart';
import 'package:codium/core/bloc/theme/theme_cubit.dart';
import 'package:codium/features/main/bloc/course_purchasing/course_purchasing_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class AppInitializer extends StatelessWidget {
  const AppInitializer({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ThemeCubit(
            PlatformDispatcher.instance.platformBrightness == Brightness.dark,
          ),
        ),
        BlocProvider(
          create: (context) => GetIt.I<AuthBloc>()..add(AuthCheckStatus()),
          lazy: false,
        ),
        BlocProvider(create: (context) => GetIt.I<CoursePurchasingBloc>()),
      ],
      child: child,
    );
  }
}
