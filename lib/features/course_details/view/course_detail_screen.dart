import 'package:codium/core/widgets/widgets.dart';
import 'package:codium/domain/models/course/course.dart';
import 'package:codium/features/course_details/bloc/course_detail/course_detail_bloc.dart';
import 'package:codium/features/course_details/bloc/recommend/recommend_bloc.dart';
import 'package:codium/s.dart';
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
    final s = S.of(context);
    return AppBar(
      title: BlocBuilder<CourseDetailBloc, CourseDetailState>(
        builder: (context, state) {
          return Text(
            state is CourseDetailLoadSuccessState
                ? state.course.title
                : s.courseDetailsTitle,
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
          _CourseTabSection(course: course),
          const _CourseRecommendations(),
        ],
      ),
    );
  }
}

class _CourseTabSection extends StatefulWidget {
  final Course course;

  const _CourseTabSection({required this.course});

  @override
  State<_CourseTabSection> createState() => _CourseTabSectionState();
}

class _CourseTabSectionState extends State<_CourseTabSection>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 1);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = S.of(context);
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: s.courseDetailsDescriptionTab),
            Tab(text: s.courseDetailsContentsTab),
          ],
          dividerHeight: 0,
          labelColor: theme.primaryColor,
          indicatorColor: theme.primaryColor,
          labelStyle: theme.textTheme.labelMedium,
        ),
        SizedBox(
          height: 400,
          child: TabBarView(
            controller: _tabController,
            children: [
              _DescriptionContent(course: widget.course),
              _TableOfContentsContent(course: widget.course),
            ],
          ),
        ),
      ],
    );
  }
}

class _DescriptionContent extends StatelessWidget {
  final Course course;

  const _DescriptionContent({required this.course});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(course.description, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}

class _TableOfContentsContent extends StatelessWidget {
  final Course course;

  const _TableOfContentsContent({required this.course});

  @override
  Widget build(BuildContext context) {
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
        result.add(_ModuleTitle(text: trimmedLine.substring(1).trim()));
      } else if (trimmedLine.startsWith('*')) {
        result.add(_TaskItem(text: trimmedLine.substring(1).trim()));
      }
    }

    return result;
  }
}

class _ModuleTitle extends StatelessWidget {
  final String text;

  const _ModuleTitle({required this.text});

  @override
  Widget build(BuildContext context) {
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
}

class _TaskItem extends StatelessWidget {
  final String text;

  const _TaskItem({required this.text});

  @override
  Widget build(BuildContext context) {
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
}

class _CourseRecommendations extends StatelessWidget {
  const _CourseRecommendations();

  @override
  Widget build(BuildContext context) {
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
        child: Builder(
          builder: (context) {
            final s = S.of(context);
            return ListView(
              scrollDirection: Axis.horizontal,
              children: [
                MetaItem(
                  value: course.pricing.price.format(),
                  label: s.courseDetailsPrice,
                ),
                MetaItem(
                  value: course.author.name,
                  label: s.courseDetailsAuthor,
                ),
                MetaItem(
                  value: '${course.statistics.averageRating}/5',
                  label: s.courseDetailsRating,
                ),
                MetaItem(
                  value: '${course.totalTasks}',
                  label: s.courseDetailsLessonsLabel,
                ),
              ],
            );
          },
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
    final s = S.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(title: s.courseDetailsRecommend),
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
