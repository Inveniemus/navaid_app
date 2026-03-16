import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:navaid_app/features/game/components/wind_indicator.dart';

import '../../core/app_colors.dart';
import 'components/airplane_component.dart';
import 'components/beacon_component.dart';
import 'components/trail_component.dart';
import 'models/airplane_model.dart';
import 'models/atmospheric_model.dart';

class NavaidGame extends FlameGame with ScaleDetector, ScrollDetector {
  final ValueNotifier<double> currentHeading = ValueNotifier(0.0);
  final ValueNotifier<double> targetHeading = ValueNotifier(360.0);

  final ValueNotifier<double> bearingToStation = ValueNotifier(45.0);

  double bugTurnRate = 0.0;

  final double maxBugSpeed = 60.0;

  late final AirplaneComponent _airplaneComponent;
  late final AirplaneModel _airplaneModel;
  late final AtmosphericModel atmosphericModel;
  late final BeaconComponent _beacon;
  late final TrailComponent _trail;
  late final WindIndicatorComponent _windIndicator;

  double _zoomLevel = 40.0;
  final double _minZoom = 10.0;
  final double _maxZoom = 100.0;

  late double _startZoom;

  @override
  Color backgroundColor() => AppColors.mapBackground;

  @override
  Future<void> onLoad() async {
    camera.viewfinder.anchor = const Anchor(0.5, 0.25);
    camera.viewfinder.zoom = _zoomLevel;

    _beacon = BeaconComponent(position: Vector2.zero());
    world.add(_beacon);

    _airplaneModel = AirplaneModel(position: Vector2(-2, 2), heading: 0);
    atmosphericModel = AtmosphericModel();

    _windIndicator = WindIndicatorComponent();
    world.add(_windIndicator);
    camera.viewport.add(_windIndicator);

    _trail = TrailComponent(model: _airplaneModel);
    world.add(_trail);

    _airplaneComponent = AirplaneComponent();
    world.add(_airplaneComponent);
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (bugTurnRate != 0) {
      double newHeading =
          targetHeading.value + (bugTurnRate * maxBugSpeed * dt);
      targetHeading.value = (newHeading + 360) % 360;
    }

    _airplaneModel.updateHeading(dt, targetHeading.value);
    Vector2 groundVelocity =
        _airplaneModel.airVelocity + atmosphericModel.windVelocity;
    _airplaneModel.updatePosition(groundVelocity * (dt / 3600));

    _airplaneComponent.position = _airplaneModel.position;
    _airplaneComponent.angle = _airplaneModel.heading * math.pi / 180;
    currentHeading.value = _airplaneModel.heading;

    if (_airplaneComponent.isMounted) {
      final diff = _beacon.position - _airplaneModel.position;
      double bearing = (math.atan2(diff.y, diff.x) * 180 / math.pi) + 90;
      bearingToStation.value = (bearing + 360) % 360;
    }
  }

  @override
  void onScaleStart(ScaleStartInfo info) {
    _startZoom = _zoomLevel;
  }

  @override
  void onScaleUpdate(ScaleUpdateInfo info) {
    camera.moveBy(-info.delta.global / camera.viewfinder.zoom);

    if (info.pointerCount > 1) {
      _zoomLevel = _startZoom * info.scale.global.y;
      _zoomLevel = _zoomLevel.clamp(_minZoom, _maxZoom);
      camera.viewfinder.zoom = _zoomLevel;
    }
  }

  @override
  void onScroll(PointerScrollInfo info) {
    _zoomLevel -= info.scrollDelta.global.y * 0.05;
    _zoomLevel = _zoomLevel.clamp(_minZoom, _maxZoom);
    camera.viewfinder.zoom = _zoomLevel;
  }
}
