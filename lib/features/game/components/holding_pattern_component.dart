import 'dart:math' as math;
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../../../core/app_colors.dart';

class HoldingPatternComponent extends PositionComponent {
  final double inboundCourse;
  final bool isStandard;
  final double legDistance;
  final double tas;

  HoldingPatternComponent({
    required this.inboundCourse,
    required this.isStandard,
    required this.legDistance,
    required this.tas,
  });

  final _paint = Paint()
    ..color = AppColors.beacon
    ..style = PaintingStyle.stroke
    ..strokeWidth = 0.05;

  late Path _path;

  @override
  Future<void> onLoad() async {
    angle = inboundCourse * math.pi / 180;

    double radius = tas / (60 * math.pi);
    int dir = isStandard ? 1 : -1;

    final fullPath = Path();
    fullPath.moveTo(0, legDistance);
    fullPath.lineTo(0, 0);
    fullPath.arcToPoint(
      Offset(2 * radius * dir, 0),
      radius: Radius.circular(radius),
      clockwise: isStandard,
    );
    fullPath.lineTo(2 * radius * dir, legDistance);
    fullPath.arcToPoint(
      Offset(0, legDistance),
      radius: Radius.circular(radius),
      clockwise: isStandard,
    );

    final metrics = fullPath.computeMetrics().toList();
    _path = Path();

    if (metrics.isNotEmpty) {
      final metric = metrics.first;
      final double gap = 0.2;

      final path1 = metric.extractPath(0, legDistance - gap);
      final path2 = metric.extractPath(legDistance + gap, metric.length);

      _path.addPath(path1, Offset.zero);
      _path.addPath(path2, Offset.zero);
    }

    final textStr = inboundCourse.round().toString().padLeft(3, '0');

    final textComponent = TextComponent(
      text: textStr,
      textRenderer: TextPaint(
        style: const TextStyle(
          color: AppColors.beacon,
          fontSize: 0.4,
          fontFamily: 'Courier',
          fontWeight: FontWeight.bold,
        ),
      ),
      anchor: Anchor.center,
      position: Vector2(dir * 0.6, legDistance / 2),
    );

    if (inboundCourse > 90 && inboundCourse < 270) {
      textComponent.angle = math.pi;
    }

    add(textComponent);
  }

  @override
  void render(Canvas canvas) {
    canvas.drawPath(_path, _paint);

    final arrowPath = Path();
    arrowPath.moveTo(0, legDistance / 2 - 0.2);
    arrowPath.lineTo(-0.1, legDistance / 2 + 0.1);
    arrowPath.moveTo(0, legDistance / 2 - 0.2);
    arrowPath.lineTo(0.1, legDistance / 2 + 0.1);
    canvas.drawPath(arrowPath, _paint);
  }
}