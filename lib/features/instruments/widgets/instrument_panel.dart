import 'package:flutter/material.dart';

import '../../../../core/app_colors.dart';
import '../../game/navaid_game.dart';
import 'rmi_overlay.dart';
import 'stopwatch_widget.dart';

class InstrumentPanel extends StatelessWidget {
  final NavaidGame game;

  const InstrumentPanel({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 350,
        width: double.infinity,
        decoration: const BoxDecoration(
          color: AppColors.panelBackground,
          border: Border(top: BorderSide(color: AppColors.panelBorder, width: 2)),
        ),
        child: Stack(
          children: [
            Center(
              child: RmiOverlayWidget(game: game),
            ),

            const Positioned(
              top: 5,
              right: 5,
              child: StopwatchWidget(),
            ),
          ],
        ),
      ),
    );
  }
}