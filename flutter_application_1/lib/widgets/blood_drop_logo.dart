import 'package:flutter/material.dart';

class BloodDropLogo extends StatelessWidget {
  const BloodDropLogo({super.key, this.size = 72});

  final double size;

  @override
  Widget build(BuildContext context) {
    final dropWidth = size * 0.72;
    final dropHeight = size;

    return SizedBox(
      width: dropWidth + 10,
      height: dropHeight + 4,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          CustomPaint(
            size: Size(dropWidth, dropHeight),
            painter: _BloodDropPainter(),
          ),
          Positioned(
            right: 0,
            bottom: size * 0.08,
            child: Container(
              width: size * 0.36,
              height: size * 0.36,
              decoration: const BoxDecoration(
                color: Color(0xFF5EB4E8),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.add,
                color: Colors.white,
                size: size * 0.22,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BloodDropPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(size.width * 0.5, size.height * 0.02)
      ..cubicTo(
        size.width * 1.05,
        size.height * 0.38,
        size.width * 0.88,
        size.height * 0.95,
        size.width * 0.5,
        size.height * 0.98,
      )
      ..cubicTo(
        size.width * 0.12,
        size.height * 0.95,
        size.width * -0.05,
        size.height * 0.38,
        size.width * 0.5,
        size.height * 0.02,
      )
      ..close();

    final bounds = path.getBounds();
    final gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: const [
        Color(0xFFFF6B7A),
        Color(0xFFE84558),
        Color(0xFFD42E45),
      ],
      stops: const [0.0, 0.55, 1.0],
    );

    canvas.drawPath(
      path,
      Paint()
        ..shader = gradient.createShader(bounds)
        ..style = PaintingStyle.fill,
    );

    canvas.drawPath(
      path,
      Paint()
        ..color = const Color(0xFFCC2A3F).withValues(alpha: 0.25)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
