import 'package:flutter/material.dart';

/// SpeakerGrille provides an acoustic perforation mesh with countersunk
/// drilled holes and dark cloth backing, commonly found on retro radios and amplifiers.
class SpeakerGrille extends StatelessWidget {
  final double width;
  final double height;
  final double holeRadius;
  final double holeSpacing;
  final Color metalColor;
  final Color backingColor;

  const SpeakerGrille({
    super.key,
    required this.width,
    required this.height,
    this.holeRadius = 2.0,
    this.holeSpacing = 8.0,
    this.metalColor = const Color(0xFF8B939E),
    this.backingColor = const Color(0xFF101214),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: backingColor,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFF101316), width: 1.2),
        boxShadow: const [
          BoxShadow(
            color: Color(0x99000000),
            offset: Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: CustomPaint(
          size: Size(width, height),
          painter: _PerforatedMeshPainter(
            holeRadius: holeRadius,
            holeSpacing: holeSpacing,
            metalColor: metalColor,
            backingColor: backingColor,
          ),
        ),
      ),
    );
  }
}

class _PerforatedMeshPainter extends CustomPainter {
  final double holeRadius;
  final double holeSpacing;
  final Color metalColor;
  final Color backingColor;

  _PerforatedMeshPainter({
    required this.holeRadius,
    required this.holeSpacing,
    required this.metalColor,
    required this.backingColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Draw metal sheet surface
    final sheetPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          metalColor.withValues(alpha: 0.95),
          metalColor.withValues(alpha: 0.8),
          metalColor.withValues(alpha: 0.9),
          metalColor.withValues(alpha: 0.75),
        ],
        stops: const [0.0, 0.35, 0.7, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), sheetPaint);

    final holePaint = Paint()
      ..color = backingColor
      ..style = PaintingStyle.fill;

    final rimShadowPaint = Paint()
      ..color = const Color(0x99000000)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;

    final rimHighlightPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;

    int row = 0;
    for (double y = holeSpacing; y < size.height - holeSpacing / 2; y += holeSpacing) {
      final double xOffset = (row % 2 == 1) ? holeSpacing / 2 : 0.0;
      for (double x = holeSpacing + xOffset; x < size.width - holeSpacing / 2; x += holeSpacing) {
        final center = Offset(x, y);

        // Dark hole interior
        canvas.drawCircle(center, holeRadius, holePaint);

        // Top-left dark inset rim
        canvas.drawArc(
          Rect.fromCircle(center: center, radius: holeRadius),
          3.14 * 0.75,
          3.14,
          false,
          rimShadowPaint,
        );

        // Bottom-right highlight rim
        canvas.drawArc(
          Rect.fromCircle(center: center, radius: holeRadius),
          -3.14 * 0.25,
          3.14,
          false,
          rimHighlightPaint,
        );
      }
      row++;
    }
  }

  @override
  bool shouldRepaint(covariant _PerforatedMeshPainter oldDelegate) => false;
}
