import 'dart:math' as math;

import 'package:flame/components.dart';

class AtmosphericModel {
  double windSpeed;
  double windDirection;

  AtmosphericModel({
    this.windSpeed = 20.0,
    this.windDirection = 90.0,
  });

  double get windDirRad => windDirection * math.pi / 180;

  double get windVx => -windSpeed * math.sin(windDirRad);

  double get windVy => windSpeed * math.cos(windDirRad);

  Vector2 get windVelocity => Vector2(windVx, windVy);
}