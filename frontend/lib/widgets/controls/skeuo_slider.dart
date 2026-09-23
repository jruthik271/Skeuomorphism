import 'package:flutter/material.dart';
import '../../styles/skeuo_colors.dart';
import '../../styles/skeuo_shadows.dart';
import '../../utils/haptics_helper.dart';

/// A realistic mechanical audio mixer fader slider with recessed track slot,
/// engraved graduation tick scale, ribbed metallic fader knob, and tactile drag.
class SkeuoSlider extends StatefulWidget {
  final double value; // min to max
  final double min;
  final double max;
  final ValueChanged<double>? onChanged;
  final String label;
  final double length;
  final bool isVertical;

  const SkeuoSlider({
    super.key,
    required this.value,
    this.min = 0.0,
    this.max = 100.0,
    this.onChanged,
    this.label = 'INTENSITY',
    this.length = 200.0,
    this.isVertical = false,
  });

  @override
  State<SkeuoSlider> createState() => _SkeuoSliderState();
}

class _SkeuoSliderState extends State<SkeuoSlider> {
  late double _currentVal;
  int _lastHapticTick = -1;

  @override
  void initState() {
    super.initState();
    _currentVal = widget.value.clamp(widget.min, widget.max);
    _lastHapticTick = (_currentVal / 10).round();
  }

  @override
  void didUpdateWidget(covariant SkeuoSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _currentVal = widget.value.clamp(widget.min, widget.max);
    }
  }

  double get _fraction => ((_currentVal - widget.min) / (widget.max - widget.min)).clamp(0.0, 1.0);

  void _updateFromPosition(Offset localPos, double trackSize) {
    final double pos = widget.isVertical ? (trackSize - localPos.dy) : localPos.dx;
    final double fraction = (pos / trackSize).clamp(0.0, 1.0);
    final double newVal = widget.min + fraction * (widget.max - widget.min);

    if (newVal != _currentVal) {
      setState(() {
        _currentVal = newVal;
      });

      final tick = (_currentVal / 10).round();
      if (tick != _lastHapticTick) {
        _lastHapticTick = tick;
        HapticsHelper.lightImpact();
      }

      widget.onChanged?.call(_currentVal);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Label & Value readout header
        if (widget.label.isNotEmpty) ...[
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  widget.label.toUpperCase(),
                  style: TextStyle(
                    fontSize: 10.0,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.0,
                    color: const Color(0xFF2E3339),
                    shadows: SkeuoShadows.engravedText(
                      darkShadow: const Color(0x99000000),
                      highlight: Colors.white.withValues(alpha: 0.6),
                    ),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF121518),
                  borderRadius: BorderRadius.circular(3),
                  border: Border.all(color: const Color(0xFF383E46), width: 0.8),
                ),
                child: Text(
                  _currentVal.round().toString().padLeft(3, '0'),
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 11.0,
                    fontWeight: FontWeight.w800,
                    color: SkeuoColors.lcdPixelOn,
                    shadows: [
                      Shadow(color: SkeuoColors.lcdPixelGlow, blurRadius: 4),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],

        // Horizontal Fader Track & Knob
        LayoutBuilder(
          builder: (context, constraints) {
            final double trackWidth = widget.length;
            const double trackHeight = 36.0;
            const double knobWidth = 24.0;
            const double knobHeight = 44.0;

            final double usableWidth = trackWidth - knobWidth;
            final double knobLeft = usableWidth * _fraction;

            return GestureDetector(
              onHorizontalDragStart: (details) => _updateFromPosition(details.localPosition, usableWidth),
              onHorizontalDragUpdate: (details) => _updateFromPosition(details.localPosition, usableWidth),
              onTapDown: (details) => _updateFromPosition(details.localPosition, usableWidth),
              behavior: HitTestBehavior.opaque,
              child: SizedBox(
                width: trackWidth,
                height: knobHeight + 10,
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.centerLeft,
                  children: [
                    // 1. Engraved tick marks along track
                    Positioned(
                      top: 0,
                      left: knobWidth / 2,
                      right: knobWidth / 2,
                      child: CustomPaint(
                        size: Size(usableWidth, 8),
                        painter: _SliderTicksPainter(),
                      ),
                    ),

                    // 2. The Recessed Rail Slot
                    Positioned(
                      top: (knobHeight + 10 - trackHeight) / 2,
                      left: 0,
                      right: 0,
                      height: trackHeight,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          gradient: const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color(0xFF8F97A2),
                              Color(0xFFB5BDC6),
                              Color(0xFFD4DAE1),
                            ],
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x66000000),
                              offset: Offset(0, 2),
                              blurRadius: 3,
                            ),
                          ],
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.7),
                            width: 1.0,
                          ),
                        ),
                        child: Center(
                          // Dark inner cavity slot
                          child: Container(
                            height: 8.0,
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              color: const Color(0xFF0D0F11),
                              borderRadius: BorderRadius.circular(4.0),
                              border: Border.all(color: const Color(0xFF070809), width: 1.0),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0xAA000000),
                                  offset: Offset(0, 1.5),
                                  blurRadius: 2.0,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    // 3. Fader Knob Handle
                    Positioned(
                      left: knobLeft,
                      top: 5,
                      child: _FaderKnob(width: knobWidth, height: knobHeight),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _FaderKnob extends StatelessWidget {
  final double width;
  final double height;

  const _FaderKnob({required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        // Machined brushed aluminum block
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFFFFFFF),
            Color(0xFFD3D8DF),
            Color(0xFFA1A8B2),
            Color(0xFF7A818B),
          ],
          stops: [0.0, 0.2, 0.65, 1.0],
        ),
        border: Border.all(color: Colors.white.withValues(alpha: 0.8), width: 1.2),
        boxShadow: const [
          // Heavy physical drop shadow under the fader cap
          BoxShadow(
            color: Color(0xBB000000),
            offset: Offset(2, 4),
            blurRadius: 6,
            spreadRadius: 1,
          ),
          BoxShadow(
            color: Color(0x66000000),
            offset: Offset(0, 1),
            blurRadius: 2,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Top ribbed finger traction grooves
          for (int i = 0; i < 3; i++) _buildGripGroove(),

          // White center indicator line
          Container(
            height: 3.0,
            margin: const EdgeInsets.symmetric(horizontal: 2.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(1.0),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x99000000),
                  offset: Offset(0, 1),
                  blurRadius: 1,
                ),
              ],
            ),
          ),

          // Bottom ribbed finger traction grooves
          for (int i = 0; i < 3; i++) _buildGripGroove(),
        ],
      ),
    );
  }

  Widget _buildGripGroove() {
    return Container(
      height: 1.5,
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      decoration: BoxDecoration(
        color: const Color(0xFF24272B),
        border: Border(
          bottom: BorderSide(
            color: Colors.white.withValues(alpha: 0.4),
            width: 0.5,
          ),
        ),
      ),
    );
  }
}

class _SliderTicksPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const int count = 11;
    final tickShadow = Paint()
      ..color = const Color(0x88000000)
      ..strokeWidth = 1.0;
    final tickHighlight = Paint()
      ..color = Colors.white.withValues(alpha: 0.5)
      ..strokeWidth = 1.0;

    for (int i = 0; i < count; i++) {
      final x = (size.width / (count - 1)) * i;
      final isMajor = i == 0 || i == count - 1 || i == 5;
      final length = isMajor ? 6.0 : 3.5;

      canvas.drawLine(Offset(x, 0), Offset(x, length), tickShadow);
      canvas.drawLine(Offset(x + 0.5, 0.5), Offset(x + 0.5, length + 0.5), tickHighlight);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
