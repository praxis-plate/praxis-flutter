import 'package:codium/core/bloc/auth/auth_bloc.dart';
import 'package:codium/data/datasources/go_auth_datasource.dart';
import 'package:codium/data/datasources/go_course_datasource.dart';
import 'package:codium/data/repositories/mock_auth_repository.dart';
import 'package:codium/data/repositories/repositories.dart';
import 'package:codium/domain/datasources/abstract_auth_datasource.dart';
import 'package:codium/domain/datasources/abstract_course_datasource.dart';
import 'package:codium/domain/datasources/abstract_user_datasource.dart';
import 'package:codium/domain/repositories/abstract_user_statistics_repository.dart';
import 'package:codium/domain/repositories/repositories.dart';
import 'package:codium/domain/usecases/auth/check_auth_status_usecase.dart';
import 'package:codium/domain/usecases/auth/sign_in_usecase.dart';
import 'package:codium/domain/usecases/auth/sign_out_usecase.dart';
import 'package:codium/domain/usecases/auth/sign_up_usecase.dart';
import 'package:codium/domain/usecases/generate_activity_usecase.dart';
import 'package:codium/domain/usecases/get_course_detail_usecase.dart';
import 'package:codium/domain/usecases/get_courses_usecase.dart';
import 'package:codium/domain/usecases/get_main_carousel_courses.dart';
import 'package:codium/domain/usecases/get_profile_usecase.dart';
import 'package:codium/domain/usecases/get_user_statistics_usecase.dart';
import 'package:codium/features/course_details/bloc/course_detail/course_detail_bloc.dart';
import 'package:codium/features/learning/bloc/learning/learning_bloc.dart';
import 'package:codium/features/main/bloc/main/main_bloc.dart';
import 'package:codium/features/main/bloc/main_carousel/main_carousel_bloc.dart';
import 'package:codium/features/main/bloc/user_statistics/user_statistics_bloc.dart';
import 'package:codium/features/profile/bloc/bloc/profile_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';

class DependencyInjection {
  void initialize() {
    GetIt.I.registerSingleton(TalkerFlutter.init());

    _registerDataSources();
    _registerRepositories();
    _registerUseCases();
    _registerBlocs();
  }

  void _registerDataSources() {
    GetIt.I
      ..registerSingleton<IAuthDataSource>(GoAuthDatasource())
      ..registerSingleton<ICourseDataSource>(GoCourseDatasource())
      ..registerSingleton<IAuthDataSource>(GoAuthDatasource());
  }

  void _registerRepositories() {
    GetIt.I
      ..registerLazySingleton<IAuthRepository>(
        () => MockAuthRepository(),
      )
      ..registerLazySingleton<ICourseRepository>(
        () => CourseRepository(GetIt.I<ICourseDataSource>()),
      )
      ..registerLazySingleton<IUserRepository>(
        () => UserRepository(GetIt.I<IUserDataSource>()),
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
          generateActivityUsecase: GetIt.I<GenerateActivityUsecase>(),
          getUserStatisticsUseCase: GetIt.I<GetUserStatisticsUseCase>(),
        ),
      )
      ..registerFactory<CourseDetailBloc>(
        () => CourseDetailBloc(
          getCourseDetailUseCase: GetIt.I<GetCourseDetailUseCase>(),
        ),
      );
  }
}
