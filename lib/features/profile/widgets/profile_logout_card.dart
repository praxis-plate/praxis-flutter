import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:praxis/core/bloc/auth/auth_bloc.dart';
import 'package:praxis/features/profile/widgets/settings_tile.dart';
import 'package:praxis/s.dart';

class ProfileLogoutCard extends StatelessWidget {
  const ProfileLogoutCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.6)),
      ),
      child: SettingsTile(
        title: S.of(context).profileLogOut,
        onTap: () => context.read<AuthBloc>().add(const AuthSignOutEvent()),
        icon: Icon(Icons.exit_to_app_rounded, color: theme.colorScheme.error),
      ),
    );
  }
}
