import 'package:flutter/material.dart';
import 'package:praxis/domain/models/course/course_assessment_model.dart';
import 'package:praxis/features/tasks/widgets/summary_row.dart';
import 'package:praxis/s.dart';

class CourseAssessmentCard extends StatelessWidget {
  const CourseAssessmentCard({
    super.key,
    required this.assessment,
    this.margin = const EdgeInsets.fromLTRB(16, 16, 16, 0),
    this.action,
  });

  final CourseAssessmentModel assessment;
  final EdgeInsetsGeometry margin;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);

    return Container(
      margin: margin,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color.alphaBlend(
          theme.colorScheme.primary.withValues(alpha: 0.04),
          theme.colorScheme.surfaceContainerHighest,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.24),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            s.courseAssessmentTitle,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          SummaryRow(
            icon: Icons.workspace_premium,
            label: s.courseAssessmentGrade,
            value: s.courseAssessmentGradeValue(assessment.grade),
            theme: theme,
          ),
          const SizedBox(height: 12),
          SummaryRow(
            icon: Icons.auto_graph,
            label: s.courseAssessmentAccuracy,
            value: '${assessment.accuracyPercentage.toStringAsFixed(1)}%',
            theme: theme,
          ),
          const SizedBox(height: 12),
          SummaryRow(
            icon: Icons.school,
            label: s.courseAssessmentLessons,
            value: '${assessment.completedLessons}/${assessment.totalLessons}',
            theme: theme,
          ),
          const SizedBox(height: 12),
          SummaryRow(
            icon: Icons.assignment_turned_in,
            label: s.courseAssessmentTasks,
            value: '${assessment.completedTasks}/${assessment.totalTasks}',
            theme: theme,
          ),
          if (action != null) ...[
            const SizedBox(height: 16),
            action!,
          ],
        ],
      ),
    );
  }
}
