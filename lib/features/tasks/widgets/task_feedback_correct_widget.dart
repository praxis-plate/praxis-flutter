import 'package:praxis/domain/models/task/task_model.dart';
import 'package:praxis/domain/models/task/task_result_model.dart';
import 'package:flutter/material.dart';

import 'task_feedback_content.dart';

class TaskFeedbackCorrectWidget extends StatefulWidget {
  final TaskModel task;
  final TaskResultModel result;

  const TaskFeedbackCorrectWidget({
    super.key,
    required this.task,
    required this.result,
  });

  @override
  State<TaskFeedbackCorrectWidget> createState() =>
      _TaskFeedbackCorrectWidgetState();
}

class _TaskFeedbackCorrectWidgetState extends State<TaskFeedbackCorrectWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0, 0.5, curve: Curves.easeIn),
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return buildTaskFeedbackContent(
      context: context,
      result: widget.result,
      isCorrect: true,
      scaleAnimation: _scaleAnimation,
      fadeAnimation: _fadeAnimation,
      onRetry: null,
    );
  }
}
