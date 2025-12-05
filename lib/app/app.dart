import 'package:codium/app/app_initializer.dart';
import 'package:codium/core/bloc/achievement_notification_cubit.dart';
import 'package:codium/core/bloc/locale/locale.dart';
import 'package:codium/core/bloc/theme/theme_cubit.dart';
import 'package:codium/core/bloc/user_profile/user_profile_bloc.dart';
import 'package:codium/core/router/router.dart';
import 'package:codium/core/theme/app_theme.dart';
import 'package:codium/core/widgets/achievement_notification.dart';
import 'package:codium/core/widgets/user_provider.dart';
import 'package:codium/domain/models/user/full_user_profile_model.dart';
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
                title: 'Codium',
                theme: themeState.isDarkTheme
                    ? AppTheme.of(Brightness.dark)
                    : AppTheme.of(Brightness.light),
                routerConfig: AppRouter.router,
                debugShowCheckedModeBanner: false,
                builder: (context, child) =>
                    BlocBuilder<UserProfileBloc, UserProfileState>(
                      builder: (context, state) {
                        Widget content = child!;

                        if (state is UserProfileLoadedState) {
                          final fullUser = FullUserProfileModel(
                            profile: state.profile,
                            balance: state.balance,
                            purchasedCourseIds: state.purchasedCourseIds,
                            currentStreak: state.currentStreak,
                            maxStreak: state.maxStreak,
                          );
                          content = UserProvider(
                            user: fullUser,
                            child: content,
                          );
                        }

                        return Stack(
                          children: [
                            content,
                            BlocBuilder<
                              AchievementNotificationCubit,
                              AchievementNotificationState
                            >(
                              builder: (context, notificationState) {
                                if (notificationState
                                    is AchievementNotificationVisible) {
                                  return AchievementNotification(
                                    achievement: notificationState.achievement,
                                    onDismiss: () {
                                      context
                                          .read<AchievementNotificationCubit>()
                                          .hideAchievement();
                                    },
                                  );
                                }
                                return const SizedBox.shrink();
                              },
                            ),
                          ],
                        );
                      },
                    ),
              );
            },
          );
        },
      ),
    );
  }
}
