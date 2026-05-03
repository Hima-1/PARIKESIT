import 'dart:math' as math;
import 'package:flutter/material.dart';

class KawungPainter extends CustomPainter {
  KawungPainter({
    this.color = Colors.black,
    this.opacity = 0.03,
    this.size = 60.0,
  });
  final Color color;
  final double opacity;
  final double size;

  @override
  void paint(Canvas canvas, Size canvasSize) {
    final paint = Paint()
      ..color = color.withValues(alpha: opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final double halfSize = size / 2;
    final int columns = (canvasSize.width / size).ceil() + 1;
    final int rows = (canvasSize.height / size).ceil() + 1;

    for (int i = 0; i < columns; i++) {
      for (int j = 0; j < rows; j++) {
        final double centerX = i * size;
        final double centerY = j * size;

        _drawKawungElement(canvas, Offset(centerX, centerY), halfSize, paint);
      }
    }
  }

  void _drawKawungElement(
    Canvas canvas,
    Offset center,
    double radius,
    Paint paint,
  ) {
    // Draw 4 ellipses (petals)
    for (int i = 0; i < 4; i++) {
      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.rotate(i * math.pi / 2);

      final rect = Rect.fromLTWH(
        -radius,
        -radius / 2.5,
        radius * 2,
        radius / 1.25,
      );
      canvas.drawOval(rect, paint);

      canvas.restore();
    }

    // Draw small circles in the middle of petals (optional for more detail)
    canvas.drawCircle(center, radius / 8, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class KawungBackground extends StatelessWidget {
  const KawungBackground({
    super.key,
    required this.child,
    this.color,
    this.opacity = 0.03,
  });
  final Widget child;
  final Color? color;
  final double opacity;

  @override
  Widget build(BuildContext context) => child;
}
