import 'package:flutter/material.dart';

class SlantedCurvesBackground extends StatelessWidget {
  const SlantedCurvesBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _SlantedCurvesPainter(), child: child);
  }
}

class _SlantedCurvesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final paint =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.2
          ..color = Colors.white.withOpacity(0.06);

    canvas.save();
    canvas.translate(-w * 0.2, h * 0.05);
    canvas.rotate(-0.5);

    for (int i = 0; i < 30; i++) {
      final dy = h * (-0.6 + i * 0.15);
      final path = Path();

      path.moveTo(-100, dy);
      path.cubicTo(w * 0.2, dy + 60, w * 0.4, dy - 40, w * 0.6, dy + 80);
      path.cubicTo(w * 0.8, dy + 160, w * 1.0, dy - 60, w * 1.3, dy + 100);

      canvas.drawPath(path, paint);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
