import 'package:praxis/core/widgets/widgets.dart';
import 'package:praxis/s.dart';
import 'package:flutter/material.dart';

class CodeCompletionInputCard extends StatelessWidget {
  final List<String> codeParts;
  final List<TextEditingController> inputControllers;

  const CodeCompletionInputCard({
    super.key,
    required this.codeParts,
    required this.inputControllers,
  });

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);
    final widgets = <Widget>[];

    for (int i = 0; i < codeParts.length; i++) {
      if (codeParts[i].isNotEmpty) {
        widgets.add(
          SelectableText(
            codeParts[i],
            style: theme.textTheme.bodyMedium?.copyWith(
              fontFamily: 'monospace',
              fontSize: 14,
              height: 1.5,
              color: theme.colorScheme.onSurface,
            ),
          ),
        );
      }

      if (i < inputControllers.length) {
        widgets.add(
          IntrinsicWidth(
            child: Theme(
              data: theme.copyWith(
                inputDecorationTheme: theme.inputDecorationTheme.copyWith(
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 6,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: theme.colorScheme.onSurface.withValues(
                        alpha: 0.12,
                      ),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: theme.colorScheme.onSurface.withValues(
                        alpha: 0.12,
                      ),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: theme.colorScheme.primary),
                  ),
                  fillColor: theme.colorScheme.surfaceContainerHighest,
                ),
              ),
              child: TextField(
                controller: inputControllers[i],
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontFamily: 'monospace',
                  fontSize: 14,
                  height: 1.5,
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
                decoration: InputDecoration(
                  constraints: const BoxConstraints(minWidth: 100),
                  hintText: s.codeCompletionPlaceholder,
                  hintStyle: theme.textTheme.bodyMedium?.copyWith(
                    fontFamily: 'monospace',
                    fontSize: 14,
                    color: theme.colorScheme.onSurfaceVariant.withValues(
                      alpha: 0.5,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }
    }

    return SurfaceCard(
      borderRadius: BorderRadius.circular(12),
      padding: const EdgeInsets.all(16),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: widgets,
      ),
    );
  }
}
