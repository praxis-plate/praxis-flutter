import 'dart:ui';

import 'package:flutter/material.dart';

class GlassTextField extends StatelessWidget {
  const GlassTextField({
    super.key,
    required this.child,
    this.enabled = true,
    this.blurSigma = 16,
    this.borderRadius = const BorderRadius.all(Radius.circular(16)),
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
    this.backgroundColor,
    this.gradient,
    this.borderColor,
    this.borderWidth = 1,
  });

  final Widget child;
  final bool enabled;
  final double blurSigma;
  final BorderRadius borderRadius;
  final EdgeInsetsGeometry padding;
  final Color? backgroundColor;
  final Gradient? gradient;
  final Color? borderColor;
  final double borderWidth;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final surface = theme.colorScheme.surface.withValues(alpha: 0.24);
    final stroke = theme.colorScheme.onSurface.withValues(alpha: 0.18);
    final fallbackGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Colors.white.withValues(alpha: 0.16),
        Colors.white.withValues(alpha: 0.04),
      ],
    );

    // TODO: Move input theme configuration to ThemeData once theme refactoring is complete
    final inputDecorationTheme = theme.inputDecorationTheme.copyWith(
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(vertical: 8),
      border: InputBorder.none,
      enabledBorder: InputBorder.none,
      focusedBorder: InputBorder.none,
      disabledBorder: InputBorder.none,
      errorBorder: InputBorder.none,
      focusedErrorBorder: InputBorder.none,
    );

    return Opacity(
      opacity: enabled ? 1 : 0.4,
      child: ClipRRect(
        borderRadius: borderRadius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              color: backgroundColor ?? surface,
              gradient: gradient ?? fallbackGradient,
              border: Border.all(
                color: borderColor ?? stroke,
                width: borderWidth,
              ),
              borderRadius: borderRadius,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.12),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Theme(
              data: theme.copyWith(inputDecorationTheme: inputDecorationTheme),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
