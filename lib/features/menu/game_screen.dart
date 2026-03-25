import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../game/models/game_configuration.dart';
import '../game/navaid_game.dart';
import '../instruments/widgets/instrument_panel.dart';

class GameScreen extends StatefulWidget {
  final GameConfiguration config;

  const GameScreen({super.key, required this.config});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late final NavaidGame game;

  @override
  void initState() {
    super.initState();
    game = NavaidGame(config: widget.config);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GameWidget(
            game: game,
            overlayBuilderMap: {
              'InstrumentPanel': (BuildContext context, NavaidGame gameRef) {
                return InstrumentPanel(game: gameRef);
              },
            },
            initialActiveOverlays: const ['InstrumentPanel'],
          ),
          Positioned(
            top: 5,
            left: 5,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 15),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
