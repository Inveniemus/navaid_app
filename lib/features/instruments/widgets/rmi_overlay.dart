import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/app_colors.dart';
import '../../game/navaid_game.dart';
import '../painters/rmi_painters.dart';

class RmiOverlayWidget extends StatefulWidget {
  final NavaidGame game;

  const RmiOverlayWidget({super.key, required this.game});

  @override
  State<RmiOverlayWidget> createState() => _RmiOverlayWidgetState();
}

class _RmiOverlayWidgetState extends State<RmiOverlayWidget> {

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 250,
          height: 250,
          child: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: AppColors.instrumentBackground,
                  shape: BoxShape.circle,
                ),
              ),

              ValueListenableBuilder<double>(
                valueListenable: widget.game.currentHeading,
                builder: (context, currentHdg, child) {
                  return Transform.rotate(
                    angle: -currentHdg * math.pi / 180,
                    child: Stack(
                      children: [
                        CustomPaint(
                          size: const Size(250, 250),
                          painter: RMIRosePainter(),
                        ),
                        ValueListenableBuilder<double>(
                          valueListenable: widget.game.targetHeading,
                          builder: (context, targetHdg, child) {
                            return CustomPaint(
                              size: const Size(250, 250),
                              painter: RMIBugPainter(targetHeading: targetHdg.round()),
                            );
                          },
                        ),
                        ValueListenableBuilder<double>(
                          valueListenable: widget.game.bearingToStation,
                          builder: (context, bearing, child) {
                            return CustomPaint(
                              size: const Size(250, 250),
                              painter: RMINeedlePainter(bearing: bearing),
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),

              CustomPaint(
                size: const Size(250, 250),
                painter: RMIAirplanePainter(),
              ),

              CustomPaint(
                size: const Size(250, 250),
                painter: RMIMarksPainter(),
              ),

              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTapUp: (details) {
                    if (details.localPosition.dx < 25) {
                      widget.game.targetHeading.value = ((widget.game.targetHeading.value - 1 + 360) % 360).roundToDouble();
                    }
                    else {
                      widget.game.targetHeading.value = ((widget.game.targetHeading.value + 1) % 360).roundToDouble();
                    }
                  },

                  onPanUpdate: (details) {
                    double offsetFromCenter = details.localPosition.dx - 25;
                    double turnRate = (offsetFromCenter / 40).clamp(-1.0, 1.0);
                    widget.game.bugTurnRate = turnRate;
                  },

                  onPanEnd: (details) {
                    widget.game.bugTurnRate = 0.0;
                    widget.game.targetHeading.value = widget.game.targetHeading.value.roundToDouble();
                  },

                  child: CustomPaint(
                    size: const Size(50, 50),
                    painter: RMIKnobPainter(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
