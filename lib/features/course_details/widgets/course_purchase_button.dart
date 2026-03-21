import 'package:codium/core/widgets/widgets.dart';
import 'package:codium/domain/models/models.dart';
import 'package:codium/features/main/bloc/course_purchasing/course_purchasing_bloc.dart';
import 'package:codium/s.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CoursePurchaseButton extends StatelessWidget {
  final int courseId;
  final int priceInCoins;
  final UserProfileModel userProfile;
  final bool compact;

  const CoursePurchaseButton({
    super.key,
    required this.courseId,
    required this.priceInCoins,
    required this.userProfile,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = S.of(context);

    return BlocBuilder<CoursePurchasingBloc, CoursePurchasingState>(
      builder: (context, state) {
        final isProcessing =
            state is CoursePurchasingLoadingState &&
            state.courseId == courseId;

        return SizedBox(
          width: compact ? null : double.infinity,
          height: compact ? 32 : null,
          child: ElevatedButton(
            onPressed: isProcessing ? null : () => _onPressed(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
              padding: compact
                  ? const EdgeInsets.symmetric(horizontal: 12)
                  : const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              textStyle: compact
                  ? theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    )
                  : theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
            ),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: isProcessing
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : _PurchaseButtonLabel(
                      priceInCoins: priceInCoins,
                      label: priceInCoins == 0
                          ? s.add
                          : s.courseDetailsGet,
                      compact: compact,
                    ),
            ),
          ),
        );
      },
    );
  }

  void _onPressed(BuildContext context) {
    if (!context.mounted) {
      return;
    }

    context.read<CoursePurchasingBloc>().add(
      CoursePurchasingRequestEvent(
        userId: userProfile.id,
        courseId: courseId,
      ),
    );
  }
}

class _PurchaseButtonLabel extends StatelessWidget {
  final int priceInCoins;
  final String label;
  final bool compact;

  const _PurchaseButtonLabel({
    required this.priceInCoins,
    required this.label,
    required this.compact,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final textStyle = (compact
            ? theme.textTheme.bodySmall
            : theme.textTheme.bodyLarge)
        ?.copyWith(
          color: theme.colorScheme.onPrimary,
          fontWeight: FontWeight.w600,
        );

    if (priceInCoins == 0) {
      return Text(
        label,
        style: textStyle,
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: textStyle,
        ),
        SizedBox(width: compact ? 6 : 8),
        CoinAmount(
          amount: priceInCoins,
          style: textStyle,
          iconColor: theme.colorScheme.onPrimary,
        ),
      ],
    );
  }
}
