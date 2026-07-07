import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/bubble_background.dart';
import '../widgets/azhly_logo.dart';
import 'auth_screen.dart';
import 'main_app_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _slide = Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward();

    Future.delayed(const Duration(milliseconds: 2800), () {
      if (!mounted) return;
      final state = context.read<AppState>();
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (_) => state.isAuthenticated ? const MainAppScreen() : const AuthScreen(),
      ));
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final colors = AppColors(state.isDarkMode);

    return Scaffold(
      body: BubbleBackground(
        isDark: state.isDarkMode,
        child: Center(
          child: FadeTransition(
            opacity: _fade,
            child: SlideTransition(
              position: _slide,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AzhlyLogo(size: 128, isDark: state.isDarkMode),
                  const SizedBox(height: 24),
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(colors: [AppPalette.purple, AppPalette.pink])
                        .createShader(bounds),
                    child: const Text('AZHly',
                        style: TextStyle(fontSize: 42, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: -0.5)),
                  ),
                  const SizedBox(height: 6),
                  Text('SMART ROOM BOOKING',
                      style: TextStyle(fontSize: 12, letterSpacing: 3, fontWeight: FontWeight.w600, color: colors.textMuted)),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(3, (i) {
                      final c = [AppPalette.purple, AppPalette.purple2, AppPalette.pink][i];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Container(width: 8, height: 8, decoration: BoxDecoration(shape: BoxShape.circle, color: c)),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
