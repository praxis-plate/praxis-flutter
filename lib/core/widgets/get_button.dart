import 'package:flutter/material.dart';

class GetButton extends StatelessWidget {
  const GetButton({
    required this.price,
    this.onPressed,
    super.key,
  });

  final VoidCallback? onPressed;
  final int? price;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onPressed ?? () {},
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: theme.colorScheme.surfaceBright,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: price == null
                ? Text(
                    'Get',
                    style: theme.textTheme.titleSmall
                        ?.copyWith(color: theme.colorScheme.primary),
                  )
                : Row(
                    children: [
                      Text(
                        '$price',
                        style: theme.textTheme.titleSmall
                            ?.copyWith(color: theme.colorScheme.primary),
                      ),
                      const SizedBox(width: 2),
                      Icon(
                        Icons.bolt,
                        color: theme.colorScheme.primary,
                        size: 18,
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
