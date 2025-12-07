import 'package:codium/core/bloc/auth/auth_bloc.dart';
import 'package:codium/core/bloc/user_profile/user_profile_bloc.dart';
import 'package:codium/core/widgets/widgets.dart';
import 'package:codium/features/auth/bloc/sign_in/sign_in_cubit.dart';
import 'package:codium/features/auth/widgets/widgets.dart';
import 'package:codium/s.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.I<SignInCubit>(),
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticatedState) {
            context.read<UserProfileBloc>().add(
              UserProfileLoadEvent(userId: state.userId),
            );
            context.go('/navigation');
            context.read<SignInCubit>().reset();
          } else if (state is AuthErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Theme.of(context).colorScheme.error,
                behavior: SnackBarBehavior.floating,
              ),
            );
            context.read<SignInCubit>().reset();
            context.read<AuthBloc>().add(const AuthResetErrorEvent());
          }
        },
        child: Scaffold(
          body: SafeArea(
            child: GestureDetector(
              onTap: FocusScope.of(context).unfocus,
              child: const Wrapper(
                child: Center(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: _SignInForm(),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SignInForm extends StatelessWidget {
  const _SignInForm();

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
            const SizedBox(height: 16),
            const _SubmitButton(),
            const SizedBox(height: 16),
            const _SignUpRedirect(),
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

    return BlocSelector<SignInCubit, SignInState, _PasswordState>(
      selector: (state) => _PasswordState(
        password: state.password,
        obscurePassword: state.obscurePassword,
        status: state.status,
      ),
      builder: (context, state) {
        final cubit = context.read<SignInCubit>();
        return AuthPasswordInput(
          errorText: state.password.stringDisplayError(s),
          enabled: state.status != FormzSubmissionStatus.inProgress,
          obscureText: state.obscurePassword,
          onChanged: cubit.passwordChanged,
          onToggleVisibility: cubit.togglePasswordVisibility,
        );
      },
    );
  }
}

class _PasswordState {
  final dynamic password;
  final bool obscurePassword;
  final FormzSubmissionStatus status;

  const _PasswordState({
    required this.password,
    required this.obscurePassword,
    required this.status,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _PasswordState &&
          password == other.password &&
          obscurePassword == other.obscurePassword &&
          status == other.status;

  @override
  int get hashCode =>
      password.hashCode ^ obscurePassword.hashCode ^ status.hashCode;
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

            return isLoading
                ? const CircularProgressIndicator()
                : SizedBox(
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

class _SignUpRedirect extends StatelessWidget {
  const _SignUpRedirect();

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return AuthRedirectText(
      questionText: s.displayDontHaveAnAccount,
      actionText: s.displaySignUp,
      route: '/sign-up',
    );
  }
}
