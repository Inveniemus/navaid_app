import 'package:flutter/material.dart';

import 'sandbox_form_page.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'NAVAID',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                letterSpacing: 4,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Holding Patterns\nTrainer',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                color: Colors.grey,
                letterSpacing: 2,
              ),
            ),

            const SizedBox(height: 80),
            SizedBox(
              width: 250,
              child: ElevatedButton(
                onPressed: null, // Disabled for now
                child: const Text('TUTORIALS'),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 250,
              child: ElevatedButton(
                onPressed: null, // Disabled for now
                child: const Text('MISSIONS'),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 250,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SandboxFormPage(),
                    ),
                  );
                },
                child: const Text('SANDBOX'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
