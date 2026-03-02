import 'package:codium/core/error/app_error_code_extension.dart';
import 'package:codium/core/widgets/widgets.dart';
import 'package:codium/features/auth/bloc/forgot_password/forgot_password_cubit.dart';
import 'package:codium/features/auth/widgets/widgets.dart';
import 'package:codium/s.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({
    super.key,
    this.onSwitchToSignIn,
    this.onSwitchToSignUp,
  });

  final VoidCallback? onSwitchToSignIn;
  final VoidCallback? onSwitchToSignUp;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return BlocProvider(
      create: (context) => GetIt.I<ForgotPasswordCubit>(),
      child: BlocListener<ForgotPasswordCubit, ForgotPasswordState>(
        listenWhen: (previous, current) =>
            previous.status != current.status &&
            (current.status == FormzSubmissionStatus.success ||
                current.status == FormzSubmissionStatus.failure),
        listener: (context, state) {
          if (state.status == FormzSubmissionStatus.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(s.displayPasswordResetSuccess),
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
            );
            context.read<ForgotPasswordCubit>().reset();
            return;
          }

          final errorMessage = state.errorCode?.localizedMessage(context);
          if (errorMessage == null) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        },
        child: Scaffold(
          body: Stack(
            children: [
              SafeArea(
                child: GestureDetector(
                  onTap: FocusScope.of(context).unfocus,
                  child: Wrapper(
                    child: Center(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: _ForgotPasswordForm(
                          onSwitchToSignIn: onSwitchToSignIn,
                          onSwitchToSignUp: onSwitchToSignUp,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ForgotPasswordForm extends StatelessWidget {
  const _ForgotPasswordForm({this.onSwitchToSignIn, this.onSwitchToSignUp});

  final VoidCallback? onSwitchToSignIn;
  final VoidCallback? onSwitchToSignUp;

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
            Text(
              s.displayForgotPasswordTitle,
              style: theme.textTheme.displayLarge,
            ),
            const SizedBox(height: 12),
            Text(
              s.displayForgotPasswordSubtitle,
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 32),
            // TODO: поправить отображение, не строить отступ при отсутствии инпутов
            const _EmailInput(),
            const SizedBox(height: 16),
            const _VerificationCodeInput(),
            const SizedBox(height: 16),
            const _PasswordInput(),
            const SizedBox(height: 24),
            const _SubmitButton(),
            const SizedBox(height: 16),
            AuthRedirectText(
              questionText: s.displayRememberPassword,
              actionText: s.displaySignIn,
              onTap: onSwitchToSignIn ?? () => context.go('/auth/sign-in'),
            ),
            const SizedBox(height: 8),
            AuthRedirectText(
              questionText: s.displayDontHaveAnAccount,
              actionText: s.displaySignUp,
              onTap: onSwitchToSignUp ?? () => context.go('/auth/sign-up'),
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
    return BlocBuilder<ForgotPasswordCubit, ForgotPasswordState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return AuthEmailInput(
          errorText: state.email.stringDisplayError(s),
          enabled:
              state.step == ForgotPasswordStep.email &&
              state.status != FormzSubmissionStatus.inProgress,
          onChanged: context.read<ForgotPasswordCubit>().emailChanged,
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

    return BlocBuilder<ForgotPasswordCubit, ForgotPasswordState>(
      buildWhen: (previous, current) =>
          previous.verificationCode != current.verificationCode ||
          previous.step != current.step ||
          previous.status != current.status,
      builder: (context, state) {
        if (state.step != ForgotPasswordStep.verifyCode) {
          return const SizedBox.shrink();
        }

        return AuthCodeInput(
          errorText: state.verificationCode.stringDisplayError(s),
          enabled: state.status != FormzSubmissionStatus.inProgress,
          onChanged: context
              .read<ForgotPasswordCubit>()
              .verificationCodeChanged,
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

    return BlocBuilder<ForgotPasswordCubit, ForgotPasswordState>(
      buildWhen: (previous, current) =>
          previous.password != current.password ||
          previous.step != current.step ||
          previous.status != current.status,
      builder: (context, state) {
        if (state.step != ForgotPasswordStep.newPassword) {
          return const SizedBox.shrink();
        }

        return AuthPasswordInput(
          errorText: state.password.stringDisplayError(s),
          isEnabled: state.status != FormzSubmissionStatus.inProgress,
          onChanged: context.read<ForgotPasswordCubit>().passwordChanged,
        );
      },
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ForgotPasswordCubit, ForgotPasswordState>(
      builder: (context, state) {
        if (state.status == FormzSubmissionStatus.inProgress) {
          return const CircularProgressIndicator();
        }

        final s = S.of(context);
        final label = switch (state.step) {
          ForgotPasswordStep.email => s.displaySendVerificationCode,
          ForgotPasswordStep.verifyCode => s.displayVerifyCode,
          ForgotPasswordStep.newPassword => s.displayResetPassword,
        };

        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: state.isValid
                ? context.read<ForgotPasswordCubit>().submit
                : null,
            child: Text(label),
          ),
        );
      },
    );
  }
}
