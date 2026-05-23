import 'package:praxis/domain/models/course/course_model.dart';
import 'package:praxis/s.dart';
import 'package:flutter/material.dart';

class DescriptionContent extends StatefulWidget {
  final CourseModel course;

  const DescriptionContent({super.key, required this.course});

  @override
  State<DescriptionContent> createState() => _DescriptionContentState();
}

class _DescriptionContentState extends State<DescriptionContent> {
  bool _isExpanded = false;

  bool _shouldShowToggle(BuildContext context, TextStyle? style) {
    final width = MediaQuery.sizeOf(context).width - 32;
    final textPainter = TextPainter(
      text: TextSpan(text: widget.course.description, style: style),
      textDirection: Directionality.of(context),
      maxLines: 5,
    )..layout(maxWidth: width);

    return textPainter.didExceedMaxLines;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = S.of(context);
    final textStyle = theme.textTheme.bodyMedium?.copyWith(
      color: theme.colorScheme.onSurface.withValues(alpha: 0.85),
    );
    final shouldShowToggle = _shouldShowToggle(context, textStyle);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.course.description,
          maxLines: _isExpanded ? null : 5,
          overflow: _isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
          style: textStyle,
        ),
        if (shouldShowToggle)
          TextButton(
            onPressed: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            style: TextButton.styleFrom(
              minimumSize: Size.zero,
              padding: EdgeInsets.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              _isExpanded ? s.showLess : s.showMore,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }
}
