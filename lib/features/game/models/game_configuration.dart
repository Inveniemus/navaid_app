import 'dart:math' as math;
import 'package:flame/components.dart';

class GameConfiguration {
  final Vector2 aircraftInitialPosition;
  final double aircraftInitialHeading;
  final double aircraftSpeed;

  final Vector2 beaconPosition;

  final double windSpeed;
  final double windDirection;

  final double minZoom;
  final double maxZoom;

  const GameConfiguration({
    required this.aircraftInitialPosition,
    this.aircraftInitialHeading = 0.0,
    this.aircraftSpeed = 120.0,
    required this.beaconPosition,
    this.windSpeed = 0.0,
    this.windDirection = 0.0,
    this.minZoom = 1.0,
    this.maxZoom = 200.0,
  });

  factory GameConfiguration.defaultConfig() {
    return GameConfiguration(
      aircraftInitialPosition: Vector2(2, 2),
      beaconPosition: Vector2.zero(),
    );
  }

  GameConfiguration copyWith({
    Vector2? aircraftInitialPosition,
    double? aircraftInitialHeading,
    double? aircraftSpeed,
    Vector2? beaconPosition,
    double? windSpeed,
    double? windDirection,
    double? minZoom,
    double? maxZoom,
  }) {
    return GameConfiguration(
      aircraftInitialPosition: aircraftInitialPosition ?? this.aircraftInitialPosition,
      aircraftInitialHeading: aircraftInitialHeading ?? this.aircraftInitialHeading,
      aircraftSpeed: aircraftSpeed ?? this.aircraftSpeed,
      beaconPosition: beaconPosition ?? this.beaconPosition,
      windSpeed: windSpeed ?? this.windSpeed,
      windDirection: windDirection ?? this.windDirection,
      minZoom: minZoom ?? this.minZoom,
      maxZoom: maxZoom ?? this.maxZoom,
    );
  }

  Vector2 getInitialCameraPosition() {
    return (aircraftInitialPosition + beaconPosition) / 2;
  }

  double getInitialZoom(Vector2 viewportSize) {
    if (viewportSize.x == 0 || viewportSize.y == 0) return 40.0;

    double width = (aircraftInitialPosition.x - beaconPosition.x).abs();
    double height = (aircraftInitialPosition.y - beaconPosition.y).abs();
    
    if (width == 0 && height == 0) return 40.0;

    width *= 3;
    height *= 3;

    double zoomX = viewportSize.x / width;
    double zoomY = viewportSize.y / height;

    double zoom = math.min(zoomX, zoomY);
    return zoom.clamp(minZoom, maxZoom);
  }
}
