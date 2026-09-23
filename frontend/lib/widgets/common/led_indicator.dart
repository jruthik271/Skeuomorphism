import 'package:flutter/material.dart';
import '../../styles/skeuo_colors.dart';
import '../../styles/skeuo_shadows.dart';

enum LedColor { red, green, amber, blue }

/// A realistic vintage jewel LED indicator with chrome bezel,
/// faceted refractive dome lens, and radiating optical bloom when activated.
class LedIndicator extends StatelessWidget {
  final bool isOn;
  final LedColor color;
  final double size;
  final String? label;
  final bool labelBelow;

  const LedIndicator({
    super.key,
    required this.isOn,
    this.color = LedColor.red,
    this.size = 18.0,
    this.label,
    this.labelBelow = true,
  });

  @override
  Widget build(BuildContext context) {
    Color activeColor;
    Color inactiveColor;
    Color glowColor;

    switch (color) {
      case LedColor.red:
        activeColor = SkeuoColors.ledRedOn;
        inactiveColor = SkeuoColors.ledRedOff;
        glowColor = SkeuoColors.ledRedGlow;
        break;
      case LedColor.green:
        activeColor = SkeuoColors.ledGreenOn;
        inactiveColor = SkeuoColors.ledGreenOff;
        glowColor = SkeuoColors.ledGreenGlow;
        break;
      case LedColor.amber:
        activeColor = SkeuoColors.ledAmberOn;
        inactiveColor = SkeuoColors.ledAmberOff;
        glowColor = SkeuoColors.ledAmberGlow;
        break;
      case LedColor.blue:
        activeColor = SkeuoColors.ledBlueOn;
        inactiveColor = SkeuoColors.ledBlueOff;
        glowColor = SkeuoColors.ledBlueGlow;
        break;
    }

    final double bezelSize = size + 8.0;

    Widget indicator = AnimatedContainer(
      duration: const Duration(milliseconds: 120),
      width: bezelSize,
      height: bezelSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        // Chrome bezel ring
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFE2E6EA),
            Color(0xFF8E959E),
            Color(0xFFD0D6DC),
            Color(0xFF555B63),
          ],
          stops: [0.0, 0.4, 0.7, 1.0],
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x99000000),
            offset: Offset(1, 2),
            blurRadius: 3,
          ),
        ],
        border: Border.all(
          color: const Color(0xFF2B2F34),
          width: 0.8,
        ),
      ),
      child: Center(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 140),
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              center: const Alignment(-0.3, -0.3),
              radius: 0.85,
              colors: isOn
                  ? [
                      Colors.white,
                      activeColor,
                      activeColor.withValues(alpha: 0.85),
                      activeColor.withValues(alpha: 0.6),
                    ]
                  : [
                      inactiveColor.withValues(alpha: 0.7),
                      inactiveColor.withValues(alpha: 0.4),
                      inactiveColor.withValues(alpha: 0.2),
                      const Color(0xFF150404),
                    ],
              stops: const [0.0, 0.35, 0.8, 1.0],
            ),
            boxShadow: SkeuoShadows.ledGlow(glowColor, isOn: isOn),
          ),
          child: CustomPaint(
            size: Size(size, size),
            painter: _LedLensRefractionPainter(isOn: isOn),
          ),
        ),
      ),
    );

    if (label == null) return indicator;

    final labelWidget = Text(
      label!.toUpperCase(),
      style: TextStyle(
        fontSize: 9.0,
        fontWeight: FontWeight.w800,
        letterSpacing: 1.5,
        color: const Color(0xFF2C3035),
        shadows: SkeuoShadows.engravedText(
          darkShadow: const Color(0x99000000),
          highlight: Colors.white.withValues(alpha: 0.5),
        ),
      ),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: labelBelow
          ? [indicator, const SizedBox(height: 4), labelWidget]
          : [labelWidget, const SizedBox(height: 4), indicator],
    );
  }
}

class _LedLensRefractionPainter extends CustomPainter {
  final bool isOn;
  _LedLensRefractionPainter({required this.isOn});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Specular highlight dot (reflection of external light bulb)
    final highlightPaint = Paint()
      ..color = Colors.white.withValues(alpha: isOn ? 0.9 : 0.45)
      ..style = PaintingStyle.fill;

    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx - radius * 0.32, center.dy - radius * 0.32),
        width: radius * 0.42,
        height: radius * 0.28,
      ),
      highlightPaint,
    );

    // Inner dark refraction rim
    final rimPaint = Paint()
      ..color = const Color(0x33000000)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;
    canvas.drawCircle(center, radius - 0.5, rimPaint);
  }

  @override
  bool shouldRepaint(covariant _LedLensRefractionPainter oldDelegate) {
    return oldDelegate.isOn != isOn;
  }
}
