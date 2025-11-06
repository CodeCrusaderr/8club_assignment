import 'package:flutter/material.dart';

class NextButtonAnimated extends StatefulWidget {
  const NextButtonAnimated({
    super.key,
    this.onPressed,
    this.expanded = false,
    this.label = 'Next',
    this.animate = false,
  });

  final VoidCallback? onPressed;
  final bool expanded;
  final String label;
  final bool animate;

  @override
  State<NextButtonAnimated> createState() => _NextButtonAnimatedState();
}

class _NextButtonAnimatedState extends State<NextButtonAnimated>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    if (widget.animate) {
      _animationController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(NextButtonAnimated oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animate && !oldWidget.animate) {
      _animationController.repeat(reverse: true);
    } else if (!widget.animate && oldWidget.animate) {
      _animationController.stop();
      _animationController.reset();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final button = Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF1A1A1A), 
            Color(0xFFE0E0E0), 
            Color(0xFF1A1A1A), 
          ],
          stops: [0.0, 0.5, 1.0],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: widget.onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              mainAxisSize: widget.expanded ? MainAxisSize.max : MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.label,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 8),
                CustomPaint(
                  size: const Size(20, 20),
                  painter: _StylishArrowPainter(),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    if (widget.expanded) {
      return AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: widget.animate ? _scaleAnimation.value : 1.0,
            child: SizedBox(
              width: double.infinity,
              child: button,
            ),
          );
        },
      );
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      width: 160,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: widget.animate ? _scaleAnimation.value : 1.0,
            child: button,
          );
        },
      ),
    );
  }
}

class _StylishArrowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black87
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();
    // Draw a stylish curved arrow
    path.moveTo(size.width * 0.2, size.height * 0.5);
    path.lineTo(size.width * 0.7, size.height * 0.5);
    path.moveTo(size.width * 0.6, size.height * 0.3);
    path.lineTo(size.width * 0.7, size.height * 0.5);
    path.lineTo(size.width * 0.6, size.height * 0.7);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}


