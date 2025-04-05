import 'package:codium/core/widgets/running_text.dart';
import 'package:codium/core/widgets/wrapper.dart';
import 'package:codium/repositories/codium_courses/models/course.dart';
import 'package:flutter/material.dart';

class CourseTableOfContents extends StatelessWidget {
  const CourseTableOfContents({
    super.key,
    required this.course,
  });

  final Course course;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: RunningText(
          text: Text(
            course.title,
            overflow: TextOverflow.visible,
          ),
        ),
        centerTitle: false,
      ),
      body: Wrapper(
        child: ListView(
          children: _buildTaskWidgets(course.taskNodes),
        ),
      ),
    );
  }

  List<Widget> _buildTaskWidgets(List<TaskNode> taskNodes, {int indent = 0}) {
    return taskNodes
        .map<Widget>(
          (node) => ContentElement(
            task: node.task,
            onTap: () {},
            indent: indent,
          ),
        )
        .followedBy(
          taskNodes.expand(
            (node) => _buildTaskWidgets(node.subTasks, indent: indent + 1),
          ),
        )
        .toList();
  }
}

class ContentElement extends StatelessWidget {
  const ContentElement({
    super.key,
    required this.task,
    required this.onTap,
    this.indent = 0,
  });

  final Task task;
  final VoidCallback onTap;
  final int indent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8)
              .copyWith(left: indent.toDouble() * 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                task.title,
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: 4),
              Text(
                task.toString(),
                style: theme.textTheme.labelMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
