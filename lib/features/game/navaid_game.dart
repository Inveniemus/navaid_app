import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import 'components/airplane_component.dart';
import 'components/beacon_component.dart';
import 'components/trail_component.dart';
import 'models/airplane_model.dart';

class NavaidGame extends FlameGame {
  final ValueNotifier<double> currentHeading = ValueNotifier(0.0);
  final ValueNotifier<double> targetHeading = ValueNotifier(360.0);

  final ValueNotifier<double> bearingToStation = ValueNotifier(45.0);

  double bugTurnRate = 0.0;

  final double maxBugSpeed = 60.0;

  late final AirplaneComponent _airplaneComponent;
  late final AirplaneModel _airplaneModel;
  late final BeaconComponent _beacon;
  late final TrailComponent _trailComponent;

  @override
  Color backgroundColor() => AppColors.mapBackground;

  @override
  Future<void> onLoad() async {
    camera.viewfinder.anchor = const Anchor(0.5, 0.25);
    camera.viewfinder.zoom = 40.0;

    _beacon = BeaconComponent(position: Vector2.zero());
    world.add(_beacon);

    _airplaneModel = AirplaneModel(position: Vector2(-3, 3), heading: 0);

    _trailComponent = TrailComponent(model: _airplaneModel);
    world.add(_trailComponent);

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

    _airplaneModel.update(dt, targetHeading.value);

    _airplaneComponent.position = _airplaneModel.position;
    _airplaneComponent.angle = _airplaneModel.heading * math.pi / 180;
    currentHeading.value = _airplaneModel.heading;

    if (_airplaneComponent.isMounted) {
      final diff = _beacon.position - _airplaneModel.position;
      double bearing = (math.atan2(diff.y, diff.x) * 180 / math.pi) + 90;
      bearingToStation.value = (bearing + 360) % 360;
    }
  }
}