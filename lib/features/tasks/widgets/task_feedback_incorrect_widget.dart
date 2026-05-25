import 'package:praxis/domain/models/task/task_model.dart';
import 'package:praxis/domain/models/task/task_result_model.dart';
import 'package:praxis/features/tasks/bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:praxis/core/widgets/widgets.dart';

import 'task_feedback_content.dart';

const _negativeShiftStates = [
  ShiftState.wrongSad,
  ShiftState.retry,
  ShiftState.almostThere,
  ShiftState.thinking,
  ShiftState.bugError,
];

class TaskFeedbackIncorrectWidget extends StatefulWidget {
  final TaskModel task;
  final TaskResultModel result;

  const TaskFeedbackIncorrectWidget({
    super.key,
    required this.task,
    required this.result,
  });

  @override
  State<TaskFeedbackIncorrectWidget> createState() =>
      _TaskFeedbackIncorrectWidgetState();
}

class _TaskFeedbackIncorrectWidgetState
    extends State<TaskFeedbackIncorrectWidget>
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
    return TaskFeedbackContent(
      result: widget.result,
      isCorrect: false,
      scaleAnimation: _scaleAnimation,
      fadeAnimation: _fadeAnimation,
      onRetry: () {
        context.read<TaskBloc>().add(const RetryTaskEvent());
      },
      fallbackExplanation: widget.task.fallbackExplanation,
      shiftState:
          _negativeShiftStates[widget.task.id % _negativeShiftStates.length],
    );
  }
}
