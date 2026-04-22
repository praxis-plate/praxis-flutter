import 'package:praxis/core/bloc/auth/auth_bloc.dart';
import 'package:praxis/core/bloc/locale/locale.dart';
import 'package:praxis/core/bloc/theme/theme_cubit.dart';
import 'package:praxis/core/widgets/widgets.dart';
import 'package:praxis/domain/models/user/user.dart';
import 'package:praxis/features/main/bloc/user_statistics/user_statistics_bloc.dart';
import 'package:praxis/features/profile/profile.dart';
import 'package:praxis/s.dart';
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
        title: Text(
          s.profileTitle,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: false,
        titleSpacing: 16,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Wrapper(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _ProfileHeaderCard(userProfile: userProfile),
                      const SizedBox(height: 16),
                      _SettingsCard(
                        children: [
                          BlocBuilder<ThemeCubit, ThemeState>(
                            builder: (context, themeState) {
                              return SettingsTile(
                                icon: const Icon(Icons.light_mode_rounded),
                                title: s.profileThemeTitle,
                                subtitle: themeState.isDarkTheme
                                    ? s.profileThemeDark
                                    : s.profileThemeLight,
                                onTap: () => _showThemePicker(
                                  context,
                                  themeState.isDarkTheme,
                                ),
                              );
                            },
                          ),
                          const Divider(height: 1),
                          BlocBuilder<LocaleCubit, LocaleState>(
                            builder: (context, localeState) {
                              final isRu =
                                  localeState.locale.languageCode == 'ru';
                              return SettingsTile(
                                icon: const Icon(Icons.language),
                                title: s.profileLanguageTitle,
                                subtitle: isRu
                                    ? s.profileLanguageRu
                                    : s.profileLanguageEn,
                                onTap: () => _showLanguagePicker(
                                  context,
                                  localeState.locale,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      const Spacer(),
                      const SizedBox(height: 16),
                      Container(
                        decoration: BoxDecoration(
                          color: theme.cardColor,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: theme.dividerColor.withValues(alpha: 0.6),
                          ),
                        ),
                        child: SettingsTile(
                          title: s.profileLogOut,
                          onTap: () => context.read<AuthBloc>().add(
                            const AuthSignOutEvent(),
                          ),
                          icon: Icon(
                            Icons.exit_to_app_rounded,
                            color: theme.colorScheme.error,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showThemePicker(BuildContext context, bool isDark) {
    final s = S.of(context);

    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.wb_sunny_outlined),
                title: Text(s.profileThemeLight),
                trailing: isDark
                    ? null
                    : const Icon(Icons.check_rounded, size: 20),
                onTap: () {
                  context.read<ThemeCubit>().setDarkTheme(false);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.nights_stay_outlined),
                title: Text(s.profileThemeDark),
                trailing: isDark
                    ? const Icon(Icons.check_rounded, size: 20)
                    : null,
                onTap: () {
                  context.read<ThemeCubit>().setDarkTheme(true);
                  Navigator.of(context).pop();
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  void _showLanguagePicker(BuildContext context, Locale locale) {
    final s = S.of(context);

    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(s.profileLanguageRu),
                trailing: locale.languageCode == 'ru'
                    ? const Icon(Icons.check_rounded, size: 20)
                    : null,
                onTap: () {
                  context.read<LocaleCubit>().setLocale(const Locale('ru'));
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: Text(s.profileLanguageEn),
                trailing: locale.languageCode == 'en'
                    ? const Icon(Icons.check_rounded, size: 20)
                    : null,
                onTap: () {
                  context.read<LocaleCubit>().setLocale(const Locale('en'));
                  Navigator.of(context).pop();
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }
}

class _ProfileHeaderCard extends StatelessWidget {
  const _ProfileHeaderCard({required this.userProfile});

  final UserProfileModel userProfile;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.6)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.12),
            child: Icon(
              Icons.person,
              size: 28,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userProfile.name,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  userProfile.email,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          BlocBuilder<UserStatisticsBloc, UserStatisticsState>(
            builder: (context, state) {
              if (state is! UserStatisticsLoadSuccessState) {
                return const SizedBox.shrink();
              }

              return _BalancePill(amount: state.userStatistics.balance.amount);
            },
          ),
        ],
      ),
    );
  }
}

class _BalancePill extends StatelessWidget {
  const _BalancePill({required this.amount});

  final int amount;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.6)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SvgAsset(
            'assets/icons/currency/default.svg',
            width: 16,
            height: 16,
          ),
          const SizedBox(width: 4),
          Text(
            '$amount',
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.9),
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.6)),
      ),
      child: Column(children: children),
    );
  }
}
