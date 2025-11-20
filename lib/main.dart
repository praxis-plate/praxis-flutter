import 'dart:async';

import 'package:codium/app/app.dart';
import 'package:codium/dependency_injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';

void main() {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);

      DependencyInjection().initialize();

      runApp(const App());
    },
    (Object error, StackTrace stack) {
      GetIt.I<Talker>().handle(error, stack);
    },
  );
}
