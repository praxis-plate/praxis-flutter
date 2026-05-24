import 'package:praxis/core/bloc/locale/locale.dart';
import 'package:praxis/core/bloc/theme/theme_cubit.dart';
import 'package:praxis/core/widgets/widgets.dart';
import 'package:praxis/domain/models/user/user.dart';
import 'package:praxis/features/profile/profile.dart';
import 'package:praxis/s.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

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
                      ProfileHeaderCard(userProfile: userProfile),
                      const SizedBox(height: 16),
                      ProfileSettingsCard(
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
                      const ProfileLogoutCard(),
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
                  context.pop();
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
                  context.pop();
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
                  context.pop();
                },
              ),
              ListTile(
                title: Text(s.profileLanguageEn),
                trailing: locale.languageCode == 'en'
                    ? const Icon(Icons.check_rounded, size: 20)
                    : null,
                onTap: () {
                  context.read<LocaleCubit>().setLocale(const Locale('en'));
                  context.pop();
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
