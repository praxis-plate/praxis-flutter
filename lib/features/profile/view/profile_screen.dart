import 'package:codium/core/bloc/auth/auth_bloc.dart';
import 'package:codium/core/bloc/locale/locale.dart';
import 'package:codium/core/bloc/theme/theme_cubit.dart';
import 'package:codium/core/widgets/widgets.dart';
import 'package:codium/domain/models/user/user.dart';
import 'package:codium/features/main/bloc/user_statistics/user_statistics_bloc.dart';
import 'package:codium/features/profile/profile.dart';
import 'package:codium/s.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key, required this.userProfile});

  final UserProfileModel userProfile;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(s.profileTitle, style: theme.textTheme.titleLarge),
      ),
      body: Wrapper(
        child: Column(
          children: [
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: theme.colorScheme.primary.withValues(
                      alpha: 0.2,
                    ),
                    child: Icon(
                      Icons.person,
                      size: 50,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    userProfile.name,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    userProfile.email,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                  const SizedBox(height: 16),
                  BlocBuilder<UserStatisticsBloc, UserStatisticsState>(
                    builder: (context, state) {
                      if (state is! UserStatisticsLoadSuccessState) {
                        return const SizedBox();
                      }

                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.monetization_on,
                            color: theme.colorScheme.primary,
                            size: 20,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${state.userStatistics.balance.amount}',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            BlocBuilder<ThemeCubit, ThemeState>(
              builder: (context, themeState) {
                return SettingsSwitch(
                  icon: const Icon(Icons.light_mode_rounded),
                  title: s.profileSetDarkMode,
                  value: themeState.isDarkTheme,
                  onChanged: (isDark) =>
                      context.read<ThemeCubit>().setDarkTheme(isDark),
                );
              },
            ),
            BlocBuilder<LocaleCubit, LocaleState>(
              builder: (context, localeState) {
                return SettingsSwitch(
                  icon: const Icon(Icons.language),
                  title: s.profileSetRussian,
                  value: localeState.locale.languageCode == 'ru',
                  onChanged: (value) =>
                      context.read<LocaleCubit>().toggleLocale(),
                );
              },
            ),
            const Spacer(),
            const Divider(height: 8),
            SettingsTile(
              title: s.profileLogOut,
              onTap: () =>
                  context.read<AuthBloc>().add(const AuthSignOutEvent()),
              icon: Icon(
                Icons.exit_to_app_rounded,
                color: theme.colorScheme.error,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
