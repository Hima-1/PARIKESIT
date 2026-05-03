import 'package:flutter/material.dart';

class EthnoDivider extends StatelessWidget {
  const EthnoDivider({
    super.key,
    this.height = 16,
    this.color,
    this.thickness = 1,
    this.indent = 0,
    this.endIndent = 0,
  });
  final double height;
  final Color? color;
  final double thickness;
  final double indent;
  final double endIndent;

  @override
  Widget build(BuildContext context) {
    final dividerColor = color ?? Theme.of(context).dividerColor;

    return Container(
      height: height,
      margin: EdgeInsetsDirectional.only(start: indent, end: endIndent),
      child: Center(
        child: CustomPaint(
          size: const Size(double.infinity, 2),
          painter: _IsenIsenPainter(color: dividerColor, thickness: thickness),
        ),
      ),
    );
  }
}

class _IsenIsenPainter extends CustomPainter {
  _IsenIsenPainter({required this.color, required this.thickness});
  final Color color;
  final double thickness;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = thickness
      ..strokeCap = StrokeCap.round;

    const double dashWidth = 2;
    const double dashSpace = 4;
    double startX = 0;

    while (startX < size.width) {
      canvas.drawCircle(Offset(startX, size.height / 2), thickness, paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
