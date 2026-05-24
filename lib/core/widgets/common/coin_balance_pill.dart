import 'package:flutter/material.dart';
import 'package:praxis/core/widgets/common/svg_asset.dart';

class CoinBalancePill extends StatelessWidget {
  const CoinBalancePill({super.key, required this.amount});

  final int amount;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.6)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SvgAsset(
            'assets/icons/currency/default.svg',
            width: 16,
            height: 16,
          ),
          const SizedBox(width: 4),
          Text(
            '$amount',
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.9),
            ),
          ),
        ],
      ),
    );
  }
}
