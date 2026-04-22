import 'package:praxis/core/error/app_error_code_extension.dart';
import 'package:praxis/core/widgets/widgets.dart';
import 'package:praxis/features/main/bloc/main_carousel/main_carousel_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

class RecommendationCarousel extends StatelessWidget {
  const RecommendationCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    final userProfile = UserScope.of(context);

    return BlocProvider(
      create: (context) =>
          GetIt.I<MainCarouselBloc>()..add(MainCarouselLoadEvent()),
      child: BlocBuilder<MainCarouselBloc, MainCarouselState>(
        builder: (context, state) {
          if (state is MainCarouselLoadSuccessState) {
            return CourseCarousel(
              courseCards: state.courses
                  .map(
                    (course) => CourseCard(
                      key: Key(course.id.toString()),
                      course: course,
                      userProfile: userProfile,
                      onPressed: () => context.push('/course/${course.id}'),
                    ),
                  )
                  .toList(),
            );
          }

          if (state is MainCarouselLoadErrorState) {
            return ErrorScreen(
              message: state.failure.code.localizedMessage(context),
              onRetry: () {
                context.read<MainCarouselBloc>().add(MainCarouselLoadEvent());
              },
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
