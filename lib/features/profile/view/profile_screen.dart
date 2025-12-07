import 'package:codium/core/bloc/auth/auth_bloc.dart';
import 'package:codium/core/bloc/locale/locale.dart';
import 'package:codium/core/bloc/theme/theme_cubit.dart';
import 'package:codium/features/profile/profile.dart';
import 'package:codium/features/profile/widgets/settings_switch.dart';
import 'package:codium/features/profile/widgets/settings_tile.dart';
import 'package:codium/s.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticatedState) {
          context.go('/sign-up');
        }
      },
      child: BlocBuilder<ProfileBloc, ProfileState>(
        bloc: GetIt.I<ProfileBloc>()..add(ProfileLoadEvent()),
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text(s.profileTitle, style: theme.textTheme.titleLarge),
            ),
            body: state is ProfileLoadingState
                ? const Center(child: CircularProgressIndicator())
                : state is ProfileLoadErrorState
                ? Center(
                    child: Text(
                      s.profileErrorLoading,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.error,
                      ),
                    ),
                  )
                : state is ProfileLoadSuccessState
                ? _ProfileContent(state: state)
                : const SizedBox.shrink(),
          );
        },
      ),
    );
  }
}

class _ProfileContent extends StatelessWidget {
  const _ProfileContent({required this.state});

  final ProfileLoadSuccessState state;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16),
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
                  state.user.name,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  state.user.email,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.monetization_on,
                      color: theme.colorScheme.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${state.coinBalance}',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
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
          const Expanded(child: SizedBox()),
          const Divider(height: 8),
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, authState) {
              return SettingsTile(
                title: s.profileLogOut,
                onTap: () =>
                    context.read<AuthBloc>().add(const AuthSignOutEvent()),
                icon: Icon(
                  Icons.exit_to_app_rounded,
                  color: theme.colorScheme.error,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
