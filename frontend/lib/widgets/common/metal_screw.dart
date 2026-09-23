import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../styles/skeuo_colors.dart';

enum ScrewMaterial { chrome, brass, blackIron }
enum ScrewHeadType { slotted, phillips }

/// A realistic machined metal screw with recessed shadow well,
/// beveled circular head, and directional slot reflection.
class MetalScrew extends StatelessWidget {
  final double size;
  final ScrewMaterial material;
  final ScrewHeadType headType;
  final double angle; // in radians

  const MetalScrew({
    super.key,
    this.size = 14.0,
    this.material = ScrewMaterial.chrome,
    this.headType = ScrewHeadType.slotted,
    this.angle = 0.5,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        // Recessed countersunk hole shadow
        boxShadow: [
          BoxShadow(
            color: Color(0xAA000000),
            offset: Offset(0.5, 1.0),
            blurRadius: 1.5,
            spreadRadius: 0.2,
          ),
        ],
      ),
      child: CustomPaint(
        size: Size(size, size),
        painter: _ScrewPainter(
          material: material,
          headType: headType,
          angle: angle,
        ),
      ),
    );
  }
}

class _ScrewPainter extends CustomPainter {
  final ScrewMaterial material;
  final ScrewHeadType headType;
  final double angle;

  _ScrewPainter({
    required this.material,
    required this.headType,
    required this.angle,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // 1. Recessed dark socket rim
    final socketPaint = Paint()
      ..color = const Color(0xFF101214)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, socketPaint);

    // 2. Screw head metallic bevel & radial gradient
    final headRadius = radius * 0.88;
    final List<Color> gradientColors;
    switch (material) {
      case ScrewMaterial.chrome:
        gradientColors = [
          const Color(0xFFFFFFFF),
          const Color(0xFFD6DBE0),
          const Color(0xFFA0A7B0),
          const Color(0xFF6E747C),
        ];
        break;
      case ScrewMaterial.brass:
        gradientColors = [
          SkeuoColors.brassHighlight,
          SkeuoColors.brassLight,
          SkeuoColors.brassMid,
          SkeuoColors.brassDark,
        ];
        break;
      case ScrewMaterial.blackIron:
        gradientColors = [
          const Color(0xFF4A4E54),
          const Color(0xFF2C3035),
          const Color(0xFF1B1E22),
          const Color(0xFF0F1113),
        ];
        break;
    }

    final headPaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.3, -0.3),
        radius: 0.9,
        colors: gradientColors,
        stops: const [0.0, 0.35, 0.75, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: headRadius));

    canvas.drawCircle(center, headRadius, headPaint);

    // 3. Crisp outer highlight ring on top-left, shadow on bottom-right
    final rimPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.75
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withValues(alpha: 0.8),
          Colors.transparent,
          const Color(0x99000000),
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: headRadius));
    canvas.drawCircle(center, headRadius, rimPaint);

    // 4. Cut the slot (dark recessed channel with bottom highlight)
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(angle);

    final slotWidth = headRadius * 1.5;
    final slotHeight = headRadius * 0.26;

    final slotPaint = Paint()
      ..color = const Color(0xFF14171A)
      ..style = PaintingStyle.fill;

    // Slot cavity
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset.zero, width: slotWidth, height: slotHeight),
        const Radius.circular(1.0),
      ),
      slotPaint,
    );

    // Slot bottom highlight edge
    final slotHighlight = Paint()
      ..color = Colors.white.withValues(alpha: 0.4)
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;
    canvas.drawLine(
      Offset(-slotWidth * 0.45, slotHeight * 0.5),
      Offset(slotWidth * 0.45, slotHeight * 0.5),
      slotHighlight,
    );

    // If Phillips, draw perpendicular slot
    if (headType == ScrewHeadType.phillips) {
      canvas.rotate(math.pi / 2);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(center: Offset.zero, width: slotWidth, height: slotHeight),
          const Radius.circular(1.0),
        ),
        slotPaint,
      );
      canvas.drawLine(
        Offset(-slotWidth * 0.45, slotHeight * 0.5),
        Offset(slotWidth * 0.45, slotHeight * 0.5),
        slotHighlight,
      );
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _ScrewPainter oldDelegate) {
    return oldDelegate.material != material ||
        oldDelegate.headType != headType ||
        oldDelegate.angle != angle;
  }
}
