import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class _BubbleSpec {
  final double size, top, left, delay;
  const _BubbleSpec(this.size, this.top, this.left, this.delay);
}

const List<_BubbleSpec> _bubbles = [
  _BubbleSpec(120, 0.08, 0.10, 0.0),
  _BubbleSpec(80, 0.20, 0.75, 1.0),
  _BubbleSpec(160, 0.55, 0.05, 0.5),
  _BubbleSpec(60, 0.70, 0.60, 2.0),
  _BubbleSpec(100, 0.35, 0.85, 1.5),
  _BubbleSpec(140, 0.80, 0.30, 0.8),
  _BubbleSpec(50, 0.12, 0.45, 3.0),
  _BubbleSpec(90, 0.45, 0.50, 2.5),
  _BubbleSpec(70, 0.88, 0.80, 1.2),
  _BubbleSpec(110, 0.62, 0.20, 0.3),
];

/// Animated bubbly background — Flutter port of BubbleBackground.tsx.
class BubbleBackground extends StatefulWidget {
  final Widget child;
  final bool isDark;
  const BubbleBackground({super.key, required this.child, required this.isDark});

  @override
  State<BubbleBackground> createState() => _BubbleBackgroundState();
}

class _BubbleBackgroundState extends State<BubbleBackground> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 12))..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final darkColors = [
      const Color(0x59783CC8), const Color(0x475A28AA), const Color(0x4D8C46DC),
      const Color(0x40461E96), const Color(0x33A050F0),
    ];
    final lightColors = [
      const Color(0x73C896E6), const Color(0x61B478DC), const Color(0x6BDCA0F0),
      const Color(0x59A082D2), const Color(0x4DE6AAFA),
    ];
    final colors = widget.isDark ? darkColors : lightColors;

    return Container(
      decoration: BoxDecoration(
        color: widget.isDark ? AppPalette.navyBg : null,
        gradient: widget.isDark
            ? null
            : const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppPalette.lightBgTop, AppPalette.lightBgMid, AppPalette.lightBgBottom],
              ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final w = constraints.maxWidth.isFinite ? constraints.maxWidth : MediaQuery.of(context).size.width;
          final h = constraints.maxHeight.isFinite ? constraints.maxHeight : MediaQuery.of(context).size.height;
          // Bubble sizes were designed against a ~390-logical-pixel-wide
          // full screen; scale them down proportionally so this widget also
          // looks right when reused inside small preview cards.
          final double scale = (w / 390).clamp(0.28, 1.2).toDouble();
          return Stack(
            children: [
              AnimatedBuilder(
                animation: _controller,
                builder: (context, _) {
                  return Stack(
                    children: List.generate(_bubbles.length, (i) {
                      final b = _bubbles[i];
                      final t = (_controller.value + b.delay / 12) % 1.0;
                      final dy = sin(t * 2 * pi) * 14;
                      return Positioned(
                        top: (b.top * h) + dy,
                        left: b.left * w,
                        child: Container(
                          width: b.size * scale,
                          height: b.size * scale,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              center: const Alignment(-0.4, -0.4),
                              colors: [colors[i % colors.length], colors[i % colors.length].withValues(alpha: 0)],
                            ),
                            border: Border.all(
                              color: widget.isDark ? const Color(0x338C50E6) : const Color(0x59C896F0),
                              width: 1,
                            ),
                          ),
                        ),
                      );
                    }),
                  );
                },
              ),
              widget.child,
            ],
          );
        },
      ),
    );
  }
}
