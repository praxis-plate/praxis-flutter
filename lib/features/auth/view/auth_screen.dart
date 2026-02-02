import 'package:codium/core/bloc/auth/auth_bloc.dart';
import 'package:codium/core/error/app_error_code_extension.dart';
import 'package:codium/features/auth/bloc/sign_in/sign_in_cubit.dart';
import 'package:codium/features/auth/bloc/sign_up/sign_up_cubit.dart';
import 'package:codium/features/auth/di/auth_feature_scope.dart';
import 'package:codium/features/auth/view/forgot_password_screen.dart';
import 'package:codium/features/auth/view/sign_in_screen.dart';
import 'package:codium/features/auth/view/sign_up_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

enum AuthMode {
  signIn('signIn'),
  signUp('signUp'),
  forgotPassword('forgotPassword');

  const AuthMode(this.value);

  final String value;

  static AuthMode fromParam(String? value) {
    if (value == null) {
      return AuthMode.signIn;
    }
    return AuthMode.values.firstWhere(
      (mode) => mode.value == value,
      orElse: () => AuthMode.signIn,
    );
  }
}

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key, this.initialMode = AuthMode.signIn});

  final AuthMode initialMode;

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  late AuthMode authMode = widget.initialMode;

  @override
  void didUpdateWidget(covariant AuthScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialMode != widget.initialMode) {
      setState(() => authMode = widget.initialMode);
    }
  }

  void _setMode(AuthMode mode) {
    if (authMode == mode) {
      return;
    }
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() => authMode = mode);
  }

  @override
  Widget build(BuildContext context) {
    return AuthFeatureScope(
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => GetIt.I<SignInCubit>()),
          BlocProvider(create: (context) => GetIt.I<SignUpCubit>()),
        ],
        child: BlocListener<AuthBloc, AuthState>(
          listenWhen: (previous, current) =>
              previous != current && current is AuthErrorState,
          listener: (context, state) {
            final errorState = state as AuthErrorState;
            _showError(context, errorState.errorCode.localizedMessage(context));
          },
          child: Stack(
            children: [
              _AnimatedAuthPane(
                isActive: authMode == AuthMode.signIn,
                child: SignInScreen(
                  onSwitchToSignUp: () => _setMode(AuthMode.signUp),
                  onSwitchToForgotPassword: () =>
                      _setMode(AuthMode.forgotPassword),
                ),
              ),
              _AnimatedAuthPane(
                isActive: authMode == AuthMode.signUp,
                child: SignUpScreen(
                  onSwitchToSignIn: () => _setMode(AuthMode.signIn),
                ),
              ),
              _AnimatedAuthPane(
                isActive: authMode == AuthMode.forgotPassword,
                child: ForgotPasswordScreen(
                  onSwitchToSignIn: () => _setMode(AuthMode.signIn),
                  onSwitchToSignUp: () => _setMode(AuthMode.signUp),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showError(BuildContext context, String message) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }
}

class _AnimatedAuthPane extends StatelessWidget {
  const _AnimatedAuthPane({required this.isActive, required this.child});

  final bool isActive;
  final Widget child;

  static const _duration = Duration(milliseconds: 400);

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !isActive,
      child: Semantics(
        hidden: !isActive,
        child: ExcludeSemantics(
          excluding: !isActive,
          child: FocusScope(
            canRequestFocus: isActive,
            descendantsAreFocusable: isActive,
            child: AnimatedOpacity(
              duration: _duration,
              curve: Curves.easeInQuad,
              opacity: isActive ? 1 : 0,
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
