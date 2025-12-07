import 'package:codium/core/bloc/achievement_notification/achievement_notification_cubit.dart';
import 'package:codium/core/bloc/auth/auth_bloc.dart';
import 'package:codium/core/bloc/user_profile/user_profile_bloc.dart';
import 'package:codium/core/services/mock_connectivity_service.dart';
import 'package:codium/core/services/session_service.dart';
import 'package:codium/data/database/app_database.dart';
import 'package:codium/data/database/database_seeder.dart';
import 'package:codium/data/datasources/datasources.dart';
import 'package:codium/data/repositories/repositories.dart';
import 'package:codium/domain/datasources/datasources.dart';
import 'package:codium/domain/repositories/repositories.dart';
import 'package:codium/domain/services/services.dart';
import 'package:codium/domain/usecases/usecases.dart';
import 'package:codium/features/ai_explanation/ai_explanation.dart';
import 'package:codium/features/auth/auth.dart';
import 'package:codium/features/course_details/course_details.dart';
import 'package:codium/features/course_learning/bloc/course_learning_bloc.dart';
import 'package:codium/features/explanation_history/explanation_history.dart';
import 'package:codium/features/learning/learning.dart';
import 'package:codium/features/lesson/bloc/lesson_content_bloc.dart';
import 'package:codium/features/library/library.dart';
import 'package:codium/features/main/main.dart';
import 'package:codium/features/onboarding/onboarding.dart';
import 'package:codium/features/pdf_reader/pdf_reader.dart';
import 'package:codium/features/profile/profile.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talker_flutter/talker_flutter.dart';

class DependencyInjection {
  Future<void> initialize() async {
    GetIt.I.registerSingleton(TalkerFlutter.init());

    await _registerServices();
    _registerDataSources();
    _registerRepositories();
    _registerUseCases();
    _registerBlocs();

    await _seedDatabaseIfNeeded();
  }

  Future<void> _seedDatabaseIfNeeded() async {
    try {
      final db = GetIt.I<AppDatabase>();
      final userDataSource = GetIt.I<IUserDataSource>();

      final existingUsers = await db.managers.user.count();

      if (existingUsers == 0) {
        GetIt.I<Talker>().info('Database is empty, seeding...');
        final seeder = DatabaseSeeder(db, userDataSource);
        await seeder.seed();
        GetIt.I<Talker>().info('Database seeded successfully');
      } else {
        GetIt.I<Talker>().info(
          'Database already contains $existingUsers users',
        );
      }
    } catch (e, st) {
      GetIt.I<Talker>().error('Failed to seed database', e, st);
    }
  }

  Future<void> _registerServices() async {
    final sharedPreferences = await SharedPreferences.getInstance();

    GetIt.I
      ..registerSingleton(sharedPreferences)
      ..registerLazySingleton<IConnectivityService>(
        () => MockConnectivityService(),
      )
      ..registerLazySingleton<ISessionService>(
        () => SessionService(GetIt.I<SharedPreferences>()),
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
      ..registerLazySingleton<IPdfLocalDataSource>(
        () => PdfLocalDataSource(GetIt.I<AppDatabase>()),
      )
      ..registerLazySingleton<IBookmarkLocalDataSource>(
        () => BookmarkLocalDataSource(GetIt.I<AppDatabase>()),
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
          GetIt.I<IUserDataSource>(),
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
      ..registerLazySingleton<IPdfRepository>(
        () => PdfRepository(GetIt.I<IPdfLocalDataSource>()),
      )
      ..registerLazySingleton<IBookmarkRepository>(
        () => BookmarkRepository(GetIt.I<IBookmarkLocalDataSource>()),
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
      ..registerFactory(() => GetPdfListUseCase(GetIt.I<IPdfRepository>()))
      ..registerFactory(() => ImportPdfUseCase(GetIt.I<IPdfRepository>()))
      ..registerFactory(() => DeletePdfUseCase(GetIt.I<IPdfRepository>()))
      ..registerFactory(
        () => ToggleFavoritePdfUseCase(GetIt.I<IPdfRepository>()),
      )
      ..registerFactory(() => GetPdfBookByIdUseCase(GetIt.I<IPdfRepository>()))
      ..registerFactory(
        () => ValidateAndOpenPdfUseCase(GetIt.I<IPdfRepository>()),
      )
      ..registerFactory(
        () => UpdateReadingProgressUseCase(GetIt.I<IPdfRepository>()),
      )
      ..registerFactory(
        () => SaveBookmarkUseCase(GetIt.I<IBookmarkRepository>()),
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
      );
  }

  void _registerBlocs() {
    GetIt.I
      ..registerLazySingleton(
        () => AuthBloc(
          checkAuthStatusUseCase: GetIt.I<CheckAuthStatusUseCase>(),
          signInUseCase: GetIt.I<SignInUseCase>(),
          signUpUseCase: GetIt.I<SignUpUseCase>(),
          signOutUseCase: GetIt.I<SignOutUseCase>(),
        ),
      )
      ..registerLazySingleton(
        () => UserProfileBloc(
          getFullUserProfileUseCase: GetIt.I<GetFullUserProfileUseCase>(),
        ),
      )
      ..registerFactory(
        () => ProfileBloc(
          getProfileUseCase: GetIt.I<GetProfileUseCase>(),
          getUserProfileDataUseCase: GetIt.I<GetUserProfileDataUseCase>(),
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
      ..registerFactory(
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
      ..registerFactory(() => SignUpCubit())
      ..registerFactory(() => SignInCubit())
      ..registerFactory(
        () => LibraryBloc(
          getPdfListUseCase: GetIt.I<GetPdfListUseCase>(),
          importPdfUseCase: GetIt.I<ImportPdfUseCase>(),
          deletePdfUseCase: GetIt.I<DeletePdfUseCase>(),
          toggleFavoritePdfUseCase: GetIt.I<ToggleFavoritePdfUseCase>(),
        ),
      )
      ..registerFactory(
        () => PdfReaderBloc(
          validateAndOpenPdfUseCase: GetIt.I<ValidateAndOpenPdfUseCase>(),
          updateReadingProgressUseCase: GetIt.I<UpdateReadingProgressUseCase>(),
          saveBookmarkUseCase: GetIt.I<SaveBookmarkUseCase>(),
        ),
      )
      ..registerFactory(
        () => AiExplanationBloc(
          explainTextUseCase: GetIt.I<ExplainTextUseCase>(),
        ),
      )
      ..registerFactory(
        () => ExplanationHistoryBloc(
          getExplanationHistoryUseCase: GetIt.I<GetExplanationHistoryUseCase>(),
          searchExplanationHistoryUseCase:
              GetIt.I<SearchExplanationHistoryUseCase>(),
          deleteExplanationUseCase: GetIt.I<DeleteExplanationUseCase>(),
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
        () => LessonContentBloc(
          lessonRepository: GetIt.I<ILessonRepository>(),
          lessonProgressRepository: GetIt.I<ILessonProgressRepository>(),
          completeLessonUseCase: GetIt.I<CompleteLessonUseCase>(),
        ),
      )
      ..registerLazySingleton(() => AchievementNotificationCubit());
  }
}
