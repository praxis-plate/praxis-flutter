import 'package:codium/core/bloc/auth/auth_bloc.dart';
import 'package:codium/core/widgets/widgets.dart';
import 'package:codium/features/auth/bloc/sign_in/sign_in_cubit.dart';
import 'package:codium/features/auth/widgets/widgets.dart';
import 'package:codium/s.dart';
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
    return Scaffold(
      body: Stack(
        children: [
          const BlurredImageBackground(),
          SafeArea(
            child: GestureDetector(
              onTap: FocusScope.of(context).unfocus,
              child: Wrapper(
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
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
            Text(s.displaySignIn, style: theme.textTheme.displayLarge),
            const SizedBox(height: 32),
            const _EmailInput(),
            const SizedBox(height: 16),
            const _PasswordInput(),
            const SizedBox(height: 4),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: onSwitchToForgotPassword,
                child: Text(s.displayForgotPassword),
              ),
            ),
            const SizedBox(height: 16),
            const _SubmitButton(),
            const SizedBox(height: 16),
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

            if (isLoading) {
              return const CircularProgressIndicator();
            }

            return SizedBox(
              width: double.infinity,
              child: ElevatedButton(
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
