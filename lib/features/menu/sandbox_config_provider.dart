import 'package:flame/components.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../game/models/game_configuration.dart';

part 'sandbox_config_provider.g.dart';

@riverpod
class SandboxConfigNotifier extends _$SandboxConfigNotifier {
  @override
  GameConfiguration build() {
    return GameConfiguration.defaultConfig();
  }

  void updateAircraftPositionX(double x) {
    state = state.copyWith(aircraftInitialPosition: Vector2(x, state.aircraftInitialPosition.y));
  }

  void updateAircraftPositionY(double y) {
    state = state.copyWith(aircraftInitialPosition: Vector2(state.aircraftInitialPosition.x, y));
  }

  void updateAircraftHeading(double hdg) {
    state = state.copyWith(aircraftInitialHeading: hdg);
  }

  void updateAircraftSpeed(double spd) {
    state = state.copyWith(aircraftSpeed: spd);
  }

  void updateBeaconPositionX(double x) {
    state = state.copyWith(beaconPosition: Vector2(x, state.beaconPosition.y));
  }

  void updateBeaconPositionY(double y) {
    state = state.copyWith(beaconPosition: Vector2(state.beaconPosition.x, y));
  }

  void updateWindDirection(double dir) {
    state = state.copyWith(windDirection: dir);
  }

  void updateWindSpeed(double spd) {
    state = state.copyWith(windSpeed: spd);
  }

  void updateHoldingInboundCourse(double course) {
    state = state.copyWith(holdingInboundCourse: course);
  }

  void updateHoldingIsStandard(bool isStandard) {
    state = state.copyWith(holdingIsStandard: isStandard);
  }

  void updateHoldingLegDistance(double distance) {
    state = state.copyWith(holdingLegDistance: distance);
  }
}