import 'dart:async';

import 'package:codium/core/bloc/achievement_notification/achievement_notification_cubit.dart';
import 'package:codium/core/bloc/auth/auth_bloc.dart';
import 'package:codium/core/bloc/user_profile/user_profile_bloc.dart';
import 'package:codium/core/config/env_config.dart';
import 'package:codium/core/services/ai_remote_service.dart';
import 'package:codium/core/services/session_service.dart';
import 'package:codium/data/database/app_database.dart';
import 'package:codium/data/datasources/datasources.dart';
import 'package:codium/data/repositories/repositories.dart';
import 'package:codium/data/repositories/task_repository.dart';
import 'package:codium/domain/datasources/datasources.dart';
import 'package:codium/domain/models/session/update_session_model.dart';
import 'package:codium/domain/repositories/i_task_repository.dart';
import 'package:codium/domain/repositories/repositories.dart';
import 'package:codium/domain/services/i_ai_service.dart';
import 'package:codium/domain/services/services.dart';
import 'package:codium/domain/usecases/lessons/get_lessons_by_course_id_usecase.dart';
import 'package:codium/domain/usecases/tasks/complete_lesson_session_usecase.dart';
import 'package:codium/domain/usecases/tasks/get_lesson_tasks_usecase.dart';
import 'package:codium/domain/usecases/tasks/get_task_by_id_usecase.dart';
import 'package:codium/domain/usecases/tasks/get_task_count_by_lesson_id_usecase.dart';
import 'package:codium/domain/usecases/tasks/request_task_hint_usecase.dart';
import 'package:codium/domain/usecases/tasks/submit_task_answer_usecase.dart';
import 'package:codium/domain/usecases/usecases.dart';
import 'package:codium/features/course_details/course_details.dart';
import 'package:codium/features/course_learning/bloc/bloc.dart';
import 'package:codium/features/learning/learning.dart';
import 'package:codium/features/lesson/bloc/lesson_content_bloc.dart';
import 'package:codium/features/main/main.dart';
import 'package:codium/features/onboarding/onboarding.dart';
import 'package:codium/features/tasks/bloc/lesson_task/lesson_task_session_bloc.dart';
import 'package:codium/features/tasks/bloc/task_hint/task_hint_cubit.dart';
import 'package:codium/features/tasks/renderers/default_task_renderer.dart';
import 'package:codium/features/tasks/renderers/task_renderer.dart';
import 'package:get_it/get_it.dart';
import 'package:praxis_client/praxis_client.dart';
import 'package:serverpod_auth_core_flutter/serverpod_auth_core_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talker_flutter/talker_flutter.dart';

class DependencyInjection {
  Future<void> initialize() async {
    GetIt.I.registerSingleton(TalkerFlutter.init());

    await _registerServices();
    await _registerServerpodClient();
    _registerDataSources();
    _registerRepositories();
    _registerUseCases();
    _registerBlocs();
    _registerTaskFeature();

    // Database seeding removed - data now comes from server
  }

  Future<void> _registerServices() async {
    final sharedPreferences = await SharedPreferences.getInstance();

    GetIt.I
      ..registerSingleton(sharedPreferences)
      ..registerLazySingleton<ISessionService>(
        () => SessionService(GetIt.I<SharedPreferences>()),
      );
  }

  Future<void> _registerServerpodClient() async {
    final sessionService = GetIt.I<ISessionService>();
    final client = Client(EnvConfig.serverpodHost);
    final authSessionManager = FlutterAuthSessionManager();
    authSessionManager.authInfoListenable.addListener(() {
      unawaited(_syncSessionFromAuthInfo(authSessionManager, sessionService));
    });
    client.authSessionManager = authSessionManager;
    await authSessionManager.restore();
    await _syncSessionFromAuthInfo(authSessionManager, sessionService);

    GetIt.I.registerLazySingleton<Client>(() => client);
  }

  Future<void> _syncSessionFromAuthInfo(
    FlutterAuthSessionManager authSessionManager,
    ISessionService sessionService,
  ) async {
    final authInfo = authSessionManager.authInfo;
    if (authInfo == null) {
      await sessionService.clearSession();
      return;
    }

    final session = await sessionService.getSession();
    if (session == null) {
      return;
    }

    final refreshToken = authInfo.refreshToken;
    final expiresAt = authInfo.tokenExpiresAt;
    if (refreshToken == null || expiresAt == null) {
      return;
    }

    await sessionService.updateTokens(
      UpdateSessionModel(
        accessToken: authInfo.token,
        refreshToken: refreshToken,
        tokenExpiresAt: expiresAt,
      ),
    );
  }

  void _registerDataSources() {
    GetIt.I
      ..registerLazySingleton<AppDatabase>(() {
        try {
          return AppDatabase();
        } catch (e, st) {
          GetIt.I<Talker>().error('Failed to initialize database', e, st);
          rethrow;
        }
      })
      // Keep user datasource local for now
      ..registerLazySingleton<IUserDataSource>(
        () => UserLocalDataSource(GetIt.I<AppDatabase>()),
      )
      // Use remote datasources
      ..registerLazySingleton<IAuthDataSource>(
        () => AuthRemoteDataSource(GetIt.I<Client>()),
      )
      ..registerLazySingleton<UserStatisticsRemoteDataSource>(
        () => UserStatisticsRemoteDataSource(GetIt.I<Client>()),
      )
      ..registerLazySingleton<CourseRemoteDataSource>(
        () => CourseRemoteDataSource(GetIt.I<Client>()),
      )
      ..registerLazySingleton<ModuleRemoteDataSource>(
        () => ModuleRemoteDataSource(GetIt.I<Client>()),
      )
      ..registerLazySingleton<LessonRemoteDataSource>(
        () => LessonRemoteDataSource(GetIt.I<Client>()),
      )
      ..registerLazySingleton<LessonProgressRemoteDataSource>(
        () => LessonProgressRemoteDataSource(GetIt.I<Client>()),
      )
      ..registerLazySingleton<AchievementRemoteDataSource>(
        () => AchievementRemoteDataSource(GetIt.I<Client>()),
      )
      ..registerLazySingleton<CoinTransactionRemoteDataSource>(
        () => CoinTransactionRemoteDataSource(GetIt.I<Client>()),
      );
  }

  void _registerRepositories() {
    GetIt.I
      ..registerLazySingleton<AuthSessionRemoteDataSource>(
        () => AuthSessionRemoteDataSource(GetIt.I<Client>()),
      )
      ..registerLazySingleton<IAuthRepository>(
        () => AuthRepository(
          GetIt.I<IAuthDataSource>(),
          GetIt.I<ISessionService>(),
          GetIt.I<AuthSessionRemoteDataSource>(),
        ),
      )
      ..registerLazySingleton<ICourseRepository>(
        () => CourseRepository(GetIt.I<CourseRemoteDataSource>()),
      )
      ..registerLazySingleton<IUserRepository>(
        () => UserRepository(
          GetIt.I<IUserDataSource>(),
          GetIt.I<ISessionService>(),
        ),
      )
      ..registerLazySingleton<IUserStatisticsRepository>(
        () =>
            UserStatisticsRepository(GetIt.I<UserStatisticsRemoteDataSource>()),
      )
      ..registerLazySingleton<IModuleRepository>(
        () => ModuleRepository(GetIt.I<ModuleRemoteDataSource>()),
      )
      ..registerLazySingleton<ILessonRepository>(
        () => LessonRepository(GetIt.I<LessonRemoteDataSource>()),
      )
      ..registerLazySingleton<ILessonProgressRepository>(
        () => LessonProgressRepository(GetIt.I<LessonRemoteDataSource>()),
      )
      ..registerLazySingleton<IAchievementRepository>(
        () => AchievementRepository(GetIt.I<AchievementRemoteDataSource>()),
      )
      ..registerLazySingleton<ICoinTransactionRepository>(
        () => CoinTransactionRepository(
          GetIt.I<CoinTransactionRemoteDataSource>(),
        ),
      );
  }

  void _registerUseCases() {
    GetIt.I
      ..registerFactory(
        () => CheckAuthStatusUseCase(
          GetIt.I<IAuthRepository>(),
          GetIt.I<IUserRepository>(),
        ),
      )
      ..registerFactory(() => SignInUseCase(GetIt.I<IAuthRepository>()))
      ..registerFactory(
        () => StartRegistrationUseCase(GetIt.I<IAuthRepository>()),
      )
      ..registerFactory(
        () => VerifyRegistrationCodeUseCase(GetIt.I<IAuthRepository>()),
      )
      ..registerFactory(
        () => StartPasswordResetUseCase(GetIt.I<IAuthRepository>()),
      )
      ..registerFactory(
        () => VerifyPasswordResetCodeUseCase(GetIt.I<IAuthRepository>()),
      )
      ..registerFactory(
        () => FinishPasswordResetUsecase(GetIt.I<IAuthRepository>()),
      )
      ..registerFactory(() => SignUpUseCase(GetIt.I<IAuthRepository>()))
      ..registerFactory(() => SignOutUseCase(GetIt.I<IAuthRepository>()))
      ..registerFactory(() => GetProfileUseCase(GetIt.I<IUserRepository>()))
      ..registerFactory(
        () => GetFullUserProfileUseCase(
          GetIt.I<IUserStatisticsRepository>(),
          GetIt.I<ICourseRepository>(),
        ),
      )
      ..registerFactory(() => GetCoursesUseCase(GetIt.I<ICourseRepository>()))
      ..registerFactory(
        () => GetMainCarouselCoursesUseCase(GetIt.I<ICourseRepository>()),
      )
      ..registerFactory(
        () => GetUserStatisticsUseCase(GetIt.I<IUserStatisticsRepository>()),
      )
      ..registerFactory(() => GenerateActivityUsecase())
      ..registerFactory(
        () => GetCourseDetailUseCase(GetIt.I<ICourseRepository>()),
      )
      ..registerFactory(
        () => GetCourseTableOfContentsUseCase(GetIt.I<ICourseRepository>()),
      )
      ..registerFactory(
        () => GetLearningDataUseCase(
          GetIt.I<IUserStatisticsRepository>(),
          GetIt.I<GenerateActivityUsecase>(),
        ),
      )
      ..registerFactory(
        () => PurchaseCourseUseCase(
          courseRepository: GetIt.I<ICourseRepository>(),
          userStatisticsRepository: GetIt.I<IUserStatisticsRepository>(),
          coinTransactionRepository: GetIt.I<ICoinTransactionRepository>(),
        ),
      )
      ..registerFactory(
        () => GetEnrolledCoursesUseCase(
          courseRepository: GetIt.I<ICourseRepository>(),
        ),
      )
      ..registerFactory(
        () => CheckCourseEnrollmentUseCase(
          courseRepository: GetIt.I<ICourseRepository>(),
        ),
      )
      ..registerFactory(
        () => GetRecommendedCoursesUseCase(GetIt.I<ICourseRepository>()),
      )
      ..registerFactory(
        () => CompleteLessonUseCase(
          lessonProgressRepository: GetIt.I<ILessonProgressRepository>(),
        ),
      )
      ..registerFactory(
        () => GetLessonByIdUseCase(GetIt.I<ILessonRepository>()),
      )
      ..registerFactory(
        () => GetUserProfileDataUseCase(
          userRepository: GetIt.I<IUserRepository>(),
          userStatisticsRepository: GetIt.I<IUserStatisticsRepository>(),
          achievementRepository: GetIt.I<IAchievementRepository>(),
        ),
      )
      ..registerFactory(
        () => CheckStreakAndAwardAchievementUseCase(
          userStatisticsRepository: GetIt.I<IUserStatisticsRepository>(),
          achievementRepository: GetIt.I<IAchievementRepository>(),
        ),
      )
      ..registerFactory(
        () => GetLessonsByCourseIdUseCase(GetIt.I<ILessonRepository>()),
      )
      ..registerFactory(
        () => GetTaskCountByLessonIdUseCase(GetIt.I<ITaskRepository>()),
      );
  }

  void _registerBlocs() {
    GetIt.I
      ..registerLazySingleton(
        () => AuthBloc(
          signUpUseCase: GetIt.I<SignUpUseCase>(),
          signInUseCase: GetIt.I<SignInUseCase>(),
          signOutUseCase: GetIt.I<SignOutUseCase>(),
        ),
      )
      ..registerLazySingleton(
        () => UserProfileBloc(
          getFullUserProfileUseCase: GetIt.I<GetFullUserProfileUseCase>(),
        ),
      )
      ..registerFactory(
        () => MainBloc(
          getCoursesUseCase: GetIt.I<GetCoursesUseCase>(),
          getEnrolledCoursesUseCase: GetIt.I<GetEnrolledCoursesUseCase>(),
        ),
      )
      ..registerFactory(
        () => MainCarouselBloc(
          getMainCarouselCoursesUseCase:
              GetIt.I<GetMainCarouselCoursesUseCase>(),
        ),
      )
      ..registerLazySingleton(
        () => UserStatisticsBloc(
          getUserStatisticsUseCase: GetIt.I<GetUserStatisticsUseCase>(),
        ),
      )
      ..registerFactory(
        () => LearningBloc(
          getLearningDataUseCase: GetIt.I<GetLearningDataUseCase>(),
          getEnrolledCoursesUseCase: GetIt.I<GetEnrolledCoursesUseCase>(),
        ),
      )
      ..registerFactory<CourseDetailBloc>(
        () => CourseDetailBloc(
          getCourseDetailUseCase: GetIt.I<GetCourseDetailUseCase>(),
          checkCourseEnrollmentUseCase: GetIt.I<CheckCourseEnrollmentUseCase>(),
          getTableOfContentsUseCase: GetIt.I<GetCourseTableOfContentsUseCase>(),
        ),
      )
      ..registerLazySingleton(
        () => CoursePurchasingBloc(
          purchaseCourseUseCase: GetIt.I<PurchaseCourseUseCase>(),
        ),
      )
      ..registerFactory(
        () => RecommendBloc(
          getRecommendedCoursesUseCase: GetIt.I<GetRecommendedCoursesUseCase>(),
        ),
      )
      ..registerFactory(() => OnboardingBloc())
      ..registerFactory(
        () => CourseLearningBloc(
          getCourseDetailUseCase: GetIt.I<GetCourseDetailUseCase>(),
        ),
      )
      ..registerFactory(
        () => LessonsListBloc(GetIt.I<GetLessonsByCourseIdUseCase>()),
      )
      ..registerFactory(
        () => LessonContentBloc(
          getLessonByIdUseCase: GetIt.I<GetLessonByIdUseCase>(),
          completeLessonUseCase: GetIt.I<CompleteLessonUseCase>(),
        ),
      )
      ..registerLazySingleton(() => AchievementNotificationCubit());
  }

  void _registerTaskFeature() {
    GetIt.I
      ..registerLazySingleton<IAiService>(
        () => AiRemoteService(GetIt.I<Client>()),
      )
      ..registerLazySingleton<TaskRemoteDataSource>(
        () => TaskRemoteDataSource(GetIt.I<Client>()),
      )
      ..registerLazySingleton<TaskLocalDataSource>(
        () => TaskLocalDataSource(GetIt.I<AppDatabase>()),
      )
      ..registerLazySingleton<ITaskRepository>(
        () => TaskRepository(
          GetIt.I<TaskRemoteDataSource>(),
          GetIt.I<TaskLocalDataSource>(),
        ),
      )
      ..registerLazySingleton<TaskRenderer>(() => const DefaultTaskRenderer())
      ..registerFactory(() => GetLessonTasksUseCase(GetIt.I<ITaskRepository>()))
      ..registerFactory(() => GetTaskByIdUseCase(GetIt.I<ITaskRepository>()))
      ..registerFactory(
        () => SubmitTaskAnswerUseCase(
          GetIt.I<ITaskRepository>(),
          GetIt.I<ICoinTransactionRepository>(),
        ),
      )
      ..registerFactory(
        () => RequestTaskHintUseCase(
          GetIt.I<ITaskRepository>(),
          GetIt.I<IAiService>(),
        ),
      )
      ..registerFactoryParam<TaskHintCubit, String, void>(
        (userId, _) => TaskHintCubit(GetIt.I<RequestTaskHintUseCase>(), userId),
      )
      ..registerFactory<CompleteLessonSessionUseCase>(
        () => CompleteLessonSessionUseCase(
          GetIt.I<ILessonProgressRepository>(),
          GetIt.I<ICoinTransactionRepository>(),
        ),
      )
      ..registerFactory<LessonTaskSessionBloc>(
        () => LessonTaskSessionBloc(
          GetIt.I<GetLessonTasksUseCase>(),
          GetIt.I<CompleteLessonSessionUseCase>(),
        ),
      );
  }
}
