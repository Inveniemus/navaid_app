import 'package:flutter/material.dart';

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
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 350,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.black87,
          border: Border(top: BorderSide(color: Colors.grey[800]!, width: 2)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 250,
              height: 250,
              child: Stack(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFF111111),
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
                          // 3. AIGUILLE ADF (Jaune)
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

                  // 5. MAQUETTE AVION (Fixe au centre)
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
                  trackShape: RectangularSliderTrackShape(),
                  activeTrackColor: Colors.grey[800],
                  thumbColor: Colors.cyanAccent,
                  inactiveTrackColor: Colors.grey[800],
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
        ),
      ),
    );
  }
}