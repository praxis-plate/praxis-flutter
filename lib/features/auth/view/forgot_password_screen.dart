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
            current.status == FormzSubmissionStatus.success,
        listener: (context, state) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(s.displayResetLinkSent),
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
          );
          context.read<ForgotPasswordCubit>().reset();
        },
        child: Scaffold(
          body: Stack(
            children: [
              const AnimatedBubbleBackground(),
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
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            const _EmailInput(),
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
          enabled: state.status != FormzSubmissionStatus.inProgress,
          onChanged: context.read<ForgotPasswordCubit>().emailChanged,
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

        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: state.isValid
                ? context.read<ForgotPasswordCubit>().submit
                : null,
            child: Text(S.of(context).displaySendResetLink),
          ),
        );
      },
    );
  }
}
