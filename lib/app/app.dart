import 'package:codium/app/app_initializer.dart';
import 'package:codium/core/bloc/theme/theme_cubit.dart';
import 'package:codium/core/router/router.dart';
import 'package:codium/core/theme/app_theme.dart';
import 'package:codium/s.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return AppInitializer(
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          return MaterialApp.router(
            localizationsDelegates: S.localizationDelegates,
            supportedLocales: S.supportedLocales,
            locale: S.locale,
            title: 'Codium',
            theme: state.isDarkTheme ? AppTheme.darkTheme : AppTheme.lightTheme,
            routerConfig: AppRouter.router,
          );
        },
      ),
    );
  }
}
