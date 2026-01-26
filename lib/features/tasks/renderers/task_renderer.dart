import 'package:codium/domain/models/task/task_model.dart';
import 'package:flutter/widgets.dart';

abstract interface class TaskRenderer {
  Widget build(BuildContext context, TaskModel task);
}
