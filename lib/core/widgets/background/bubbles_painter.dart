import 'package:codium/core/widgets/background/bubble_field_controller.dart';
import 'package:flutter/widgets.dart';

class BubblesPainter extends CustomPainter {
  BubblesPainter({required this.controller, required double blurSigma})
    : _paint = Paint()
        ..maskFilter = blurSigma > 0
            ? MaskFilter.blur(BlurStyle.normal, blurSigma)
            : null,
      super(repaint: controller);

  final BubbleFieldController controller;
  final Paint _paint;

  @override
  void paint(Canvas canvas, Size size) {
    for (final bubble in controller.bubbles) {
      _paint.color = Color(bubble.color).withValues(alpha: 0.35);
      final Offset center = Offset(
        bubble.x + bubble.wiggleX,
        bubble.y + bubble.wiggleY,
      );
      canvas.drawCircle(center, bubble.radius, _paint);
    }
  }

  @override
  bool shouldRepaint(covariant BubblesPainter oldDelegate) =>
      oldDelegate._paint.maskFilter != _paint.maskFilter;
}
