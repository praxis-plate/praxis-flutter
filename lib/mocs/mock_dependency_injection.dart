import 'package:codium/core/bloc/auth/auth_bloc.dart';
import 'package:codium/domain/repositories/abstract_user_statistics_repository.dart';
import 'package:codium/domain/repositories/repositories.dart';
import 'package:codium/domain/usecases/auth/check_auth_status_usecase.dart';
import 'package:codium/domain/usecases/auth/sign_in_usecase.dart';
import 'package:codium/domain/usecases/auth/sign_out_usecase.dart';
import 'package:codium/domain/usecases/auth/sign_up_usecase.dart';
import 'package:codium/domain/usecases/generate_activity_usecase.dart';
import 'package:codium/domain/usecases/get_course_detail_usecase.dart';
import 'package:codium/domain/usecases/get_courses_usecase.dart';
import 'package:codium/domain/usecases/get_learning_data_usecase.dart';
import 'package:codium/domain/usecases/get_main_carousel_courses.dart';
import 'package:codium/domain/usecases/get_profile_usecase.dart';
import 'package:codium/domain/usecases/get_user_statistics_usecase.dart';
import 'package:codium/features/course_details/bloc/course_detail/course_detail_bloc.dart';
import 'package:codium/features/learning/bloc/learning/learning_bloc.dart';
import 'package:codium/features/main/bloc/main/main_bloc.dart';
import 'package:codium/features/main/bloc/main_carousel/main_carousel_bloc.dart';
import 'package:codium/features/main/bloc/user_statistics/user_statistics_bloc.dart';
import 'package:codium/features/profile/bloc/bloc/profile_bloc.dart';
import 'package:codium/mocs/repositories/mock_auth_repository.dart';
import 'package:codium/mocs/repositories/mock_course_repository.dart';
import 'package:codium/mocs/repositories/mock_user_repository.dart';
import 'package:codium/mocs/repositories/mock_user_statistics_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';

class MockDependencyInjection {
  void initialize() {
    GetIt.I.registerSingleton(TalkerFlutter.init());

    _registerMockRepositories();
    _registerUseCases();
    _registerBlocs();
  }

  void _registerMockRepositories() {
    GetIt.I
      ..registerLazySingleton<IAuthRepository>(
        () => MockAuthRepository(),
      )
      ..registerLazySingleton<ICourseRepository>(
        () => MockCourseRepository(),
      )
      ..registerLazySingleton<IUserRepository>(
        () => MockUserRepository(),
      )
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
      ..registerFactory(
        () => SignInUseCase(GetIt.I<IAuthRepository>()),
      )
      ..registerFactory(
        () => SignUpUseCase(GetIt.I<IAuthRepository>()),
      )
      ..registerFactory(
        () => SignOutUseCase(GetIt.I<IAuthRepository>()),
      )
      ..registerFactory(
        () => GetProfileUseCase(GetIt.I<IUserRepository>()),
      )
      ..registerFactory(
        () => GetCoursesUseCase(GetIt.I<ICourseRepository>()),
      )
      ..registerFactory(
        () => GetMainCarouselCoursesUseCase(GetIt.I<ICourseRepository>()),
      )
      ..registerFactory(
        () => GetUserStatisticsUseCase(GetIt.I<IUserStatisticsRepository>()),
      )
      ..registerFactory(
        () => GenerateActivityUsecase(),
      )
      ..registerFactory(
        () => GetCourseDetailUseCase(GetIt.I<ICourseRepository>()),
      )
      ..registerFactory(
        () => GetLearningDataUseCase(
          GetIt.I<IUserStatisticsRepository>(),
          GetIt.I<ICourseRepository>(),
          GetIt.I<GenerateActivityUsecase>(),
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
        () => ProfileBloc(
          getProfileUseCase: GetIt.I<GetProfileUseCase>(),
        ),
      )
      ..registerFactory(
        () => MainBloc(
          getCoursesUseCase: GetIt.I<GetCoursesUseCase>(),
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
        ),
      )
      ..registerFactory<CourseDetailBloc>(
        () => CourseDetailBloc(
          getCourseDetailUseCase: GetIt.I<GetCourseDetailUseCase>(),
        ),
      );
  }
}
