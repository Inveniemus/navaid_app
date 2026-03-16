import 'dart:math' as math;
import 'package:flame/components.dart';

class AirplaneModel {
  Vector2 position;
  double heading;
  double speed;
  double turnRate;

  final List<Vector2> trailPoints = [];
  Vector2 _lastTrailPoint;

  AirplaneModel({
    required this.position,
    this.heading = 0.0,
    this.speed = 120.0,
    this.turnRate = 3.0,
  }) : _lastTrailPoint = position.clone();

  void updateHeading(double dt, double targetHeading) {
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
  }

  Vector2 get airVelocity {
    double angleRad = (heading - 90) * (math.pi / 180);
    return Vector2(speed * math.cos(angleRad), speed * math.sin(angleRad));
  }

  void updatePosition(Vector2 groundMovement) {
    position.add(groundMovement);

    if (position.distanceTo(_lastTrailPoint) > 0.05) {
      trailPoints.add(position.clone());
      _lastTrailPoint = position.clone();

      if (trailPoints.length > 2000) {
        trailPoints.removeAt(0);
      }
    }
  }
}