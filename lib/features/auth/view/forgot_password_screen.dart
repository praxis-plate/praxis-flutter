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
          extendBody: true,
          body: SafeArea(
            bottom: false,
            child: GestureDetector(
              onTap: FocusScope.of(context).unfocus,
              child: Wrapper(
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 96),
                    child: _ForgotPasswordForm(
                      onSwitchToSignIn: onSwitchToSignIn,
                      onSwitchToSignUp: onSwitchToSignUp,
                    ),
                  ),
                ),
              ),
            ),
          ),
          bottomNavigationBar: const BottomAppBar(
            child: SafeArea(
              top: false,
              minimum: EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: _ForgotPasswordProgress(),
            ),
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
            Icon(
              Icons.lock_reset,
              size: 48,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 12),
            Text(
              s.displayForgotPasswordTitle,
              style: theme.textTheme.displayLarge,
            ),
            const SizedBox(height: 12),
            Text(
              s.displayForgotPasswordSubtitle,
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            const _ForgotPasswordInputs(),
            const SizedBox(height: 16),
            const _SubmitButton(),
            const SizedBox(height: 16),
            AuthOrDivider(text: s.displayOr),
            const SizedBox(height: 4),
            AuthRedirectText(
              questionText: s.displayRememberPassword,
              actionText: s.displaySignIn,
              onTap: onSwitchToSignIn ?? () => context.go('/auth/sign-in'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ForgotPasswordProgress extends StatelessWidget {
  const _ForgotPasswordProgress();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ForgotPasswordCubit, ForgotPasswordState>(
      buildWhen: (previous, current) => previous.step != current.step,
      builder: (context, state) {
        final theme = Theme.of(context);
        final s = S.of(context);
        final currentStep = switch (state.step) {
          ForgotPasswordStep.email => 0,
          ForgotPasswordStep.verifyCode => 1,
          ForgotPasswordStep.newPassword => 2,
        };
        final stepLabel = switch (state.step) {
          ForgotPasswordStep.email => s.displayForgotStepEmail,
          ForgotPasswordStep.verifyCode => s.displayForgotStepVerifyCode,
          ForgotPasswordStep.newPassword => s.displayForgotStepNewPassword,
        };

        return Column(
          children: [
            Text(
              s.displayForgotStepProgress(currentStep + 1, 3, stepLabel),
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.85),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: _StepBar(isActive: currentStep == 0)),
                const SizedBox(width: 8),
                Expanded(child: _StepBar(isActive: currentStep == 1)),
                const SizedBox(width: 8),
                Expanded(child: _StepBar(isActive: currentStep == 2)),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _StepBar extends StatelessWidget {
  const _StepBar({required this.isActive});

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activeColor = theme.colorScheme.primary;
    final inactiveColor = theme.colorScheme.onSurface.withValues(alpha: 0.2);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      height: 6,
      decoration: BoxDecoration(
        color: isActive ? activeColor : inactiveColor,
        borderRadius: BorderRadius.circular(999),
      ),
    );
  }
}

class _ForgotPasswordInputs extends StatelessWidget {
  const _ForgotPasswordInputs();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ForgotPasswordCubit, ForgotPasswordState>(
      buildWhen: (previous, current) =>
          previous.step != current.step || previous.status != current.status,
      builder: (context, state) {
        final children = <Widget>[const _EmailInput()];

        if (state.step == ForgotPasswordStep.verifyCode ||
            state.step == ForgotPasswordStep.newPassword) {
          children.addAll([
            const SizedBox(height: 16),
            const _VerificationCodeInput(),
          ]);
        }

        if (state.step == ForgotPasswordStep.newPassword) {
          children.addAll([const SizedBox(height: 16), const _PasswordInput()]);
        }

        return Column(children: children);
      },
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
