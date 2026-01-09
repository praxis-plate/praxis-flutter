import 'package:codium/app/app_initializer.dart';
import 'package:codium/core/bloc/locale/locale.dart';
import 'package:codium/core/bloc/theme/theme_cubit.dart';
import 'package:codium/core/config/app_config.dart';
import 'package:codium/core/router/router.dart';
import 'package:codium/s.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return AppInitializer(
      child: BlocBuilder<LocaleCubit, LocaleState>(
        builder: (context, localeState) {
          return BlocBuilder<ThemeCubit, ThemeState>(
            builder: (context, themeState) {
              return MaterialApp.router(
                localizationsDelegates: S.localizationDelegates,
                supportedLocales: S.supportedLocales,
                locale: localeState.locale,
                title: AppConfig.i.appName,
                theme: themeState.currentTheme,
                routerConfig: AppRouter.router,
                debugShowCheckedModeBanner: false,
              );
            },
          );
        },
      ),
    );
  }
}
