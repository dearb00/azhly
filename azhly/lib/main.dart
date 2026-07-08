import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'state/app_state.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const AzhlyApp());
}

class AzhlyApp extends StatelessWidget {
  const AzhlyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppState(),
      child: MaterialApp(
        title: 'AZHly',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          fontFamily: 'Roboto',
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF7C3AED)),
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
