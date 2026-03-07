import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../../instruments/painters/rmi_painters.dart';

class AirplaneComponent extends CustomPainterComponent {
  AirplaneComponent() : super(
    painter: RMIAirplanePainter(),
    size: Vector2.all(30),
    scale: Vector2.all(1 / 40.0), // 1 / Zoom de la caméra
    anchor: Anchor.center,
  );
}