import 'package:codium/core/widgets/widgets.dart';
import 'package:codium/domain/models/course/course.dart';
import 'package:codium/features/course_details/bloc/course_detail/course_detail_bloc.dart';
import 'package:codium/features/course_details/bloc/recommend/recommend_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class CourseDetailScreen extends StatelessWidget {
  final String courseId;

  const CourseDetailScreen({
    required this.courseId,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          GetIt.I<CourseDetailBloc>()..add(CourseDetailLoadEvent(courseId)),
      child: Scaffold(
        appBar: _CourseAppBar(),
        body: _CourseBody(),
      ),
    );
  }
}

class _CourseAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: BlocBuilder<CourseDetailBloc, CourseDetailState>(
        builder: (context, state) {
          return Text(
            state is CourseDetailLoadSuccessState
                ? state.course.title
                : 'Course Details',
          );
        },
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CourseBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CourseDetailBloc, CourseDetailState>(
      builder: (context, state) {
        return switch (state) {
          CourseDetailLoadSuccessState(:final course) =>
            _CourseDetail(course: course),
          CourseDetailLoadErrorState(:final message) => ErrorWidget(message),
          _ => const Center(child: CircularProgressIndicator()),
        };
      },
    );
  }
}

class _CourseDetail extends StatelessWidget {
  final Course course;

  const _CourseDetail({
    required this.course,
  });

  @override
  Widget build(BuildContext context) {
    return Wrapper(
      child: ListView(
        children: [
          CourseHeader(course: course),
          CourseMetaInfo(course: course),
          _buildDescriptionSection(context),
          _buildTableOfContents(context),
          _buildRecommendations(),
        ],
      ),
    );
  }

  Widget _buildDescriptionSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(title: 'Description'),
          const SizedBox(height: 8),
          Text(
            course.description,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildTableOfContents(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(title: 'Table of contents'),
          const SizedBox(height: 16),
          Text(
            course.tableOfContents,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  // TODO: Create a recommendation widget and add it
  Widget _buildRecommendations() {
    return BlocProvider(
      create: (context) => GetIt.I<RecommendBloc>(),
      child: const SizedBox(),
    );
  }
}

class CourseHeader extends StatelessWidget {
  final Course course;

  const CourseHeader({
    super.key,
    required this.course,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CourseCard(
          course: course,
          onPressed: null,
        ),
        const SizedBox(height: 16),
        const Divider(indent: 0, endIndent: 0),
      ],
    );
  }
}

class CourseMetaInfo extends StatelessWidget {
  const CourseMetaInfo({
    super.key,
    required this.course,
  });

  final Course course;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            MetaItem(value: course.pricing.price.format(), label: 'Price'),
            MetaItem(value: course.author.name, label: 'Author'),
            MetaItem(
              value: '${course.statistics.averageRating}/5',
              label: 'Rating',
            ),
            MetaItem(value: '${course.totalTasks}', label: 'Lessons'),
          ],
        ),
      ),
    );
  }
}

class MetaItem extends StatelessWidget {
  const MetaItem({
    required this.value,
    required this.label,
    super.key,
  });

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: theme.textTheme.titleSmall,
          ),
          Text(
            label,
            style: theme.textTheme.labelMedium,
          ),
        ],
      ),
    );
  }
}

class RecommendationSection extends StatelessWidget {
  const RecommendationSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(title: 'Recommend'),
        const SizedBox(height: 16),
        BlocBuilder<RecommendBloc, RecommendState>(
          builder: (context, state) {
            return switch (state) {
              RecommendLoadSuccessState() => CourseCarousel(
                  courseCards: state.recommendCourses
                      .map((rc) => CourseCard(
                            course: rc,
                            onPressed: null,
                          ),)
                      .toList(),
                ),
              RecommendLoadErrorState() => ErrorWidget(state.message),
              _ => const Center(child: CircularProgressIndicator()),
            };
          },
        ),
      ],
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleSmall,
    );
  }
}
