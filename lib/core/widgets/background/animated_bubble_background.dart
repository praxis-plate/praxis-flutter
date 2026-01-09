import 'dart:ui';

import 'package:codium/core/widgets/background/bubbles_painter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'bubble_field_controller.dart';

class AnimatedBubbleBackground extends StatefulWidget {
  const AnimatedBubbleBackground({
    super.key,
    this.bubbleCount = 7,
    this.minRadius = 100,
    this.maxRadius = 300,
    this.blurSigma = 18,
    this.speed = 0.25,
    this.colors,
    this.controller,
  }) : assert(bubbleCount > 0),
       assert(minRadius >= 0),
       assert(maxRadius >= minRadius),
       assert(blurSigma >= 0),
       assert(speed >= 0);

  final int bubbleCount;
  final double minRadius;
  final double maxRadius;
  final double blurSigma;
  final double speed;
  final List<Color>? colors;
  final BubbleFieldController? controller;

  @override
  State<AnimatedBubbleBackground> createState() =>
      _AnimatedBubbleBackgroundState();
}

class _AnimatedBubbleBackgroundState extends State<AnimatedBubbleBackground>
    with SingleTickerProviderStateMixin {
  late bool _ownsController;
  BubbleFieldController? _controller;
  List<int>? _resolvedColors;

  @override
  void initState() {
    super.initState();
    _ownsController = widget.controller == null;
    _controller = widget.controller;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _ensureOwnedController(
      _resolveColors(context),
      forceRecreate: _controller == null,
    );
  }

  @override
  void didUpdateWidget(covariant AnimatedBubbleBackground oldWidget) {
    super.didUpdateWidget(oldWidget);

    final bool controllerChanged = widget.controller != oldWidget.controller;

    if (controllerChanged) {
      if (_ownsController) {
        _controller?.dispose();
      }

      _controller = widget.controller;
      _ownsController = widget.controller == null;
      _resolvedColors = null;

      _ensureOwnedController(_resolveColors(context), forceRecreate: true);
      return;
    }

    if (_ownsController) {
      final bool configChanged =
          widget.bubbleCount != oldWidget.bubbleCount ||
          widget.minRadius != oldWidget.minRadius ||
          widget.maxRadius != oldWidget.maxRadius ||
          widget.speed != oldWidget.speed ||
          !listEquals(widget.colors, oldWidget.colors);

      if (configChanged) {
        _ensureOwnedController(_resolveColors(context), forceRecreate: true);
      }
    }
  }

  @override
  void dispose() {
    if (_ownsController) {
      _controller?.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final BubbleFieldController? controller = _controller;
    if (controller == null) {
      return const SizedBox.shrink();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final Size size = constraints.biggest;
        controller.updateSize(width: size.width, height: size.height);

        final CustomPaint painted = CustomPaint(
          painter: BubblesPainter(
            controller: controller,
            blurSigma: widget.blurSigma,
          ),
          willChange: true,
        );

        final Widget content = widget.blurSigma <= 0
            ? painted
            : ImageFiltered(
                imageFilter: ImageFilter.blur(
                  sigmaX: widget.blurSigma,
                  sigmaY: widget.blurSigma,
                ),
                child: painted,
              );

        return ClipRect(child: SizedBox.expand(child: content));
      },
    );
  }

  void _ensureOwnedController(
    List<Color> colors, {
    required bool forceRecreate,
  }) {
    if (!_ownsController) {
      return;
    }

    final List<int> resolved = colors.map((color) => color.toARGB32()).toList();

    final bool colorsChanged = !listEquals(_resolvedColors, resolved);
    if (_controller == null || forceRecreate || colorsChanged) {
      _controller?.dispose();
      _controller = BubbleFieldController(
        vsync: this,
        bubbleCount: widget.bubbleCount,
        minRadius: widget.minRadius,
        maxRadius: widget.maxRadius,
        speed: widget.speed,
        colors: resolved,
      );
      _resolvedColors = resolved;
    }
  }

  List<Color> _resolveColors(BuildContext context) {
    final List<Color>? customColors = widget.colors;
    if (customColors != null && customColors.isNotEmpty) {
      return customColors;
    }

    final theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;

    return [
      scheme.primary,
      scheme.primaryFixed,
      scheme.primaryFixedDim,
      scheme.primaryContainer,
      scheme.secondaryContainer,
      scheme.secondary,
      scheme.error,
      scheme.errorContainer,
      theme.cardColor,
    ];
  }
}
