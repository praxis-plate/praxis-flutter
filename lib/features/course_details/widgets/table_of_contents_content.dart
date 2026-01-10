import 'package:codium/domain/models/course/course_model.dart';
import 'package:codium/features/course_details/utils/utils.dart';
import 'package:codium/features/course_details/widgets/module_title.dart';
import 'package:codium/features/course_details/widgets/task_item.dart';
import 'package:flutter/material.dart';

class TableOfContentsContent extends StatelessWidget {
  final CourseModel course;

  const TableOfContentsContent({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    final items = const TableOfContentsParser().parse(course.tableOfContents);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: items.map(_mapItemToWidget).toList(),
    );
  }

  Widget _mapItemToWidget(TableOfContentsItem item) {
    return switch (item) {
      TableOfContentsModuleTitle(:final text) => ModuleTitle(text: text),
      TableOfContentsTaskItem(:final text) => TaskItem(text: text),
    };
  }
}
