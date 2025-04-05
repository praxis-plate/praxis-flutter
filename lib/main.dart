import 'dart:async';

import 'package:codium/app/app.dart';
import 'package:codium/core/secrets/secrets.dart';
import 'package:codium/repositories/codium_auth/abstract_auth_repository.dart';
import 'package:codium/repositories/codium_auth/auth_repository.dart';
import 'package:codium/repositories/codium_courses/abstract_course_repository.dart';
import 'package:codium/repositories/codium_courses/course_repository.dart';
import 'package:codium/repositories/codium_user/abstract_user_repository.dart';
import 'package:codium/repositories/codium_user/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:talker_flutter/talker_flutter.dart';

void main() {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      final supabase = await Supabase.initialize(
        url: AppSecrets.supabaseUrl,
        anonKey: AppSecrets.supabaseAnonKey,
        authOptions: const FlutterAuthClientOptions(
          authFlowType: AuthFlowType.pkce,
        ),
        realtimeClientOptions: const RealtimeClientOptions(
          logLevel: RealtimeLogLevel.info,
        ),
        storageOptions: const StorageClientOptions(
          retryAttempts: 10,
        ),
      );
      GetIt.I.registerLazySingleton(() => supabase.client);

      GetIt.I.registerSingleton(TalkerFlutter.init());

      GetIt.I.registerLazySingleton<IAuthRepository>(
        () => AuthRepository(supabaseClient: GetIt.I<SupabaseClient>()),
      );

      GetIt.I.registerLazySingleton<ICourseRepository>(
        () => CourseRepository(),
      );
      GetIt.I.registerLazySingleton<IUserRepository>(
        () => UserRepository(courseRepository: GetIt.I<ICourseRepository>()),
      );

      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);

      runApp(const App());
    },
    (Object error, StackTrace stack) {
      GetIt.I<Talker>().handle(error, stack);
    },
  );
}
