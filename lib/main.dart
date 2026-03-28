import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/app_theme.dart';
import 'features/menu/landing_page.dart';
import 'features/menu/sandbox_form_page.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: NavaidApp()));
}

class NavaidApp extends ConsumerWidget {
  const NavaidApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(appThemeProvider);
    
    return MaterialApp(
      title: 'Holding Patterns Trainer',
      debugShowCheckedModeBanner: false,
      theme: theme.darkTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => const LandingPage(),
        '/sandbox': (context) => const SandboxFormPage(),
      },
    );
  }
}
