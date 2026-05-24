import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:praxis/domain/models/models.dart';
import 'package:praxis/features/course_details/widgets/course_purchase_button.dart';
import 'package:praxis/s.dart';

class CoursePrimaryActionButton extends StatelessWidget {
  const CoursePrimaryActionButton({
    super.key,
    required this.course,
    required this.isPurchased,
    required this.userProfile,
    this.compact = false,
  });

  final CourseModel course;
  final bool isPurchased;
  final UserProfileModel userProfile;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    if (isPurchased) {
      return SizedBox(
        width: compact ? null : double.infinity,
        height: compact ? 32 : null,
        child: ElevatedButton(
          onPressed: () => context.push('/course/${course.id}/learn'),
          style: _buildPurchasedButtonStyle(context),
          child: Text(S.of(context).startLearning),
        ),
      );
    }

    return SizedBox(
      height: compact ? 32 : null,
      child: CoursePurchaseButton(
        courseId: course.id,
        priceInCoins: course.priceInCoins,
        userProfile: userProfile,
        compact: compact,
      ),
    );
  }

  ButtonStyle _buildPurchasedButtonStyle(BuildContext context) {
    final theme = Theme.of(context);

    return ElevatedButton.styleFrom(
      backgroundColor: theme.colorScheme.primary,
      foregroundColor: theme.colorScheme.onPrimary,
      padding: compact
          ? const EdgeInsets.symmetric(horizontal: 12)
          : const EdgeInsets.symmetric(vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      textStyle: compact
          ? theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600)
          : theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
    );
  }
}
