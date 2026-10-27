import 'package:flutter/material.dart';

import 'services/app_state.dart';
import 'widgets/app_shell.dart';

final kColorScheme = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(255, 96, 59, 181),
);

final kDarkColorScheme = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  seedColor: const Color.fromARGB(255, 5, 99, 125),
);

ThemeData buildTheme(ColorScheme scheme) {
  final base = ThemeData(useMaterial3: true, colorScheme: scheme);

  return base.copyWith(
    scaffoldBackgroundColor: scheme.surface,
    appBarTheme: const AppBarTheme().copyWith(
      backgroundColor: scheme.primary,
      foregroundColor: scheme.onPrimary,
    ),
    cardTheme: const CardThemeData().copyWith(
      color: scheme.secondaryContainer,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: scheme.primaryContainer,
        foregroundColor: scheme.onPrimaryContainer,
      ),
    ),
    textTheme: base.textTheme.copyWith(
      titleLarge: TextStyle(
        fontWeight: FontWeight.bold,
        color: scheme.onSecondaryContainer,
        fontSize: 16,
      ),
    ),
  );
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await appState.load();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: appState,
      builder: (context, _) {
        return MaterialApp(
          theme: buildTheme(kColorScheme),
          darkTheme: buildTheme(kDarkColorScheme),
          themeMode: appState.themeMode,
          home: const AppShell(),
        );
      },
    );
  }
}
