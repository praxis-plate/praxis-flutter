import 'dart:async';

import 'package:codium/core/bloc/auth/auth_bloc.dart';
import 'package:codium/features/auth/bloc/forgot_password/forgot_password_cubit.dart';
import 'package:codium/features/auth/bloc/sign_in/sign_in_cubit.dart';
import 'package:codium/features/auth/bloc/sign_up/sign_up_cubit.dart';
import 'package:codium/domain/repositories/i_auth_repository.dart';
import 'package:codium/domain/usecases/auth/start_registration_usecase.dart';
import 'package:codium/domain/usecases/auth/verify_registration_code_usecase.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';

class AuthFeatureScope extends StatefulWidget {
  const AuthFeatureScope({super.key, required this.child});

  final Widget child;

  @override
  State<AuthFeatureScope> createState() => _AuthFeatureScopeState();
}

class _AuthFeatureScopeState extends State<AuthFeatureScope> {
  static const String _scopeName = 'auth-feature-scope';
  var _scopePushed = false;

  @override
  void initState() {
    super.initState();
    GetIt.I.pushNewScope(
      scopeName: _scopeName,
      init: (getIt) {
        _scopePushed = true;
        getIt
          ..registerFactory<ForgotPasswordCubit>(
            () => ForgotPasswordCubit(authRepository: getIt<IAuthRepository>()),
          )
          ..registerFactory<SignInCubit>(
            () => SignInCubit(authBloc: getIt<AuthBloc>()),
          )
          ..registerFactory<SignUpCubit>(
            () => SignUpCubit(
              authBloc: getIt<AuthBloc>(),
              startRegistrationUseCase: getIt<StartRegistrationUseCase>(),
              verifyRegistrationCodeUseCase:
                  getIt<VerifyRegistrationCodeUseCase>(),
            ),
          );
      },
    );
  }

  @override
  void dispose() {
    if (_scopePushed) {
      unawaited(GetIt.I.popScopesTill(_scopeName));
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
