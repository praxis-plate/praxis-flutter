import 'package:codium/core/bloc/achievement_notification/achievement_notification_cubit.dart';
import 'package:codium/core/bloc/auth/auth_bloc.dart';
import 'package:codium/core/bloc/user_profile/user_profile_bloc.dart';
import 'package:codium/core/config/env_config.dart';
import 'package:codium/core/config/dio_factory.dart';
import 'package:codium/core/services/ai_service.dart';
import 'package:codium/core/services/session_service.dart';
import 'package:codium/data/database/app_database.dart';
import 'package:codium/data/database/database_seeder.dart';
import 'package:codium/data/datasources/datasources.dart';
import 'package:codium/data/datasources/local/task_local_datasource.dart';
import 'package:codium/data/repositories/repositories.dart';
import 'package:codium/data/repositories/task_repository.dart';
import 'package:codium/domain/datasources/datasources.dart';
import 'package:codium/domain/datasources/i_task_local_datasource.dart';
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
import 'package:codium/features/course_learning/bloc/course_learning_bloc.dart';
import 'package:codium/features/course_learning/bloc/lessons_list_bloc.dart';
import 'package:codium/features/learning/learning.dart';
import 'package:codium/features/lesson/bloc/lesson_content_bloc.dart';
import 'package:codium/features/main/main.dart';
import 'package:codium/features/onboarding/onboarding.dart';
import 'package:codium/features/tasks/bloc/lesson_task/lesson_task_session_bloc.dart';
import 'package:codium/features/tasks/bloc/task_hint/task_hint_cubit.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:praxis_client/praxis_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talker_flutter/talker_flutter.dart';

class DependencyInjection {
  Future<void> initialize() async {
    GetIt.I.registerSingleton(TalkerFlutter.init());

    _registerServerpodClient();
    await _registerServices();
    _registerDataSources();
    _registerRepositories();
    _registerUseCases();
    _registerBlocs();
    _registerTaskFeature();

    await _seedDatabaseIfNeeded();
  }

  Future<void> _seedDatabaseIfNeeded() async {
    try {
      final db = GetIt.I<AppDatabase>();
      final userDataSource = GetIt.I<IUserDataSource>();
      final seeder = DatabaseSeeder(db, userDataSource);

      final existingUsers = await db.managers.user.count();

      if (existingUsers == 0) {
        GetIt.I<Talker>().info('Database is empty, seeding...');
        await seeder.seed();
        GetIt.I<Talker>().info('Database seeded successfully');
      } else {
        GetIt.I<Talker>().info(
          'Database already contains $existingUsers users',
        );
      }

      await seeder.ensureTestUser();
    } catch (e, st) {
      GetIt.I<Talker>().error('Failed to seed database', e, st);
    }
  }

  Future<void> _registerServices() async {
    final sharedPreferences = await SharedPreferences.getInstance();

    GetIt.I
      ..registerSingleton(sharedPreferences)
      ..registerLazySingleton<ISessionService>(
        () => SessionService(GetIt.I<SharedPreferences>()),
      );
  }

  void _registerServerpodClient() {
    GetIt.I.registerLazySingleton<Client>(
      () => Client(EnvConfig.serverpodHost),
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
      ..registerLazySingleton<IUserDataSource>(
        () => UserLocalDataSource(GetIt.I<AppDatabase>()),
      )
      ..registerLazySingleton<IAuthDataSource>(
        () => AuthRemoteDataSource(GetIt.I<Client>()),
      )
      ..registerLazySingleton<IExplanationLocalDataSource>(
        () => ExplanationLocalDataSource(GetIt.I<AppDatabase>()),
      )
      ..registerLazySingleton<IUserStatisticsLocalDataSource>(
        () => UserStatisticsLocalDataSource(GetIt.I<AppDatabase>()),
      )
      ..registerLazySingleton<ICourseLocalDataSource>(
        () => CourseLocalDataSource(GetIt.I<AppDatabase>()),
      )
      ..registerLazySingleton<IModuleLocalDataSource>(
        () => ModuleLocalDataSource(GetIt.I<AppDatabase>()),
      )
      ..registerLazySingleton<ILessonLocalDataSource>(
        () => LessonLocalDataSource(GetIt.I<AppDatabase>()),
      )
      ..registerLazySingleton<ILessonProgressLocalDataSource>(
        () => LessonProgressLocalDataSource(GetIt.I<AppDatabase>()),
      )
      ..registerLazySingleton<IAchievementLocalDataSource>(
        () => AchievementLocalDataSource(GetIt.I<AppDatabase>()),
      )
      ..registerLazySingleton<ICoinTransactionLocalDataSource>(
        () => CoinTransactionLocalDataSource(GetIt.I<AppDatabase>()),
      );
  }

  void _registerRepositories() {
    GetIt.I
      ..registerLazySingleton<IAuthRepository>(
        () => AuthRepository(
          GetIt.I<IAuthDataSource>(),
          GetIt.I<ISessionService>(),
        ),
      )
      ..registerLazySingleton<ICourseRepository>(
        () => CourseRepository(GetIt.I<ICourseLocalDataSource>()),
      )
      ..registerLazySingleton<IUserRepository>(
        () => UserRepository(
          GetIt.I<IUserDataSource>(),
          GetIt.I<ISessionService>(),
        ),
      )
      ..registerLazySingleton<IUserStatisticsRepository>(
        () =>
            UserStatisticsRepository(GetIt.I<IUserStatisticsLocalDataSource>()),
      )
      ..registerLazySingleton<IExplanationRepository>(
        () => ExplanationRepository(GetIt.I<IExplanationLocalDataSource>()),
      )
      ..registerLazySingleton<IModuleRepository>(
        () => ModuleRepository(GetIt.I<IModuleLocalDataSource>()),
      )
      ..registerLazySingleton<ILessonRepository>(
        () => LessonRepository(GetIt.I<ILessonLocalDataSource>()),
      )
      ..registerLazySingleton<ILessonProgressRepository>(
        () =>
            LessonProgressRepository(GetIt.I<ILessonProgressLocalDataSource>()),
      )
      ..registerLazySingleton<IAchievementRepository>(
        () => AchievementRepository(GetIt.I<IAchievementLocalDataSource>()),
      )
      ..registerLazySingleton<ICoinTransactionRepository>(
        () => CoinTransactionRepository(
          GetIt.I<ICoinTransactionLocalDataSource>(),
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
        () => SignUpUseCase(
          GetIt.I<IAuthRepository>(),
          GetIt.I<ICoinTransactionRepository>(),
        ),
      )
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
        () => ExplainTextUseCase(GetIt.I<IExplanationRepository>()),
      )
      ..registerFactory(
        () => GetExplanationHistoryUseCase(GetIt.I<IExplanationRepository>()),
      )
      ..registerFactory(
        () =>
            SearchExplanationHistoryUseCase(GetIt.I<IExplanationRepository>()),
      )
      ..registerFactory(
        () => DeleteExplanationUseCase(GetIt.I<IExplanationRepository>()),
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
          courseRepository: GetIt.I<ICourseRepository>(),
          lessonProgressRepository: GetIt.I<ILessonProgressRepository>(),
        ),
      )
      ..registerFactory(
        () => LessonsListBloc(GetIt.I<GetLessonsByCourseIdUseCase>()),
      )
      ..registerFactory(
        () => LessonContentBloc(
          lessonRepository: GetIt.I<ILessonRepository>(),
          lessonProgressRepository: GetIt.I<ILessonProgressRepository>(),
          completeLessonUseCase: GetIt.I<CompleteLessonUseCase>(),
        ),
      )
      ..registerLazySingleton(() => AchievementNotificationCubit());
  }

  void _registerTaskFeature() {
    GetIt.I
      ..registerLazySingleton<Dio>(() => DioFactory.createDefaultDio())
      ..registerLazySingleton<IAiService>(
        () => AiService(dio: DioFactory.createGeminiDio()),
      )
      ..registerLazySingleton<ITaskLocalDataSource>(
        () => TaskLocalDataSource(GetIt.I<AppDatabase>()),
      )
      ..registerLazySingleton<ITaskRepository>(
        () => TaskRepository(GetIt.I<ITaskLocalDataSource>()),
      )
      ..registerFactory(() => GetLessonTasksUseCase(GetIt.I<ITaskRepository>()))
      ..registerFactory(() => GetTaskByIdUseCase(GetIt.I<ITaskRepository>()))
      ..registerFactory(
        () => SubmitTaskAnswerUseCase(
          GetIt.I<ITaskRepository>(),
          GetIt.I<IUserStatisticsRepository>(),
          GetIt.I<ICoinTransactionRepository>(),
        ),
      )
      ..registerFactory(
        () => RequestTaskHintUseCase(
          GetIt.I<ITaskRepository>(),
          GetIt.I<IAiService>(),
        ),
      )
      ..registerFactoryParam<TaskHintCubit, int, void>(
        (userId, _) => TaskHintCubit(GetIt.I<RequestTaskHintUseCase>(), userId),
      )
      ..registerFactory<CompleteLessonSessionUseCase>(
        () => CompleteLessonSessionUseCase(
          GetIt.I<ILessonProgressRepository>(),
          GetIt.I<IUserStatisticsRepository>(),
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
