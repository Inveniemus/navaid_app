import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'features/game/navaid_game.dart';
import 'features/instruments/widgets/rmi_overlay.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: NavaidApp()));
}

class NavaidApp extends StatelessWidget {
  const NavaidApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IFR Trainer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late final NavaidGame game;

  @override
  void initState() {
    super.initState();
    game = NavaidGame();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GameWidget(
        game: game,
        overlayBuilderMap: {
          'InstrumentPanel': (BuildContext context, NavaidGame gameRef) {
            return RmiOverlayWidget(game: gameRef);
          },
        },
        initialActiveOverlays: const ['InstrumentPanel'],
      ),
    );
  }
}
