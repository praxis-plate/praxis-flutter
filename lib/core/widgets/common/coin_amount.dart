import 'package:flutter/material.dart';

class CoinAmount extends StatelessWidget {
  final int amount;
  final TextStyle? style;
  final double iconSize;
  final Color? iconColor;

  const CoinAmount({
    super.key,
    required this.amount,
    this.style,
    this.iconSize = 16,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveIconColor = iconColor ?? theme.colorScheme.primary;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.monetization_on, size: iconSize, color: effectiveIconColor),
        const SizedBox(width: 4),
        Text('$amount', style: style),
      ],
    );
  }
}
