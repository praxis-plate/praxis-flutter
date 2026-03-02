import 'package:codium/domain/models/course/course_model.dart';
import 'package:codium/features/course_details/widgets/description_content.dart';
import 'package:codium/features/course_details/widgets/table_of_contents_content.dart';
import 'package:codium/s.dart';
import 'package:flutter/material.dart';

class CourseTabSection extends StatefulWidget {
  final CourseModel course;

  const CourseTabSection({super.key, required this.course});

  @override
  State<CourseTabSection> createState() => _CourseTabSectionState();
}

class _CourseTabSectionState extends State<CourseTabSection>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

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
    final s = S.of(context);

    // TODO: нужно реализовать пролистывание содержания вместе со скрытием курса
    // => сделать сам курс в appBar и его скрытие после пролистывания
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: s.courseDetailsDescriptionTab),
            Tab(text: s.courseDetailsContentsTab),
          ],
        ),
        SizedBox(
          height: 400,
          child: TabBarView(
            controller: _tabController,
            children: [
              DescriptionContent(course: widget.course),
              const TableOfContentsContent(),
            ],
          ),
        ),
      ],
    );
  }
}
