import 'dart:math';
import 'package:flutter/material.dart';
import 'package:witnessed_art/theme/emerald_wash_theme.dart';

class WatercolorBackground extends StatelessWidget {
  const WatercolorBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _WatercolorPainter(),
      child: Container(),
    );
  }
}

class _WatercolorPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final random = Random(42); // Fixed seed for deterministic abstract art
    final paint = Paint()..maskFilter = const MaskFilter.blur(BlurStyle.normal, 80);

    for (var i = 0; i < 5; i++) {
      paint.color = EmeraldWashTheme.emeraldCore.withOpacity(0.08);
      canvas.drawCircle(
        Offset(
          random.nextDouble() * size.width,
          random.nextDouble() * size.height,
        ),
        150 + random.nextDouble() * 200,
        paint,
      );
    }
    
    paint.color = const Color(0xFFFFF5E6).withOpacity(0.4);
    canvas.drawCircle(Offset(size.width * 0.8, size.height * 0.2), 300, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
