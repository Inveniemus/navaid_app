import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../../../core/app_colors.dart';

class BeaconComponent extends PositionComponent {
  BeaconComponent({required Vector2 position}) : super(position: position, size: Vector2.all(0.3), anchor: Anchor.center);

  final _paint = Paint()
    ..color = AppColors.beacon
    ..style = PaintingStyle.fill;

  @override
  void render(Canvas canvas) {
    final path = Path();
    // Triangle simple
    path.moveTo(size.x / 2, 0);
    path.lineTo(size.x, size.y);
    path.lineTo(0, size.y);
    path.close();

    canvas.drawPath(path, _paint);
  }
}