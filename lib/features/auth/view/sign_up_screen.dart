import 'package:codium/core/bloc/auth/auth_bloc.dart';
import 'package:codium/core/widgets/widgets.dart';
import 'package:codium/features/auth/bloc/sign_up/sign_up_cubit.dart';
import 'package:codium/features/auth/widgets/widgets.dart';
import 'package:codium/l10n/app_localizations.dart';
import 'package:codium/s.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key, required this.onSwitchToSignIn});

  final VoidCallback onSwitchToSignIn;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: GestureDetector(
              onTap: FocusScope.of(context).unfocus,
              behavior: HitTestBehavior.translucent,
              child: Wrapper(
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: _SignUpForm(onSwitchToSignIn: onSwitchToSignIn),
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

class _SignUpForm extends StatelessWidget {
  const _SignUpForm({this.onSwitchToSignIn});

  final VoidCallback? onSwitchToSignIn;

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
            Icon(
              Icons.lock_outline,
              size: 48,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 12),
            Text(s.displaySignUp, style: theme.textTheme.displayLarge),
            const SizedBox(height: 32),
            const _EmailInput(),
            const SizedBox(height: 16),
            const _VerificationCodeInput(),
            const SizedBox(height: 16),
            const _PasswordInput(),
            const SizedBox(height: 16),
            const _SubmitButton(),
            const SizedBox(height: 16),
            _SignInRedirect(onSwitchToSignIn: onSwitchToSignIn),
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

    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return AuthEmailInput(
          errorText: state.email.stringDisplayError(s),
          enabled:
              state.step == SignUpStep.email &&
              state.status != FormzSubmissionStatus.inProgress,
          onChanged: context.read<SignUpCubit>().emailChanged,
        );
      },
    );
  }
}

class _VerificationCodeInput extends StatelessWidget {
  const _VerificationCodeInput();

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) =>
          previous.verificationCode != current.verificationCode ||
          previous.step != current.step ||
          previous.status != current.status,
      builder: (context, state) {
        if (state.step != SignUpStep.verifyCode) {
          return const SizedBox.shrink();
        }

        return AuthCodeInput(
          errorText: state.verificationCode.stringDisplayError(s),
          enabled: state.status != FormzSubmissionStatus.inProgress,
          onChanged: context.read<SignUpCubit>().verificationCodeChanged,
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

    return BlocBuilder<SignUpCubit, SignUpState>(
      builder: (context, state) {
        final cubit = context.read<SignUpCubit>();
        if (state.step != SignUpStep.password) {
          return const SizedBox.shrink();
        }

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
    return BlocBuilder<SignUpCubit, SignUpState>(
      builder: (context, formState) {
        return BlocBuilder<AuthBloc, AuthState>(
          builder: (context, authState) {
            final isLoading =
                authState is AuthLoadingState ||
                formState.status == FormzSubmissionStatus.inProgress;
            final s = S.of(context);
            final cubit = context.read<SignUpCubit>();

            return isLoading
                ? const CircularProgressIndicator()
                : SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: formState.isValid
                          ? () => _handleSubmit(cubit, formState)
                          : null,
                      child: Text(_buttonText(s, formState.step)),
                    ),
                  );
          },
        );
      },
    );
  }

  void _handleSubmit(SignUpCubit cubit, SignUpState formState) {
    switch (formState.step) {
      case SignUpStep.email:
        cubit.startRegistration();
        break;
      case SignUpStep.verifyCode:
        cubit.verifyRegistrationCode();
        break;
      case SignUpStep.password:
        cubit.submitRegistration();
        break;
    }
  }

  String _buttonText(AppLocalizations s, SignUpStep step) {
    return switch (step) {
      SignUpStep.email => s.displaySendVerificationCode,
      SignUpStep.verifyCode => s.displayVerifyCode,
      SignUpStep.password => s.displaySignUp,
    };
  }
}

class _SignInRedirect extends StatelessWidget {
  const _SignInRedirect({this.onSwitchToSignIn});

  final VoidCallback? onSwitchToSignIn;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return AuthRedirectText(
      questionText: s.displayAlreadyHaveAnAccount,
      actionText: s.displaySignIn,
      onTap: onSwitchToSignIn ?? () => context.go('/auth/sign-in'),
    );
  }
}
