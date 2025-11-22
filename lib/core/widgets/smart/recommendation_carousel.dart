import 'package:codium/core/widgets/widgets.dart';
import 'package:codium/features/main/bloc/main_carousel/main_carousel_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

class RecommendationCarousel extends StatelessWidget {
  const RecommendationCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          GetIt.I<MainCarouselBloc>()..add(MainCarouselLoadEvent()),
      child: BlocBuilder<MainCarouselBloc, MainCarouselState>(
        builder: (context, state) {
          return switch (state) {
            MainCarouselLoadSuccessState() => CourseCarousel(
                courseCards: state.courses
                    .map(
                      (e) => CourseCard(
                        course: e,
                        onPressed: () => context.push('/course/${e.id}'),
                      ),
                    )
                    .toList(),
              ),
            MainCarouselLoadErrorState() => Text(state.message),
            _ => const Center(child: CircularProgressIndicator()),
          };
        },
      ),
    );
  }
}
