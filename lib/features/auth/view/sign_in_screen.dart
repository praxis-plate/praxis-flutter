import 'package:praxis/core/bloc/auth/auth_bloc.dart';
import 'package:praxis/core/widgets/widgets.dart';
import 'package:praxis/features/auth/bloc/sign_in/sign_in_cubit.dart';
import 'package:praxis/features/auth/widgets/widgets.dart';
import 'package:praxis/s.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({
    super.key,
    required this.onSwitchToSignUp,
    required this.onSwitchToForgotPassword,
  });

  final VoidCallback onSwitchToSignUp;
  final VoidCallback onSwitchToForgotPassword;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        title: Text(s.displaySignIn),
        titleTextStyle: theme.textTheme.titleLarge?.copyWith(
          color: theme.colorScheme.onPrimary,
          fontWeight: FontWeight.w700,
        ),
        leading: Icon(
          Icons.door_front_door_outlined,
          color: theme.colorScheme.onPrimary,
        ),
      ),
      body: Stack(
        children: [
          SafeArea(
            child: GestureDetector(
              onTap: FocusScope.of(context).unfocus,
              child: Wrapper(
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                    child: _SignInForm(
                      onSwitchToSignUp: onSwitchToSignUp,
                      onSwitchToForgotPassword: onSwitchToForgotPassword,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SignInForm extends StatelessWidget {
  const _SignInForm({
    required this.onSwitchToSignUp,
    required this.onSwitchToForgotPassword,
  });

  final VoidCallback onSwitchToSignUp;
  final VoidCallback onSwitchToForgotPassword;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);

    return Form(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              child: Text(
                s.displaySignInSubtitle,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            const SizedBox(height: 24),
            const _EmailInput(),
            const SizedBox(height: 16),
            const _PasswordInput(),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: onSwitchToForgotPassword,
                child: Text(s.displayForgotPassword),
              ),
            ),
            const SizedBox(height: 8),
            const _SubmitButton(),
            const SizedBox(height: 12),
            Divider(
              height: 14,
              thickness: 0.75,
              indent: 48,
              endIndent: 48,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.12),
            ),
            const SizedBox(height: 8),
            AuthRedirectText(
              questionText: s.displayDontHaveAnAccount,
              actionText: s.displaySignUp,
              onTap: onSwitchToSignUp,
            ),
          ],
        ),
      ),
    );
  }
}

class _EmailInput extends StatelessWidget {
  const _EmailInput();

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return BlocBuilder<SignInCubit, SignInState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return AuthEmailInput(
          errorText: state.email.stringDisplayError(s),
          enabled: state.status != FormzSubmissionStatus.inProgress,
          onChanged: context.read<SignInCubit>().emailChanged,
        );
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  const _PasswordInput();

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return BlocBuilder<SignInCubit, SignInState>(
      builder: (context, state) {
        final cubit = context.read<SignInCubit>();
        return AuthPasswordInput(
          errorText: state.password.stringDisplayError(s),
          isEnabled: state.status != FormzSubmissionStatus.inProgress,
          onChanged: cubit.passwordChanged,
        );
      },
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignInCubit, SignInState>(
      builder: (context, formState) {
        return BlocBuilder<AuthBloc, AuthState>(
          builder: (context, authState) {
            final isLoading = authState is AuthLoadingState;
            final theme = Theme.of(context);

            if (isLoading) {
              return const CircularProgressIndicator();
            }

            return SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  disabledForegroundColor: theme.colorScheme.onSurface
                      .withValues(alpha: 0.6),
                  disabledBackgroundColor: theme.colorScheme.onSurface
                      .withValues(alpha: 0.12),
                ),
                onPressed: formState.isValid
                    ? () => _handleSignIn(context, formState)
                    : null,
                child: Text(S.of(context).displaySignIn),
              ),
            );
          },
        );
      },
    );
  }

  void _handleSignIn(BuildContext context, SignInState formState) {
    final email = formState.email.value;
    final password = formState.password.value;

    context.read<AuthBloc>().add(
      AuthSignInEvent(email: email, password: password),
    );

    context.read<SignInCubit>().setSubmissionInProgress();
  }
}
