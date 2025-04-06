import 'package:codium/core/widgets/running_text.dart';
import 'package:codium/core/widgets/wrapper.dart';
import 'package:codium/domain/models/course/course.dart';
import 'package:codium/domain/models/task/course_task.dart';
import 'package:flutter/material.dart';

class CourseTableOfContents extends StatelessWidget {
  const CourseTableOfContents({
    super.key,
    required this.course,
  });

  final Course course;

  @override
  Widget build(BuildContext context) {
    final moduleWidgets = course.modules.expand<Widget>((module) => [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Text(
              module.title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          ...module.tasks.map<Widget>((task) => ContentElement(
                task: task,
                onTap: () {},
                indent: 1,
              ),),
        ],).toList();

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
          children: moduleWidgets,
        ),
      ),
    );
  }
}

class ContentElement extends StatelessWidget {
  const ContentElement({
    super.key,
    required this.task,
    required this.onTap,
    this.indent = 0,
  });

  final CourseTask task;
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
