import 'package:codium/core/widgets/course_card.dart';
import 'package:codium/core/widgets/course_carousel.dart';
import 'package:codium/core/widgets/course_search_bar.dart';
import 'package:codium/core/widgets/user_points_card.dart';
import 'package:codium/core/widgets/wrapper.dart';
import 'package:codium/features/main/bloc/main/main_bloc.dart';
import 'package:codium/features/main/bloc/main_carousel/main_carousel_bloc.dart';
import 'package:codium/features/main/bloc/user_statistics/user_statistics_bloc.dart';
import 'package:codium/repositories/codium_courses/abstract_course_repository.dart';
import 'package:codium/repositories/codium_user/abstract_user_repository.dart';
import 'package:codium/s.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final _userStatisticsBloc = UserStatisticsBloc(GetIt.I<IUserRepository>());
  final _mainBloc = MainBloc(GetIt.I<ICourseRepository>());
  final _mainCarouselBloc = MainCarouselBloc(GetIt.I<ICourseRepository>());

  @override
  void initState() {
    _mainBloc.add(MainLoadCoursesEvent());
    _userStatisticsBloc.add(UserStatisticsLoadEvent());
    _mainCarouselBloc.add(MainCarouselLoadEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.of(context).mainTitle,
          style: theme.textTheme.titleLarge,
        ),
      ),
      body: Wrapper(
        child: ListView(
          children: [
            BlocBuilder<UserStatisticsBloc, UserStatisticsState>(
              bloc: _userStatisticsBloc,
              builder: (context, state) {
                if (state is UserStatisticsLoadSuccessState) {
                  return UserPointsCard(userStatistics: state.userStatistics);
                }
                return const CircularProgressIndicator();
              },
            ),
            const SizedBox(height: 8),
            Text(
              S.of(context).recommend,
              style: theme.textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            BlocBuilder<MainCarouselBloc, MainCarouselState>(
              bloc: _mainCarouselBloc,
              builder: (context, state) {
                if (state is MainCarouselLoadSuccessState) {
                  return CourseCarousel(
                    courseCards: state.courses
                        .map((e) => CourseCard(course: e))
                        .toList(),
                  );
                }
                if (state is MainCarouselLoadErrorState) {
                  return Text(state.message);
                }
                return const CircularProgressIndicator();
              },
            ),
            const SizedBox(height: 8),
            Text(
              S.of(context).courses,
              style: theme.textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            const CourseSearchBar(),
            const SizedBox(height: 16),
            BlocBuilder<MainBloc, MainState>(
              bloc: _mainBloc,
              builder: (context, state) {
                if (state is MainCoursesLoadSuccessState) {
                  return ListView(
                    physics: const ClampingScrollPhysics(),
                    shrinkWrap: true,
                    children: state.courses
                        .map((e) => CourseCard(course: e))
                        .toList(),
                  );
                }
                if (state is MainCoursesLoadErrorState) {
                  return Text(state.message);
                }
                return const CircularProgressIndicator();
              },
            ),
          ],
        ),
      ),
    );
  }
}
