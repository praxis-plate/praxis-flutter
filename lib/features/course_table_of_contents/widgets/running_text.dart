import 'package:flutter/material.dart';

class RunningText extends StatefulWidget {
  const RunningText({super.key, required this.text, this.additionalWidth = 30});

  final Text text;
  final int additionalWidth;

  @override
  State<RunningText> createState() => _RunningTextState();
}

class _RunningTextState extends State<RunningText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late double textWidth;

  @override
  void initState() {
    textWidth = _getTextWidth(widget.text.data ?? '', widget.text.style);

    _controller = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..repeat();

    _animation = Tween<double>(begin: 0, end: -1).animate(_controller);
    super.initState();
  }

  double _getTextWidth(String text, TextStyle? style) {
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    return textPainter.size.width;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(
            _animation.value * (textWidth * 2 + widget.additionalWidth),
            0,
          ),
          child: widget.text,
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
