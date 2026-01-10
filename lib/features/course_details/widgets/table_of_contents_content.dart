import 'package:codium/domain/models/course_content/course_content_model.dart';
import 'package:codium/features/course_details/utils/utils.dart';
import 'package:codium/features/course_details/widgets/module_title.dart';
import 'package:codium/features/course_details/widgets/task_item.dart';
import 'package:flutter/material.dart';

class TableOfContentsContent extends StatelessWidget {
  final CourseContentModel course;

  const TableOfContentsContent({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    final items = const TableOfContentsParser().parse(course.tableOfContents);

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      itemBuilder: (context, index) => _mapItemToWidget(items[index]),
    );
  }

  Widget _mapItemToWidget(TableOfContentsItem item) {
    return switch (item) {
      TableOfContentsModuleTitle(:final text) => ModuleTitle(text: text),
      TableOfContentsTaskItem(:final text) => TaskItem(text: text),
    };
  }
}
