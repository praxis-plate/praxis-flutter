import 'package:codium/core/bloc/auth/auth_bloc.dart';
import 'package:codium/core/services/connectivity_service.dart';
import 'package:codium/core/services/session_service.dart';
import 'package:codium/data/datasources/datasources.dart';
import 'package:codium/data/repositories/ai_repository_impl.dart';
import 'package:codium/data/repositories/repositories.dart';
import 'package:codium/domain/datasources/datasources.dart';
import 'package:codium/domain/repositories/repositories.dart';
import 'package:codium/domain/usecases/usecases.dart';
import 'package:codium/features/ai_explanation/ai_explanation.dart';
import 'package:codium/features/auth/auth.dart';
import 'package:codium/features/course_details/course_details.dart';
import 'package:codium/features/explanation_history/explanation_history.dart';
import 'package:codium/features/learning/learning.dart';
import 'package:codium/features/library/library.dart';
import 'package:codium/features/main/main.dart';
import 'package:codium/features/onboarding/onboarding.dart';
import 'package:codium/features/pdf_reader/pdf_reader.dart';
import 'package:codium/features/profile/profile.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';

class DependencyInjection {
  void initialize() {
    GetIt.I.registerSingleton(TalkerFlutter.init());

    _registerServices();
    _registerDataSources();
    _registerRepositories();
    _registerUseCases();
    _registerBlocs();
  }

  void _registerServices() {
    GetIt.I.registerLazySingleton<ConnectivityService>(
      () => ConnectivityService(),
    );
  }

  void _registerDataSources() {
    GetIt.I
      ..registerLazySingleton<SessionService>(() => SessionService())
      ..registerSingleton<ICourseDataSource>(GoCourseDatasource())
      ..registerSingleton<IUserDataSource>(GoUserDatasource())
      ..registerLazySingleton<AppDatabase>(() => AppDatabase())
      ..registerLazySingleton<IAuthDataSource>(
        () => LocalAuthDataSource(
          GetIt.I<AppDatabase>(),
          GetIt.I<SessionService>(),
        ),
      )
      ..registerLazySingleton<PdfLocalDataSource>(
        () => PdfLocalDataSource(GetIt.I<AppDatabase>()),
      )
      ..registerLazySingleton<BookmarkLocalDataSource>(
        () => BookmarkLocalDataSource(GetIt.I<AppDatabase>()),
      )
      ..registerLazySingleton<ExplanationLocalDataSource>(
        () => ExplanationLocalDataSource(GetIt.I<AppDatabase>()),
      )
      ..registerLazySingleton<IUserStatisticsLocalDataSource>(
        () => UserStatisticsLocalDataSource(GetIt.I<AppDatabase>()),
      )
      ..registerLazySingleton<IUserStatisticsDataSource>(
        () => UserStatisticsRemoteDataSource(),
      )
      ..registerLazySingleton<GeminiDataSource>(() => GeminiDataSource())
      ..registerLazySingleton<SearchDataSource>(() => SearchDataSource());
  }

  void _registerRepositories() {
    GetIt.I
      ..registerLazySingleton<IAuthRepository>(
        () => AuthRepository(GetIt.I<IAuthDataSource>()),
      )
      ..registerLazySingleton<ICourseRepository>(
        () => CourseRepository(GetIt.I<ICourseDataSource>()),
      )
      ..registerLazySingleton<IUserRepository>(
        () => UserRepository(
          GetIt.I<IUserDataSource>(),
          GetIt.I<IAuthDataSource>(),
        ),
      )
      ..registerLazySingleton<IUserStatisticsRepository>(
        () => UserStatisticsRepository(
          localDataSource: GetIt.I<IUserStatisticsLocalDataSource>(),
          remoteDataSource: GetIt.I<IUserStatisticsDataSource>(),
        ),
      )
      ..registerLazySingleton<IPdfRepository>(
        () => PdfRepositoryImpl(
          GetIt.I<PdfLocalDataSource>(),
          GetIt.I<BookmarkLocalDataSource>(),
        ),
      )
      ..registerLazySingleton<IStorageRepository>(
        () => StorageRepositoryImpl(
          GetIt.I<BookmarkLocalDataSource>(),
          GetIt.I<ExplanationLocalDataSource>(),
        ),
      )
      ..registerLazySingleton<IAiRepository>(
        () => AiRepositoryImpl(
          geminiDataSource: GetIt.I<GeminiDataSource>(),
          searchDataSource: GetIt.I<SearchDataSource>(),
          connectivityService: GetIt.I<ConnectivityService>(),
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
      ..registerFactory(() => SignUpUseCase(GetIt.I<IAuthRepository>()))
      ..registerFactory(() => SignOutUseCase(GetIt.I<IAuthRepository>()))
      ..registerFactory(() => GetProfileUseCase(GetIt.I<IUserRepository>()))
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
          GetIt.I<ICourseRepository>(),
          GetIt.I<GenerateActivityUsecase>(),
        ),
      )
      ..registerFactory(
        () => PurchaseCourseUseCase(
          courseRepository: GetIt.I<ICourseRepository>(),
          userRepository: GetIt.I<IUserRepository>(),
          userStatisticsRepository: GetIt.I<IUserStatisticsRepository>(),
        ),
      )
      ..registerFactory(() => GetPdfListUseCase(GetIt.I<IPdfRepository>()))
      ..registerFactory(() => ImportPdfUseCase(GetIt.I<IPdfRepository>()))
      ..registerFactory(() => GetPdfBookByIdUseCase(GetIt.I<IPdfRepository>()))
      ..registerFactory(
        () => ValidateAndOpenPdfUseCase(GetIt.I<IPdfRepository>()),
      )
      ..registerFactory(
        () => UpdateReadingProgressUseCase(GetIt.I<IPdfRepository>()),
      )
      ..registerFactory(
        () => SaveBookmarkUseCase(GetIt.I<IStorageRepository>()),
      )
      ..registerFactory(
        () => ExplainTextUseCase(
          GetIt.I<IAiRepository>(),
          GetIt.I<IStorageRepository>(),
        ),
      )
      ..registerFactory(
        () => GetExplanationHistoryUseCase(GetIt.I<IStorageRepository>()),
      )
      ..registerFactory(
        () => SearchExplanationHistoryUseCase(GetIt.I<IStorageRepository>()),
      )
      ..registerFactory(
        () => DeleteExplanationUseCase(GetIt.I<IStorageRepository>()),
      )
      ..registerFactory(
        () => GetRecommendedCoursesUseCase(GetIt.I<ICourseRepository>()),
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
      ..registerFactory(
        () => ProfileBloc(getProfileUseCase: GetIt.I<GetProfileUseCase>()),
      )
      ..registerFactory(
        () => MainBloc(getCoursesUseCase: GetIt.I<GetCoursesUseCase>()),
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
        ),
      )
      ..registerFactory<CourseDetailBloc>(
        () => CourseDetailBloc(
          getCourseDetailUseCase: GetIt.I<GetCourseDetailUseCase>(),
        ),
      )
      ..registerLazySingleton(
        () => CoursePurchasingBloc(
          authBloc: GetIt.I<AuthBloc>(),
          purchaseCourseUseCase: GetIt.I<PurchaseCourseUseCase>(),
        ),
      )
      ..registerFactory(() => SignUpCubit())
      ..registerFactory(() => SignInCubit())
      ..registerFactory(
        () => LibraryBloc(
          getPdfListUseCase: GetIt.I<GetPdfListUseCase>(),
          importPdfUseCase: GetIt.I<ImportPdfUseCase>(),
          pdfRepository: GetIt.I<IPdfRepository>(),
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
      ..registerFactory(() => OnboardingBloc());
  }
}
