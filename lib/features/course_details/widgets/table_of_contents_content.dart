import 'package:codium/domain/models/course/course_structure_module_model.dart';
import 'package:codium/domain/models/course/course_structure_lesson_model.dart';
import 'package:codium/features/course_details/bloc/course_detail/course_detail_bloc.dart';
import 'package:codium/s.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class TableOfContentsContent extends StatelessWidget {
  const TableOfContentsContent({super.key});

  void _handleLessonTap(
    BuildContext context, {
    required bool isPurchased,
    required int lessonId,
  }) {
    if (!isPurchased) {
      final s = S.of(context);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(s.purchaseCourse)));
      return;
    }

    context.pushNamed(
      'lesson-task-session',
      pathParameters: {'lessonId': lessonId.toString()},
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return BlocBuilder<CourseDetailBloc, CourseDetailState>(
      builder: (context, state) {
        if (state is! CourseDetailLoadSuccessState) {
          return const Center(child: CircularProgressIndicator());
        }

        final tableOfContents = state.tableOfContents;
        final isPurchased = state.isPurchased;
        if (tableOfContents == null) {
          return Center(child: Text(s.noLessonsAvailable));
        }

        final modules = List.of(tableOfContents.modules)
          ..sort((a, b) => a.orderIndex.compareTo(b.orderIndex));

        return Column(
          children: modules
              .expand(
                (module) => [
                  _ModuleHeader(module: module),
                  ...module.lessons.map(
                    (lesson) => _LessonItem(
                      lesson: lesson,
                      isPurchased: isPurchased,
                      onTap: () => _handleLessonTap(
                        context,
                        isPurchased: isPurchased,
                        lessonId: lesson.id,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              )
              .toList(),
        );
      },
    );
  }
}

class _ModuleHeader extends StatelessWidget {
  final CourseStructureModuleModel module;

  const _ModuleHeader({required this.module});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = S.of(context);
    final hasDescription = module.description.trim().isNotEmpty;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              module.title,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.onPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              s.lessonsCount(module.lessons.length),
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onPrimary.withValues(alpha: 0.8),
              ),
            ),
            if (hasDescription) ...[
              const SizedBox(height: 6),
              Text(
                module.description,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onPrimary.withValues(alpha: 0.85),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _LessonItem extends StatelessWidget {
  final CourseStructureLessonModel lesson;
  final bool isPurchased;
  final VoidCallback onTap;

  const _LessonItem({
    required this.lesson,
    required this.isPurchased,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Material(
        color: theme.cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: theme.dividerColor.withValues(alpha: 0.6)),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Row(
              children: [
                Icon(
                  isPurchased ? Icons.play_circle_outline : Icons.lock_outline,
                  color: isPurchased
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    lesson.title,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: isPurchased
                          ? theme.colorScheme.onSurface
                          : theme.colorScheme.onSurface.withValues(
                              alpha: 0.75,
                            ),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (lesson.durationMinutes > 0) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      S.of(context).minutesCount(lesson.durationMinutes),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
