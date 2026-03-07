import 'dart:math' as math;
import 'package:flame/components.dart';

class AirplaneModel {
  Vector2 position;
  double heading;
  double speed;
  double turnRate;

  AirplaneModel({
    required this.position,
    this.heading = 0.0,
    this.speed = 120.0, // Noeuds (kt)
    this.turnRate = 3.0, // Degrés par seconde
  });

  void update(double dt, double targetHeading) {
    double error = ((targetHeading - heading + 540) % 360) - 180;
    double maxTurn = turnRate * dt;

    if (error.abs() < maxTurn) {
      heading = targetHeading;
    } else {
      if (error > 0) {
        heading += maxTurn;
      } else {
        heading -= maxTurn;
      }
    }
    heading = (heading + 360) % 360;

    double angleRad = (heading - 90) * (math.pi / 180);

    double distanceNm = (speed / 3600) * dt;

    position.x += distanceNm * math.cos(angleRad);
    position.y += distanceNm * math.sin(angleRad);
  }
}