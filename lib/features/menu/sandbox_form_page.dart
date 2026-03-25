import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../game/models/game_configuration.dart';
import 'game_screen.dart';
import 'sandbox_config_provider.dart';

class SandboxFormPage extends ConsumerWidget {
  const SandboxFormPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(sandboxConfigNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sandbox Configuration'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Aircraft Initial State'),
            _buildNumberField(
              label: 'Position X (NM)',
              value: config.aircraftInitialPosition.x,
              onChanged: (val) {
                ref.read(sandboxConfigNotifierProvider.notifier).updateAircraftPositionX(val);
              },
            ),
            const SizedBox(height: 10),
            _buildNumberField(
              label: 'Position Y (NM)',
              value: config.aircraftInitialPosition.y,
              onChanged: (val) {
                ref.read(sandboxConfigNotifierProvider.notifier).updateAircraftPositionY(val);
              },
            ),
            const SizedBox(height: 10),
            _buildNumberField(
              label: 'Heading (Degrees)',
              value: config.aircraftInitialHeading,
              onChanged: (val) {
                ref.read(sandboxConfigNotifierProvider.notifier).updateAircraftHeading(val);
              },
            ),
            const SizedBox(height: 10),
            _buildNumberField(
              label: 'Speed (KTAS)',
              value: config.aircraftSpeed,
              onChanged: (val) {
                ref.read(sandboxConfigNotifierProvider.notifier).updateAircraftSpeed(val);
              },
            ),

            const SizedBox(height: 30),
            _buildSectionTitle('Beacon Settings'),
            _buildNumberField(
              label: 'Position X (NM)',
              value: config.beaconPosition.x,
              onChanged: (val) {
                ref.read(sandboxConfigNotifierProvider.notifier).updateBeaconPositionX(val);
              },
            ),
            const SizedBox(height: 10),
            _buildNumberField(
              label: 'Position Y (NM)',
              value: config.beaconPosition.y,
              onChanged: (val) {
                ref.read(sandboxConfigNotifierProvider.notifier).updateBeaconPositionY(val);
              },
            ),

            const SizedBox(height: 30),
            _buildSectionTitle('Atmosphere'),
            _buildNumberField(
              label: 'Wind Direction (Degrees)',
              value: config.windDirection,
              onChanged: (val) {
                ref.read(sandboxConfigNotifierProvider.notifier).updateWindDirection(val);
              },
            ),
            const SizedBox(height: 10),
            _buildNumberField(
              label: 'Wind Speed (KT)',
              value: config.windSpeed,
              onChanged: (val) {
                ref.read(sandboxConfigNotifierProvider.notifier).updateWindSpeed(val);
              },
            ),

            const SizedBox(height: 50),
            Center(
              child: SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GameScreen(config: config),
                      ),
                    );
                  },
                  child: const Text('LAUNCH'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.orange,
        ),
      ),
    );
  }

  Widget _buildNumberField({
    required String label,
    required double value,
    required Function(double) onChanged,
  }) {
    return TextFormField(
      initialValue: value.toString(),
      keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
      decoration: InputDecoration(
        labelText: label,
      ),
      onChanged: (val) {
        final parsed = double.tryParse(val);
        if (parsed != null) {
          onChanged(parsed);
        }
      },
    );
  }
}
