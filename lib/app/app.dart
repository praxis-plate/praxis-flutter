import 'package:codium/app/app_initializer.dart';
import 'package:codium/core/bloc/auth/auth_bloc.dart';
import 'package:codium/core/bloc/theme/theme_cubit.dart';
import 'package:codium/core/router/router.dart';
import 'package:codium/core/theme/app_theme.dart';
import 'package:codium/core/widgets/user_provider.dart';
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
            theme: state.isDarkTheme ? AppTheme.of(Brightness.dark) : AppTheme.of(Brightness.dark),
            routerConfig: AppRouter.router,
            debugShowCheckedModeBanner: false,
            builder: (context, child) => BlocBuilder<AuthBloc, AuthState>(
              buildWhen: (prev, curr) {
                if (prev.runtimeType != curr.runtimeType) return true;

                if (prev is AuthAuthenticatedState &&
                    curr is AuthAuthenticatedState) {
                  return prev.user != curr.user;
                }

                if (prev is AuthUnauthenticatedState &&
                    curr is AuthUnauthenticatedState) {
                  return prev.redirectReason != curr.redirectReason;
                }

                return false;
              },
              builder: (context, state) {
                if (state is AuthAuthenticatedState) {
                  return UserProvider(
                    user: state.user,
                    child: child!,
                  );
                }
                return child!;
              },
            ),
          );
        },
      ),
    );
  }
}
