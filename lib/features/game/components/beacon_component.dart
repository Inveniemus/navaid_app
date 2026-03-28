import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../../../core/app_colors.dart';
import 'holding_pattern_component.dart';

class BeaconComponent extends PositionComponent {
  final HoldingPatternComponent? holdingPattern;

  BeaconComponent({
    required Vector2 position,
    this.holdingPattern,
  }) : super(
    position: position,
    size: Vector2.all(0.3),
    anchor: Anchor.center,
  );

  final _paint = Paint()
    ..color = AppColors.beacon
    ..style = PaintingStyle.fill;

  @override
  Future<void> onLoad() async {
    if (holdingPattern != null) {
      holdingPattern!.position = size / 2;
      holdingPattern!.priority = -1;
      add(holdingPattern!);
    }
  }

  @override
  void render(Canvas canvas) {
    final path = Path();

    path.moveTo(size.x / 2, 0);
    path.lineTo(size.x, size.y);
    path.lineTo(0, size.y);
    path.close();

    canvas.drawPath(path, _paint);
  }
}