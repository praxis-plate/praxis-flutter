import 'package:flutter/material.dart';
import 'package:praxis/core/error/app_error_code_extension.dart';
import 'package:praxis/core/utils/result.dart';
import 'package:praxis/core/widgets/feedback/success_toast.dart';
import 'package:praxis/domain/models/course/course_review_model.dart';
import 'package:praxis/domain/usecases/course/submit_course_review_usecase.dart';
import 'package:praxis/s.dart';

class CourseReviewDialog extends StatefulWidget {
  const CourseReviewDialog({
    super.key,
    required this.courseId,
    required this.submitCourseReviewUseCase,
    this.initialReview,
  });

  final int courseId;
  final SubmitCourseReviewUseCase submitCourseReviewUseCase;
  final CourseReviewModel? initialReview;

  @override
  State<CourseReviewDialog> createState() => _CourseReviewDialogState();
}

class _CourseReviewDialogState extends State<CourseReviewDialog> {
  final _commentController = TextEditingController();
  late int _rating;
  bool _isSubmitting = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _rating = widget.initialReview?.rating ?? 5;
    _commentController.text = widget.initialReview?.comment ?? '';
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final comment = _commentController.text.trim();
    if (comment.isEmpty || _isSubmitting) {
      return;
    }

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    final result = await widget.submitCourseReviewUseCase(
      courseId: widget.courseId,
      rating: _rating,
      comment: comment,
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _isSubmitting = false;
    });

    if (result.isFailure) {
      final failure = result.failureOrNull!;
      setState(() {
        _errorMessage = failure.code.localizedMessage(context);
      });
      return;
    }

    SuccessToast.show(
      context: context,
      message: S.of(context).courseReviewSubmitSuccess,
    );
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);

    return AlertDialog(
      title: Text(
        widget.initialReview == null
            ? s.courseReviewDialogTitle
            : s.courseReviewEditDialogTitle,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            s.courseReviewDialogRatingLabel,
            style: theme.textTheme.titleSmall,
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 4,
            children: List.generate(5, (index) {
              final value = index + 1;
              return IconButton(
                onPressed: _isSubmitting
                    ? null
                    : () {
                        setState(() {
                          _rating = value;
                        });
                      },
                visualDensity: VisualDensity.compact,
                constraints: const BoxConstraints.tightFor(
                  width: 36,
                  height: 36,
                ),
                padding: EdgeInsets.zero,
                splashRadius: 20,
                icon: Icon(
                  value <= _rating
                      ? Icons.star_rounded
                      : Icons.star_outline_rounded,
                  size: 28,
                  color: theme.colorScheme.primary,
                ),
              );
            }),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _commentController,
            enabled: !_isSubmitting,
            minLines: 4,
            maxLines: 6,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              labelText: s.courseReviewDialogCommentLabel,
              hintText: s.courseReviewDialogCommentHint,
              border: const OutlineInputBorder(),
            ),
          ),
          if (_errorMessage != null) ...[
            const SizedBox(height: 12),
            Text(
              _errorMessage!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: _isSubmitting
              ? null
              : () => Navigator.of(context).pop(false),
          child: Text(s.cancel),
        ),
        FilledButton(
          onPressed: _isSubmitting ? null : _submit,
          style: FilledButton.styleFrom(
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: theme.colorScheme.onPrimary,
          ),
          child: _isSubmitting
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(
                  widget.initialReview == null
                      ? s.courseReviewSubmitAction
                      : s.courseReviewUpdateAction,
                ),
        ),
      ],
    );
  }
}
