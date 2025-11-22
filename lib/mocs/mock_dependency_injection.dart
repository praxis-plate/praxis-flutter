import 'package:codium/core/bloc/auth/auth_bloc.dart';
import 'package:codium/domain/repositories/repositories.dart';
import 'package:codium/domain/usecases/usecases.dart';
import 'package:codium/features/auth/bloc/sign_in/sign_in_cubit.dart';
import 'package:codium/features/auth/bloc/sign_up/sign_up_cubit.dart';
import 'package:codium/features/course_details/bloc/course_detail/course_detail_bloc.dart';
import 'package:codium/features/learning/bloc/learning/learning_bloc.dart';
import 'package:codium/features/main/bloc/course_purchasing/course_purchasing_bloc.dart';
import 'package:codium/features/main/bloc/main/main_bloc.dart';
import 'package:codium/features/main/bloc/main_carousel/main_carousel_bloc.dart';
import 'package:codium/features/main/bloc/user_statistics/user_statistics_bloc.dart';
import 'package:codium/features/profile/bloc/bloc/profile_bloc.dart';
import 'package:codium/mocs/repositories/mock_auth_repository.dart';
import 'package:codium/mocs/repositories/mock_course_repository.dart';
import 'package:codium/mocs/repositories/mock_user_repository.dart';
import 'package:codium/mocs/repositories/mock_user_statistics_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_bloc_logger/talker_bloc_logger.dart';
import 'package:talker_flutter/talker_flutter.dart';

class MockDependencyInjection {
  void initialize() {
    GetIt.I.registerSingleton(TalkerFlutter.init());
    Bloc.observer = TalkerBlocObserver(
      settings: const TalkerBlocLoggerSettings(
        enabled: true,
        printStateFullData: true,
        printTransitions: true,
      ),
    );

    _registerMockRepositories();
    _registerUseCases();
    _registerBlocs();
  }

  void _registerMockRepositories() {
    GetIt.I
      ..registerLazySingleton<IAuthRepository>(() => MockAuthRepository())
      ..registerLazySingleton<ICourseRepository>(() => MockCourseRepository())
      ..registerLazySingleton<IUserRepository>(() => MockUserRepository())
      ..registerLazySingleton<IUserStatisticsRepository>(
        () => MockUserStatisticsRepository(),
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
      ..registerFactory(() => SignInCubit());
  }
}
