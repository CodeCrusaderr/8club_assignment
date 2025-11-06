import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../theme/app_theme.dart';

class CurvedProgressBar extends StatelessWidget {
  const CurvedProgressBar({super.key, required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 24,
      child: CustomPaint(painter: _CurvedProgressPainter(progress: progress)),
    );
  }
}

class _CurvedProgressPainter extends CustomPainter {
  _CurvedProgressPainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;

    const int waveCount = 18; 
    final double amplitude = height * 0.2; 

    final Path wavePath = Path()..moveTo(0, height / 2);
    for (double x = 0; x <= width; x++) {
      double y =
          height / 2 +
          math.sin((x / width) * waveCount * math.pi * 2) * amplitude;
      wavePath.lineTo(x, y);
    }

    final bgPaint =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3
          ..color = Colors.white12
          ..strokeCap = StrokeCap.round;

    canvas.drawPath(wavePath, bgPaint);

    final pathMetrics = wavePath.computeMetrics();
    final firstMetric = pathMetrics.first;
    final progressLength = firstMetric.length * progress.clamp(0.0, 1.0);
    final extractedPath = firstMetric.extractPath(0, progressLength);

    final gradient = LinearGradient(
      colors: [AppColors.secondaryAccent, AppColors.primaryAccent],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    );
    final shader = gradient.createShader(Offset.zero & size);

    final fgPaint =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 4
          ..shader = shader
          ..strokeCap = StrokeCap.round;

    canvas.drawPath(extractedPath, fgPaint);
  }

  @override
  bool shouldRepaint(covariant _CurvedProgressPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
