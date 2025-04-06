import 'package:codium/core/bloc/auth/auth_bloc.dart';
import 'package:codium/features/auth/widgets/auth_button.dart';
import 'package:codium/features/auth/widgets/auth_field.dart';
import 'package:codium/features/auth/widgets/password_field.dart';
import 'package:codium/s.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticatedState) {
          context.go('/home');
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: GestureDetector(
            onTap: FocusScope.of(context).unfocus,
            child: const Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: _SignUpForm(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SignUpForm extends StatefulWidget {
  const _SignUpForm();

  @override
  State<_SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<_SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _passwordConfirmController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _passwordConfirmController = TextEditingController();
    context.read<AuthBloc>().add(AuthCheckStatus());
  }

  void _signUp() {
    final email = _emailController.text;
    final password = _passwordController.text;
    context.read<AuthBloc>().add(
          AuthSignUpEvent(email: email, password: password),
        );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthLoadingState) {
          return const Center(child: CircularProgressIndicator());
        }

        return Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                S.of(context).displaySignUp,
                style: theme.textTheme.displayLarge,
              ),
              const SizedBox(height: 32),
              AuthField(
                controller: _emailController,
                labelText: S.of(context).labelEmail,
                hintText: S.of(context).displayEmailHint,
                textInputType: TextInputType.emailAddress,
                errorText: S.of(context).errorEmail,
              ),
              PasswordField(
                controller: _passwordController,
                labelText: S.of(context).labelPassword,
                hintText: S.of(context).displayPasswordHint,
                isObscure: true,
                errorText: S.of(context).errorPasswordRequires,
              ),
              const SizedBox(height: 16),
              AuthButton(
                onPressed: _signUp,
                text: S.of(context).displaySignUp,
              ),
              GestureDetector(
                onTap: () {
                  context.go('/sign-in');
                },
                child: RichText(
                  text: TextSpan(
                    style: theme.textTheme.bodySmall,
                    text: S.of(context).displayAlreadyHaveAnAccount,
                    children: [
                      TextSpan(
                        text: ' ${S.of(context).displaySignIn}',
                        style: theme.textTheme.titleSmall,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        );
      },
    );
  }
}
