import 'dart:ui';

import 'package:codium/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class GlassTextField extends StatefulWidget {
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
  State<GlassTextField> createState() => _GlassTextFieldState();
}

class _GlassTextFieldState extends State<GlassTextField> {
  late final FocusScopeNode _focusScopeNode;

  @override
  void initState() {
    super.initState();
    _focusScopeNode = FocusScopeNode();
    _focusScopeNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    _focusScopeNode.removeListener(_handleFocusChange);
    _focusScopeNode.dispose();
    super.dispose();
  }

  void _handleFocusChange() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final surface = theme.colorScheme.surface.withValues(alpha: 0.24);
    final stroke = theme.colorScheme.onSurface.withValues(alpha: 0.18);
    final isFocused = _focusScopeNode.hasFocus && widget.enabled;
    final resolvedBorderColor =
        widget.borderColor ??
        (isFocused ? theme.colorScheme.primary.withValues(alpha: 0.7) : stroke);
    final resolvedBorderWidth = isFocused
        ? widget.borderWidth + 0.5
        : widget.borderWidth;
    final fallbackGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Colors.white.withValues(alpha: 0.16),
        Colors.white.withValues(alpha: 0.04),
      ],
    );

    final inputDecorationTheme =
        theme.extension<GlassTextFieldTheme>()?.inputDecorationTheme ??
        theme.inputDecorationTheme;

    return Opacity(
      opacity: widget.enabled ? 1 : 0.4,
      child: ClipRRect(
        borderRadius: widget.borderRadius,
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: widget.blurSigma,
            sigmaY: widget.blurSigma,
          ),
          child: Container(
            padding: widget.padding,
            decoration: BoxDecoration(
              color: widget.backgroundColor ?? surface,
              gradient: widget.gradient ?? fallbackGradient,
              border: Border.all(
                color: resolvedBorderColor,
                width: resolvedBorderWidth,
              ),
              borderRadius: widget.borderRadius,
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
              child: FocusScope(node: _focusScopeNode, child: widget.child),
            ),
          ),
        ),
      ),
    );
  }
}
