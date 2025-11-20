import 'package:codium/core/widgets/widgets.dart';
import 'package:codium/domain/models/course/course.dart';
import 'package:codium/features/course_details/bloc/course_detail/course_detail_bloc.dart';
import 'package:codium/features/course_details/bloc/recommend/recommend_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class CourseDetailScreen extends StatelessWidget {
  final String courseId;

  const CourseDetailScreen({required this.courseId, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          GetIt.I<CourseDetailBloc>()..add(CourseDetailLoadEvent(courseId)),
      child: Scaffold(appBar: _CourseAppBar(), body: _CourseBody()),
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
          CourseDetailLoadSuccessState(:final course) => _CourseDetail(
            course: course,
          ),
          CourseDetailLoadErrorState(:final message) => ErrorWidget(message),
          _ => const Center(child: CircularProgressIndicator()),
        };
      },
    );
  }
}

class _CourseDetail extends StatelessWidget {
  final Course course;

  const _CourseDetail({required this.course});

  @override
  Widget build(BuildContext context) {
    return Wrapper(
      child: ListView(
        children: [
          CourseHeader(course: course),
          CourseMetaInfo(course: course),
          _buildTabSection(context),
          _buildRecommendations(),
        ],
      ),
    );
  }

  Widget _buildTabSection(BuildContext context) {
    final theme = Theme.of(context);
    return DefaultTabController(
      length: 2,
      initialIndex:
          1, // По умолчанию активна вторая вкладка (Table of Contents)
      child: Column(
        children: [
          TabBar(
            tabs: const [
              Tab(text: 'Описание'),
              Tab(text: 'Содержание'),
            ],
            dividerHeight: 0,
            labelColor: theme.primaryColor,
            indicatorColor: theme.primaryColor,
            labelStyle: theme.textTheme.labelMedium,
          ),
          SizedBox(
            height: 400, // Фиксированная высота или использовать LayoutBuilder
            child: TabBarView(
              children: [
                _buildDescriptionContent(context),
                _buildTableOfContentsContent(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionContent(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(course.description, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }

  Widget _buildTableOfContentsContent(BuildContext context) {
    final parsedContent = _parseTableOfContents(
      context,
      course.tableOfContents,
    );
    return ListView(padding: const EdgeInsets.all(16), children: parsedContent);
  }

  List<Widget> _parseTableOfContents(BuildContext context, String content) {
    final lines = content.split('\n');
    final List<Widget> result = [];

    for (final line in lines) {
      final trimmedLine = line.trim();
      if (trimmedLine.isEmpty) continue;

      if (trimmedLine.startsWith('#')) {
        result.add(_buildModuleTitle(context, trimmedLine.substring(1).trim()));
      } else if (trimmedLine.startsWith('*')) {
        result.add(_buildTaskItem(context, trimmedLine.substring(1).trim()));
      }
    }

    return result;
  }

  Widget _buildModuleTitle(BuildContext context, String text) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Text(
        text,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: theme.primaryColor,
        ),
      ),
    );
  }

  Widget _buildTaskItem(BuildContext context, String text) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 6, right: 12),
            child: Icon(
              Icons.chevron_right,
              size: 18,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodyMedium?.copyWith(height: 1.4),
            ),
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

  const CourseHeader({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CourseCard(course: course, onPressed: null),
        const SizedBox(height: 16),
        const Divider(indent: 0, endIndent: 0),
      ],
    );
  }
}

class CourseMetaInfo extends StatelessWidget {
  const CourseMetaInfo({super.key, required this.course});

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
  const MetaItem({required this.value, required this.label, super.key});

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
          Text(value, style: theme.textTheme.titleSmall),
          Text(label, style: theme.textTheme.labelMedium),
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
                    .map((rc) => CourseCard(course: rc, onPressed: null))
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
    return Text(title, style: Theme.of(context).textTheme.titleSmall);
  }
}
