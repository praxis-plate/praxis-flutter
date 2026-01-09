import 'package:equatable/equatable.dart';

class BubbleParticle extends Equatable {
  const BubbleParticle({
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
    required this.radius,
    required this.color,
    required this.wiggle,
    required this.phase,
    this.wiggleX = 0,
    this.wiggleY = 0,
  });

  final double x;
  final double y;
  final double vx;
  final double vy;
  final double radius;
  final int color;
  final double wiggle;
  final double phase;
  final double wiggleX;
  final double wiggleY;

  BubbleParticle copyWith({
    double? x,
    double? y,
    double? vx,
    double? vy,
    double? radius,
    int? color,
    double? wiggle,
    double? phase,
    double? wiggleX,
    double? wiggleY,
  }) {
    return BubbleParticle(
      x: x ?? this.x,
      y: y ?? this.y,
      vx: vx ?? this.vx,
      vy: vy ?? this.vy,
      radius: radius ?? this.radius,
      color: color ?? this.color,
      wiggle: wiggle ?? this.wiggle,
      phase: phase ?? this.phase,
      wiggleX: wiggleX ?? this.wiggleX,
      wiggleY: wiggleY ?? this.wiggleY,
    );
  }

  @override
  List<Object?> get props => [
    x,
    y,
    vx,
    vy,
    radius,
    color,
    wiggle,
    phase,
    wiggleX,
    wiggleY,
  ];
}
