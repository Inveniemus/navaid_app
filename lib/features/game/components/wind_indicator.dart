import 'dart:math' as math;
import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import '../navaid_game.dart';

class WindIndicatorComponent extends HudMarginComponent with HasGameReference<NavaidGame> {
  late TextComponent _textComponent;
  late Path _arrowPath;

  final Paint _arrowPaint = Paint()
    ..color = Colors.lightBlueAccent
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2
    ..strokeCap = StrokeCap.round;

  WindIndicatorComponent() : super(
    margin: const EdgeInsets.only(top: 20, right: 40),
  );

  @override
  Future<void> onLoad() async {
    _arrowPath = Path()
      ..moveTo(0, -15)
      ..lineTo(-6, -5)
      ..moveTo(0, -15)
      ..lineTo(6, -5)
      ..moveTo(0, -15)
      ..lineTo(0, 15);

    _textComponent = TextComponent(
      text: '',
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontFamily: 'Courier',
        ),
      ),
      anchor: Anchor.topCenter,
      position: Vector2(0, 15),
    );

    add(_textComponent);
  }

  @override
  void update(double dt) {
    super.update(dt);

    final atmosphere = game.atmosphericModel;
    final speed = atmosphere.windSpeed.round();
    final dir = atmosphere.windDirection.round().toString().padLeft(3, '0');

    if (speed == 0) {
      _textComponent.text = 'WIND\nCALM';
    } else {
      _textComponent.text = '$dir°/${speed}kt';
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final atmosphere = game.atmosphericModel;

    if (atmosphere.windSpeed > 0) {
      canvas.save();

      double rotationAngle = (atmosphere.windDirection + 180) % 360;
      canvas.rotate(rotationAngle * math.pi / 180);

      canvas.drawPath(_arrowPath, _arrowPaint);
      canvas.restore();
    }
  }
}