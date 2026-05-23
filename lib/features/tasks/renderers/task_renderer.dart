import 'package:praxis/domain/models/task/task_model.dart';
import 'package:flutter/widgets.dart';

class TaskScreenDescriptor {
  final String title;
  final Widget body;

  const TaskScreenDescriptor({required this.title, required this.body});
}

abstract interface class TaskRenderer {
  TaskScreenDescriptor describe(BuildContext context, TaskModel task);
}
