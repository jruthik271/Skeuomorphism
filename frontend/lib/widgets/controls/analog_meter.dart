import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../styles/skeuo_gradients.dart';

/// A realistic analog VU / power meter with curved scale dial,
/// dynamic spring needle movement, glass reflection glare, and metallic bezel.
class AnalogMeter extends StatefulWidget {
  final double value; // 0.0 to 100.0
  final String label;
  final String unit;
  final double width;
  final double height;
  final bool isCircular;
  final double min;
  final double max;

  const AnalogMeter({
    super.key,
    required this.value,
    this.label = 'POWER',
    this.unit = '%',
    this.width = 160.0,
    this.height = 120.0,
    this.isCircular = false,
    this.min = 0.0,
    this.max = 100.0,
  });

  @override
  State<AnalogMeter> createState() => _AnalogMeterState();
}

class _AnalogMeterState extends State<AnalogMeter>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _needleAnimation;
  double _lastTarget = 0.0;

  double _getNormalizedValue(double raw) {
    if (widget.max <= widget.min) return 0.0;
    return ((raw - widget.min) / (widget.max - widget.min) * 100.0).clamp(0.0, 100.0);
  }

  @override
  void initState() {
    super.initState();
    _lastTarget = _getNormalizedValue(widget.value);
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 550),
    );
    _needleAnimation = Tween<double>(
      begin: _lastTarget,
      end: _lastTarget,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    ));
  }

  @override
  void didUpdateWidget(covariant AnalogMeter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value || oldWidget.min != widget.min || oldWidget.max != widget.max) {
      final newTarget = _getNormalizedValue(widget.value);
      _needleAnimation = Tween<double>(
        begin: _needleAnimation.value,
        end: newTarget,
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack,
      ));
      _controller.forward(from: 0.0);
      _lastTarget = newTarget;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(widget.isCircular ? widget.width / 2 : 12.0),
        // Metallic outer bezel
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFD4D9DF),
            Color(0xFF8B939E),
            Color(0xFFB5BDC6),
            Color(0xFF5A606A),
          ],
          stops: [0.0, 0.35, 0.7, 1.0],
        ),
        border: Border.all(
          color: const Color(0xFF2C3035),
          width: 1.5,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0xBB000000),
            offset: Offset(2, 4),
            blurRadius: 8,
          ),
        ],
      ),
      padding: const EdgeInsets.all(5.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.isCircular ? widget.width / 2 : 8.0),
          // Recessed black inner bezel
          color: const Color(0xFF101214),
          border: Border.all(color: const Color(0xFF08090A), width: 1.5),
          boxShadow: const [
            BoxShadow(
              color: Color(0xCC000000),
              offset: Offset(0, 2),
              blurRadius: 4,
            ),
          ],
        ),
        padding: const EdgeInsets.all(3.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(widget.isCircular ? widget.width / 2 : 6.0),
          child: Stack(
            children: [
              // 1. Dial face & Needle CustomPaint
              AnimatedBuilder(
                animation: _needleAnimation,
                builder: (context, child) {
                  return CustomPaint(
                    size: Size(widget.width - 16, widget.height - 16),
                    painter: _AnalogMeterPainter(
                      currentValue: _needleAnimation.value,
                      label: widget.label,
                      unit: widget.unit,
                    ),
                  );
                },
              ),

              // 2. Curved glass lens specular reflection glare
              Positioned.fill(
                child: IgnorePointer(
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: SkeuoGradients.glassSpecularSheen,
                    ),
                  ),
                ),
              ),

              // 3. Inner shadow around glass perimeter
              Positioned.fill(
                child: IgnorePointer(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6.0),
                      border: Border.all(
                        color: const Color(0x66000000),
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AnalogMeterPainter extends CustomPainter {
  final double currentValue; // 0.0 to 100.0
  final String label;
  final String unit;

  _AnalogMeterPainter({
    required this.currentValue,
    required this.label,
    required this.unit,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Fill aged vintage cream dial face
    final bgPaint = Paint()
      ..shader = const RadialGradient(
        center: Alignment(0.0, 0.4),
        radius: 1.1,
        colors: [
          Color(0xFFFFFDF5),
          Color(0xFFF4EEDC),
          Color(0xFFE4DAC2),
        ],
        stops: [0.0, 0.6, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    final pivotCenter = Offset(size.width / 2, size.height * 1.05);
    final arcRadius = size.height * 0.88;

    // Angle mapping: 0% = -135°, 100% = -45° (90° sweep)
    const double startAngle = -math.pi * 0.75;
    const double sweepAngle = math.pi * 0.5;

    // 1. Draw calibrated scale arc
    final arcRect = Rect.fromCircle(center: pivotCenter, radius: arcRadius);
    final normalArcPaint = Paint()
      ..color = const Color(0xFF33302B)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8;

    final redArcPaint = Paint()
      ..color = const Color(0xFFCC1C1C)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4;

    // Normal zone (0 to 80%)
    canvas.drawArc(arcRect, startAngle, sweepAngle * 0.8, false, normalArcPaint);
    // Red danger zone (80 to 100%)
    canvas.drawArc(arcRect, startAngle + sweepAngle * 0.8, sweepAngle * 0.2, false, redArcPaint);

    // 2. Draw scale tick marks
    const int tickCount = 21;
    final tickPaint = Paint()
      ..color = const Color(0xFF33302B)
      ..strokeWidth = 1.2;
    final redTickPaint = Paint()
      ..color = const Color(0xFFCC1C1C)
      ..strokeWidth = 1.5;

    for (int i = 0; i < tickCount; i++) {
      final fraction = i / (tickCount - 1);
      final angle = startAngle + fraction * sweepAngle;
      final isRedZone = fraction >= 0.8;
      final isMajor = i % 5 == 0;
      final tickLength = isMajor ? 8.0 : 4.5;

      final p1 = Offset(
        pivotCenter.dx + math.cos(angle) * (arcRadius - tickLength),
        pivotCenter.dy + math.sin(angle) * (arcRadius - tickLength),
      );
      final p2 = Offset(
        pivotCenter.dx + math.cos(angle) * arcRadius,
        pivotCenter.dy + math.sin(angle) * arcRadius,
      );

      canvas.drawLine(p1, p2, isRedZone ? redTickPaint : tickPaint);

      // Draw numbers on major ticks
      if (isMajor) {
        final textVal = (fraction * 100).round().toString();
        final textPainter = TextPainter(
          text: TextSpan(
            text: textVal,
            style: TextStyle(
              fontFamily: 'serif',
              fontSize: 8.5,
              fontWeight: FontWeight.w800,
              color: isRedZone ? const Color(0xFFCC1C1C) : const Color(0xFF3A342B),
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout();

        final textOffset = Offset(
          pivotCenter.dx + math.cos(angle) * (arcRadius - tickLength - 8) - textPainter.width / 2,
          pivotCenter.dy + math.sin(angle) * (arcRadius - tickLength - 8) - textPainter.height / 2,
        );
        textPainter.paint(canvas, textOffset);
      }
    }

    // 3. Gauge Label & Unit
    final labelPainter = TextPainter(
      text: TextSpan(
        text: '$label $unit',
        style: const TextStyle(
          fontFamily: 'serif',
          fontSize: 9.5,
          fontWeight: FontWeight.w900,
          letterSpacing: 2.0,
          color: Color(0xFF423B30),
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    labelPainter.paint(
      canvas,
      Offset(size.width / 2 - labelPainter.width / 2, size.height * 0.46),
    );

    // 4. Draw the Needle
    final needleFraction = (currentValue / 100.0).clamp(0.0, 1.0);
    final needleAngle = startAngle + needleFraction * sweepAngle;

    final needleLength = arcRadius + 4;
    final needleTip = Offset(
      pivotCenter.dx + math.cos(needleAngle) * needleLength,
      pivotCenter.dy + math.sin(needleAngle) * needleLength,
    );

    // Needle drop shadow on the dial face
    final shadowPaint = Paint()
      ..color = const Color(0x3D000000)
      ..strokeWidth = 2.0
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1.5);
    canvas.drawLine(
      Offset(pivotCenter.dx + 2, pivotCenter.dy + 3),
      Offset(needleTip.dx + 2, needleTip.dy + 3),
      shadowPaint,
    );

    // The physical needle (tapered red/dark metal)
    final needlePaint = Paint()
      ..color = const Color(0xFFD62222)
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(pivotCenter, needleTip, needlePaint);

    // 5. Machined center pivot screw cap
    final capRadius = 14.0;
    final capPaint = Paint()
      ..shader = const RadialGradient(
        center: Alignment(-0.3, -0.3),
        radius: 0.85,
        colors: [
          Color(0xFFFFFFFF),
          Color(0xFFCBD2D9),
          Color(0xFF7B838D),
          Color(0xFF383C42),
        ],
        stops: [0.0, 0.35, 0.75, 1.0],
      ).createShader(Rect.fromCircle(center: pivotCenter, radius: capRadius));
    canvas.drawCircle(pivotCenter, capRadius, capPaint);

    // Center screw slot
    final slotPaint = Paint()
      ..color = const Color(0xFF1E2125)
      ..strokeWidth = 1.4;
    canvas.drawLine(
      Offset(pivotCenter.dx - 6, pivotCenter.dy - 1),
      Offset(pivotCenter.dx + 6, pivotCenter.dy - 1),
      slotPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _AnalogMeterPainter oldDelegate) {
    return oldDelegate.currentValue != currentValue ||
        oldDelegate.label != label ||
        oldDelegate.unit != unit;
  }
}
