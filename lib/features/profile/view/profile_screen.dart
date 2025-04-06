import 'package:codium/core/bloc/auth/auth_bloc.dart';
import 'package:codium/core/bloc/theme/theme_cubit.dart';
import 'package:codium/core/utils/constants.dart';
import 'package:codium/features/profile/bloc/bloc/profile_bloc.dart';
import 'package:codium/features/profile/widgets/settings_profile_card.dart';
import 'package:codium/features/profile/widgets/settings_switch.dart';
import 'package:codium/features/profile/widgets/settings_tile.dart';
import 'package:codium/s.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final ProfileBloc _profileBloc;

  @override
  void initState() {
    _profileBloc = GetIt.I<ProfileBloc>();
    _profileBloc.add(ProfileLoadEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.of(context).profileTitle,
          style: theme.textTheme.titleLarge,
        ),
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthUnauthenticatedState) {
            context.go('/');
          }
        },
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BlocBuilder<ProfileBloc, ProfileState>(
                  bloc: _profileBloc,
                  builder: (context, state) {
                    if (state is ProfileLoadSuccessState) {
                      return SettingsProfileCard(
                        userProfile: UserProfile(
                          imagePath: state.user.avatarUrl ??
                              Constants.placeholderProfileImagePath,
                          name: state.user.email,
                          email: state.user.email,
                        ),
                      );
                    }

                    if (state is ProfileLoadErrorState) {
                      return Text(state.message);
                    }

                    return const CircularProgressIndicator();
                  },
                ),
                const Divider(height: 8),
                BlocBuilder<ThemeCubit, ThemeState>(
                  builder: (context, state) {
                    return SettingsSwitch(
                      icon: const Icon(
                        Icons.light_mode_rounded,
                      ),
                      title: S.of(context).profileSetDarkMode,
                      value: state.isDarkTheme,
                      onChanged: (isDark) =>
                          context.read<ThemeCubit>().setDarkTheme(isDark),
                    );
                  },
                ),
                SettingsSwitch(
                  icon: const Icon(Icons.language),
                  title: S.of(context).profileSetRussian,
                  value: true,
                  onChanged: (value) {},
                ),
                const Expanded(
                  child: SizedBox(),
                ),
                const Divider(height: 8),
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    return SettingsTile(
                      title: S.of(context).profileLogOut,
                      onTap: () =>
                          context.read<AuthBloc>().add(AuthSignOutEvent()),
                      icon: Icon(
                        Icons.exit_to_app_rounded,
                        color: theme.colorScheme.error,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
