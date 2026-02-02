import 'dart:math';

import 'package:codium/core/widgets/background/bubble_particle.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';

class BubbleFieldController extends ChangeNotifier {
  BubbleFieldController({
    required TickerProvider vsync,
    this.bubbleCount = 14,
    this.minRadius = 80,
    this.maxRadius = 200,
    this.speed = 0.35,
    List<int>? colors,
  }) : assert(bubbleCount > 0),
       assert(minRadius >= 0),
       assert(maxRadius >= minRadius),
       assert(speed >= 0),
       _colors = colors {
    _ticker = vsync.createTicker(_onTick)..start();
  }

  final int bubbleCount;
  final double minRadius;
  final double maxRadius;
  final double speed;
  final List<int>? _colors;

  final Random _random = Random();
  final List<BubbleParticle> bubbles = [];

  late final Ticker _ticker;
  Duration _lastElapsed = Duration.zero;
  double _width = 0;
  double _height = 0;

  List<int> get palette => (_colors == null || _colors.isEmpty)
      ? const [0xFF4DD6FF, 0xFFFFC857, 0xFF8DFF9B, 0xFFFF6B9C, 0xFF7E9BFF]
      : _colors;

  void updateSize({required double width, required double height}) {
    if (width <= 0 || height <= 0) {
      return;
    }

    if (width == _width && height == _height) {
      return;
    }

    _width = width;
    _height = height;
    bubbles
      ..clear()
      ..addAll(_generateBubbles(width: width, height: height));
  }

  void _onTick(Duration elapsed) {
    if (_width <= 0 || _height <= 0) {
      _lastElapsed = elapsed;
      return;
    }

    final double dt = (elapsed - _lastElapsed).inMicroseconds / 1000000.0;
    _lastElapsed = elapsed;
    if (dt <= 0) {
      return;
    }

    for (int i = 0; i < bubbles.length; i += 1) {
      final BubbleParticle bubble = bubbles[i];
      final double phase = bubble.phase + dt * 0.6;
      double x = bubble.x + bubble.vx * dt * speed;
      double y = bubble.y + bubble.vy * dt * speed;

      final double wiggleX = sin(phase) * bubble.wiggle;
      final double wiggleY = cos(phase * 0.7) * bubble.wiggle;

      x = _wrapX(x, bubble.radius);
      y = _wrapY(y, bubble.radius);

      bubbles[i] = bubble.copyWith(
        x: x,
        y: y,
        phase: phase,
        wiggleX: wiggleX,
        wiggleY: wiggleY,
      );
    }

    notifyListeners();
  }

  List<BubbleParticle> _generateBubbles({
    required double width,
    required double height,
  }) {
    final List<int> colors = palette;

    return List<BubbleParticle>.generate(bubbleCount, (index) {
      final double radius =
          minRadius + _random.nextDouble() * (maxRadius - minRadius);
      final double x = _random.nextDouble() * width;
      final double y = _random.nextDouble() * height;
      final double vx = (_random.nextDouble() - 0.4) * 60;
      final double vy = (_random.nextDouble() - 0.6) * 40;
      final int color = colors[index % colors.length];

      return BubbleParticle(
        x: x,
        y: y,
        vx: vx,
        vy: vy,
        radius: radius,
        color: color,
        wiggle: 12 + _random.nextDouble() * 16,
        phase: _random.nextDouble() * pi * 2,
      );
    });
  }

  double _wrapX(double x, double radius) {
    if (x < -radius) {
      return _width + radius;
    }
    if (x > _width + radius) {
      return -radius;
    }
    return x;
  }

  double _wrapY(double y, double radius) {
    if (y < -radius) {
      return _height + radius;
    }
    if (y > _height + radius) {
      return -radius;
    }
    return y;
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }
}
