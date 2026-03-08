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
  double _sliderValue = 0.0;

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
                  return Stack(
                    children: [
                      CustomPaint(
                        size: const Size(250, 250),
                        painter: RMIRosePainter(currentHeading: currentHdg),
                      ),
                      ValueListenableBuilder<double>(
                        valueListenable: widget.game.bearingToStation,
                        builder: (context, bearing, child) {
                          return CustomPaint(
                            size: const Size(250, 250),
                            painter: RMINeedlePainter(
                              currentHeading: currentHdg,
                              bearing: bearing,
                            ),
                          );
                        },
                      ),
                      ValueListenableBuilder<double>(
                        valueListenable: widget.game.targetHeading,
                        builder: (context, targetHdg, child) {
                          return CustomPaint(
                            size: const Size(250, 250),
                            painter: RMIBugPainter(
                              currentHeading: currentHdg,
                              targetHeading: targetHdg,
                            ),
                          );
                        },
                      ),
                    ],
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
            ],
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: 250,
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackShape: const RectangularSliderTrackShape(),
              activeTrackColor: AppColors.controlInactive,
              thumbColor: AppColors.controlActive,
              inactiveTrackColor: AppColors.controlInactive,
              overlayColor: AppColors.controlActive.withValues(alpha: 0.2),
            ),
            child: Slider(
              value: _sliderValue,
              min: -1.0,
              max: 1.0,
              onChanged: (val) {
                setState(() {
                  _sliderValue = val;
                  widget.game.bugTurnRate = val;
                });
              },
              onChangeEnd: (val) {
                setState(() {
                  _sliderValue = 0.0;
                  widget.game.bugTurnRate = 0.0;
                });
              },
            ),
          ),
        ),
      ],
    );
  }
}