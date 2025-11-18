import 'package:codium/core/bloc/auth/auth_bloc.dart';
import 'package:codium/core/widgets/wrapper.dart';
import 'package:codium/features/auth/bloc/sign_in/sign_in_cubit.dart';
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
            context.go('/home');
            context.read<SignInCubit>().reset();
          }
        },
        child: Scaffold(
          appBar: AppBar(backgroundColor: Colors.black),
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
    final theme = Theme.of(context);

    return Form(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            S.of(context).displaySignIn,
            style: theme.textTheme.displayLarge,
          ),
          const SizedBox(height: 32),
          const _EmailInput(),
          const SizedBox(height: 16),
          const _PasswordInput(),
          const SizedBox(height: 16),
          const _SubmitButton(),
          const SizedBox(height: 16),
          const _SignUpRedirect(),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _EmailInput extends StatelessWidget {
  const _EmailInput();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<SignInCubit, SignInState>(
      buildWhen: (previous, current) =>
          previous.email != current.email || previous.status != current.status,
      builder: (context, state) {
        return TextFormField(
          enabled: state.status != FormzSubmissionStatus.inProgress,
          keyboardType: TextInputType.emailAddress,
          style: theme.textTheme.bodyMedium,
          decoration: InputDecoration(
            labelText: S.of(context).labelEmail,
            hintText: S.of(context).displayEmailHint,
            errorText: state.email.stringDisplayError(S.of(context)),
          ),
          onChanged: (value) => context.read<SignInCubit>().emailChanged(value),
        );
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  const _PasswordInput();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cubit = context.read<SignInCubit>();

    return BlocBuilder<SignInCubit, SignInState>(
      buildWhen: (previous, current) =>
          previous.password != current.password ||
          previous.obscurePassword != current.obscurePassword,
      builder: (context, state) {
        return TextFormField(
          enabled: state.status != FormzSubmissionStatus.inProgress,
          obscureText: state.obscurePassword,
          style: theme.textTheme.bodyMedium,
          decoration: InputDecoration(
            labelText: S.of(context).labelPassword,
            hintText: S.of(context).displayPasswordHint,
            errorText: state.password.stringDisplayError(S.of(context)),
            suffixIcon: _PasswordVisibilityButton(
              visible: !state.obscurePassword,
              onPressed: cubit.togglePasswordVisibility,
              enabled: state.status != FormzSubmissionStatus.inProgress,
            ),
          ),
          onChanged: (value) =>
              context.read<SignInCubit>().passwordChanged(value),
        );
      },
    );
  }
}

class _PasswordVisibilityButton extends StatelessWidget {
  final bool visible;
  final VoidCallback onPressed;
  final bool enabled;

  const _PasswordVisibilityButton({
    required this.visible,
    required this.onPressed,
    required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return IconButton(
      icon: Icon(
        visible ? Icons.visibility_off : Icons.visibility,
        color: theme.colorScheme.onSurfaceVariant,
      ),
      color: enabled
          ? Theme.of(context).colorScheme.onSurface
          : Theme.of(context).disabledColor,
      splashRadius: 20,
      padding: const EdgeInsets.only(right: 16),
      onPressed: enabled ? onPressed : null,
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

            return isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: formState.isValid
                        ? () => _handleSignIn(context, formState)
                        : null,
                    child: Text(S.of(context).displaySignIn),
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
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => context.go('/sign-up'),
      child: RichText(
        text: TextSpan(
          style: theme.textTheme.bodySmall,
          text: S.of(context).displayDontHaveAnAccount,
          children: [
            TextSpan(
              text: ' ${S.of(context).displaySignUp}',
              style: theme.textTheme.titleSmall?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
