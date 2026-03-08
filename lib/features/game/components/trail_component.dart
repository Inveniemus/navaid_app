import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:navaid_app/core/app_colors.dart';
import '../models/airplane_model.dart';

class TrailComponent extends PositionComponent {
  final AirplaneModel model;
  final Paint _paint;

  TrailComponent({required this.model})
      : _paint = Paint()
    ..color = AppColors.trail
    ..style = PaintingStyle.stroke
    ..strokeWidth = 0.05
    ..strokeCap = StrokeCap.round,
        super(anchor: Anchor.center);

  @override
  void render(Canvas canvas) {
    if (model.trailPoints.length < 2) return;

    final path = Path();
    path.moveTo(model.trailPoints.first.x, model.trailPoints.first.y);

    for (int i = 1; i < model.trailPoints.length; i++) {
      path.lineTo(model.trailPoints[i].x, model.trailPoints[i].y);
    }

    path.lineTo(model.position.x, model.position.y);

    canvas.drawPath(path, _paint);
  }
}