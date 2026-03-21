import 'package:codium/core/widgets/common/svg_asset.dart';
import 'package:codium/s.dart';
import 'package:flutter/material.dart';

class CoinBalanceWidget extends StatelessWidget {
  final int balance;
  final bool compact;
  final String iconAssetPath;

  const CoinBalanceWidget({
    required this.balance,
    this.compact = false,
    this.iconAssetPath = 'assets/icons/currency/default.svg',
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (compact) {
      return _CompactBalance(balance: balance, iconAssetPath: iconAssetPath);
    }

    return _FullBalance(balance: balance, iconAssetPath: iconAssetPath);
  }
}

class _CompactBalance extends StatelessWidget {
  final int balance;
  final String iconAssetPath;

  const _CompactBalance({required this.balance, required this.iconAssetPath});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgAsset(iconAssetPath, width: 18, height: 18),
          const SizedBox(width: 6),
          Text(
            balance.toString(),
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _FullBalance extends StatelessWidget {
  final int balance;
  final String iconAssetPath;

  const _FullBalance({required this.balance, required this.iconAssetPath});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              shape: BoxShape.circle,
            ),
            child: SvgAsset(iconAssetPath, width: 24, height: 24),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                s.balance,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                balance.toString(),
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
