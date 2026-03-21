import 'package:codium/core/widgets/common/svg_asset.dart';
import 'package:flutter/material.dart';

class CoinAmount extends StatelessWidget {
  final int amount;
  final TextStyle? style;
  final double iconSize;
  final Color? iconColor;
  final String iconAssetPath;

  const CoinAmount({
    super.key,
    required this.amount,
    this.style,
    this.iconSize = 16,
    this.iconColor,
    this.iconAssetPath = 'assets/icons/currency/default.svg',
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveIconColor = iconColor ?? theme.colorScheme.primary;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgAsset(
          iconAssetPath,
          width: iconSize,
          height: iconSize,
          color: effectiveIconColor,
        ),
        const SizedBox(width: 4),
        Text('$amount', style: style),
      ],
    );
  }
}
