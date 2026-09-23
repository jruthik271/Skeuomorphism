import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../styles/skeuo_colors.dart';
import '../../styles/skeuo_gradients.dart';
import '../../styles/skeuo_shadows.dart';
import '../../utils/haptics_helper.dart';

/// A realistic circular machined aluminum rotary knob with knurled grip,
/// engraved graduation tick marks, center indicator line, and gesture rotation.
class SkeuoKnob extends StatefulWidget {
  final double value; // min to max
  final double min;
  final double max;
  final ValueChanged<double>? onChanged;
  final String label;
  final double size;
  final String? unit;

  const SkeuoKnob({
    super.key,
    required this.value,
    this.min = 0.0,
    this.max = 100.0,
    this.onChanged,
    this.label = 'VOLUME',
    this.size = 110.0,
    this.unit,
  });

  @override
  State<SkeuoKnob> createState() => _SkeuoKnobState();
}

class _SkeuoKnobState extends State<SkeuoKnob> {
  late double _currentVal;
  Offset? _dragStartOffset;
  int _lastTick = -1;

  @override
  void initState() {
    super.initState();
    _currentVal = widget.value.clamp(widget.min, widget.max);
    _lastTick = _currentVal.round();
  }

  @override
  void didUpdateWidget(covariant SkeuoKnob oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _currentVal = widget.value.clamp(widget.min, widget.max);
    }
  }

  // Fraction 0.0 -> 1.0 mapped to angle -135 deg to +135 deg (-2.356 rad to +2.356 rad)
  double get _fraction => ((_currentVal - widget.min) / (widget.max - widget.min)).clamp(0.0, 1.0);
  double get _angle => -2.35619 + _fraction * 4.71239;

  void _onPanStart(DragStartDetails details) {
    _dragStartOffset = details.localPosition;
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (_dragStartOffset == null) return;

    // Support vertical/horizontal drag delta: dragging up/right increases value, down/left decreases
    final dy = -details.delta.dy;
    final dx = details.delta.dx;
    final totalDelta = (dy + dx) * 0.5;

    final range = widget.max - widget.min;
    final change = (totalDelta / 120.0) * range;

    final newVal = (_currentVal + change).clamp(widget.min, widget.max);
    if (newVal != _currentVal) {
      setState(() {
        _currentVal = newVal;
      });

      // Provide magnetic tick haptic every 5 units
      final tick = (_currentVal / 5.0).round();
      if (tick != _lastTick) {
        _lastTick = tick;
        HapticsHelper.lightImpact();
      }

      widget.onChanged?.call(_currentVal);
    }
  }

  void _onPanEnd(DragEndDetails details) {
    _dragStartOffset = null;
  }

  @override
  Widget build(BuildContext context) {
    final knobDiameter = widget.size * 0.72;
    final displayValue = _currentVal.round().toString();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Label above knob
        Text(
          widget.label.toUpperCase(),
          style: TextStyle(
            fontSize: 10.5,
            fontWeight: FontWeight.w900,
            letterSpacing: 2.0,
            color: const Color(0xFF2E3339),
            shadows: SkeuoShadows.engravedText(
              darkShadow: const Color(0x99000000),
              highlight: Colors.white.withValues(alpha: 0.6),
            ),
          ),
        ),
        const SizedBox(height: 4),

        // Interactive Knob assembly with tick marks ring
        GestureDetector(
          onPanStart: _onPanStart,
          onPanUpdate: _onPanUpdate,
          onPanEnd: _onPanEnd,
          behavior: HitTestBehavior.opaque,
          child: SizedBox(
            width: widget.size,
            height: widget.size,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // 1. Engraved tick marks ring surrounding knob
                CustomPaint(
                  size: Size(widget.size, widget.size),
                  painter: _KnobTicksPainter(fraction: _fraction),
                ),

                // 2. Knob shadow cast onto panel
                Container(
                  width: knobDiameter,
                  height: knobDiameter,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: SkeuoShadows.knob(radius: knobDiameter / 2),
                  ),
                ),

                // 3. Fluted knurled edge base
                Container(
                  width: knobDiameter,
                  height: knobDiameter,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF5A6068),
                        Color(0xFF282C31),
                        Color(0xFF1E2125),
                        Color(0xFF484E56),
                      ],
                    ),
                  ),
                  child: CustomPaint(
                    painter: _KnurledEdgePainter(),
                  ),
                ),

                // 4. Turned Aluminum Beveled Cap
                Transform.rotate(
                  angle: _angle,
                  child: Container(
                    width: knobDiameter * 0.88,
                    height: knobDiameter * 0.88,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: SkeuoGradients.rotaryKnobTop(),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.7),
                        width: 1.2,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x80000000),
                          offset: Offset(0, 1.5),
                          blurRadius: 3,
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        // Concentric micro-lathe grooves
                        Positioned.fill(
                          child: CustomPaint(
                            painter: _LatheGroovesPainter(),
                          ),
                        ),

                        // Center recessed cap
                        Center(
                          child: Container(
                            width: knobDiameter * 0.28,
                            height: knobDiameter * 0.28,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: const RadialGradient(
                                center: Alignment(-0.3, -0.3),
                                colors: [
                                  Color(0xFF8B939E),
                                  Color(0xFF4E545C),
                                  Color(0xFF2A2D32),
                                ],
                              ),
                              border: Border.all(
                                color: const Color(0xFF22252A),
                                width: 0.8,
                              ),
                            ),
                          ),
                        ),

                        // Engraved indicator notch line (points to 12 o'clock relative to rotation)
                        Positioned(
                          top: 4,
                          left: (knobDiameter * 0.88 - 3.0) / 2,
                          child: Container(
                            width: 3.0,
                            height: knobDiameter * 0.26,
                            decoration: BoxDecoration(
                              color: const Color(0xFF1A1C1F),
                              borderRadius: BorderRadius.circular(1.5),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0xCC000000),
                                  offset: Offset(-0.5, -0.5),
                                  blurRadius: 0.5,
                                ),
                                BoxShadow(
                                  color: Colors.white,
                                  offset: Offset(0.5, 0.5),
                                  blurRadius: 0.5,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 4),

        // Readout display window
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
          decoration: BoxDecoration(
            color: const Color(0xFF121518),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: const Color(0xFF383E46),
              width: 0.8,
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x66000000),
                offset: Offset(0, 1),
                blurRadius: 2,
              ),
            ],
          ),
          child: Text(
            widget.unit != null ? '$displayValue ${widget.unit}' : displayValue,
            style: const TextStyle(
              fontFamily: 'monospace',
              fontSize: 12.0,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.5,
              color: SkeuoColors.lcdPixelOn,
              shadows: [
                Shadow(
                  color: SkeuoColors.lcdPixelGlow,
                  blurRadius: 6.0,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _KnobTicksPainter extends CustomPainter {
  final double fraction;
  _KnobTicksPainter({required this.fraction});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final outerRadius = size.width / 2 - 2;

    const int totalTicks = 21;
    const double startAngle = -math.pi * 0.75 - math.pi / 2; // -135° from 12 o'clock
    const double sweepAngle = math.pi * 1.5; // 270°

    final tickShadowPaint = Paint()
      ..color = const Color(0x99000000)
      ..strokeWidth = 1.0;

    final tickHighlightPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.55)
      ..strokeWidth = 1.0;

    for (int i = 0; i < totalTicks; i++) {
      final t = i / (totalTicks - 1);
      final angle = startAngle + t * sweepAngle;
      final isMajor = i % 5 == 0;
      final tickLength = isMajor ? 7.0 : 4.0;

      final p1 = Offset(
        center.dx + math.cos(angle) * (outerRadius - tickLength),
        center.dy + math.sin(angle) * (outerRadius - tickLength),
      );
      final p2 = Offset(
        center.dx + math.cos(angle) * outerRadius,
        center.dy + math.sin(angle) * outerRadius,
      );

      // Shadow tick
      canvas.drawLine(p1, p2, tickShadowPaint);
      // Highlight shift for engraved look
      canvas.drawLine(
        Offset(p1.dx + 0.5, p1.dy + 0.5),
        Offset(p2.dx + 0.5, p2.dy + 0.5),
        tickHighlightPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _KnobTicksPainter oldDelegate) {
    return oldDelegate.fraction != fraction;
  }
}

class _KnurledEdgePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    const int teeth = 36;
    final toothPaint = Paint()
      ..color = const Color(0xFF1B1E22)
      ..strokeWidth = 1.5;

    final toothHighlight = Paint()
      ..color = Colors.white.withValues(alpha: 0.35)
      ..strokeWidth = 1.0;

    for (int i = 0; i < teeth; i++) {
      final angle = (i / teeth) * 2 * math.pi;
      final p1 = Offset(
        center.dx + math.cos(angle) * (radius - 4),
        center.dy + math.sin(angle) * (radius - 4),
      );
      final p2 = Offset(
        center.dx + math.cos(angle) * radius,
        center.dy + math.sin(angle) * radius,
      );
      canvas.drawLine(p1, p2, toothPaint);
      canvas.drawLine(
        Offset(p1.dx + 0.5, p1.dy + 0.5),
        Offset(p2.dx + 0.5, p2.dy + 0.5),
        toothHighlight,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _LatheGroovesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final ringPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.6
      ..color = const Color(0x18000000);

    for (double r = radius * 0.35; r < radius * 0.9; r += 3.5) {
      canvas.drawCircle(center, r, ringPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
