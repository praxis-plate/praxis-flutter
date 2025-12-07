import 'dart:async';

import 'package:codium/app/app.dart';
import 'package:codium/core/bloc/auth/auth_bloc.dart';
import 'package:codium/core/router/router.dart';
import 'package:codium/dependency_injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_bloc_logger/talker_bloc_logger.dart';
import 'package:talker_flutter/talker_flutter.dart';

void main() {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);

      await DependencyInjection().initialize();

      Bloc.observer = TalkerBlocObserver(
        talker: GetIt.I<Talker>(),
        settings: const TalkerBlocLoggerSettings(
          enabled: true,
          printEvents: true,
          printTransitions: true,
          printChanges: true,
          printCreations: true,
          printClosings: true,
        ),
      );

      AppRouter.initialize();

      GetIt.I<AuthBloc>().add(const AuthCheckStatusEvent());

      runApp(const App());
    },
    (Object error, StackTrace stack) {
      GetIt.I<Talker>().handle(error, stack);
    },
  );
}
