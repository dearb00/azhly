import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Vector recreation of the AZHly logo (clock ring + hands, 3x3 colour grid,
/// cloud outline + dot) so we don't depend on external image assets.
/// [ringColor] switches per theme just like the original LOGO_NAVY/LOGO_LIGHT
/// swap — navy ring on light backgrounds, light ring on the navy dark bg.
class AzhlyLogo extends StatelessWidget {
  final double size;
  final bool isDark;
  const AzhlyLogo({super.key, this.size = 80, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final ringColor = isDark ? Colors.white : const Color(0xFF1A1350);
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _LogoPainter(ringColor: ringColor),
      ),
    );
  }
}

class _LogoPainter extends CustomPainter {
  final Color ringColor;
  _LogoPainter({required this.ringColor});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * 0.52);
    final radius = size.width * 0.42;

    // Outer broken ring (like a "C")
    final ringPaint = Paint()
      ..color = ringColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.045
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -2.6, // start angle (radians)
      5.0, // sweep angle (leaves a gap, like the reference logo)
      false,
      ringPaint,
    );

    // Clock hands from center
    final handPaint = Paint()
      ..color = ringColor
      ..strokeWidth = size.width * 0.045
      ..strokeCap = StrokeCap.round;
    // hour hand (short, pointing up)
    canvas.drawLine(center, center + Offset(0, -radius * 0.45), handPaint);
    // minute hand (long, pointing right-down)
    canvas.drawLine(center, center + Offset(radius * 0.55, radius * 0.12), handPaint);
    // center dot
    canvas.drawCircle(center, size.width * 0.03, Paint()..color = ringColor);

    // 3x3 colour grid, bottom-left quadrant
    final gridColors = [
      const Color(0xFF7FA8E8), const Color(0xFF5C7FD4), const Color(0xFF8B7FE0),
      const Color(0xFF6C63C7), const Color(0xFF9B6FD8), const Color(0xFFB07FE0),
      const Color(0xFF8B5CF6), const Color(0xFFA855F7), const Color(0xFFEC4899),
    ];
    final gridOrigin = Offset(size.width * 0.10, size.height * 0.52);
    final cell = size.width * 0.13;
    final gap = size.width * 0.03;
    var idx = 0;
    for (var row = 0; row < 3; row++) {
      for (var col = 0; col < 3; col++) {
        final rect = Rect.fromLTWH(
          gridOrigin.dx + col * (cell + gap),
          gridOrigin.dy + row * (cell + gap),
          cell,
          cell,
        );
        canvas.drawRRect(
          RRect.fromRectAndRadius(rect, Radius.circular(cell * 0.28)),
          Paint()..color = gridColors[idx % gridColors.length],
        );
        idx++;
      }
    }

    // Cloud (top-right) — simple rounded blob outline
    final cloudCenter = Offset(size.width * 0.74, size.height * 0.24);
    final cloudPaint = Paint()
      ..color = const Color(0xFFC084FC)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.035;
    final cloudR = size.width * 0.13;
    canvas.drawCircle(cloudCenter + Offset(-cloudR * 0.7, cloudR * 0.25), cloudR * 0.65, cloudPaint);
    canvas.drawCircle(cloudCenter + Offset(cloudR * 0.15, -cloudR * 0.15), cloudR * 0.85, cloudPaint);
    canvas.drawCircle(cloudCenter + Offset(cloudR * 0.9, cloudR * 0.2), cloudR * 0.6, cloudPaint);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: cloudCenter + Offset(0, cloudR * 0.35), width: cloudR * 2.4, height: cloudR * 0.9),
        Radius.circular(cloudR * 0.45),
      ),
      cloudPaint,
    );

    // Pink accent dot
    canvas.drawCircle(
      Offset(size.width * 0.5, size.height * 0.16),
      size.width * 0.025,
      Paint()..color = AppPalette.pink,
    );
  }

  @override
  bool shouldRepaint(covariant _LogoPainter oldDelegate) => oldDelegate.ringColor != ringColor;
}
