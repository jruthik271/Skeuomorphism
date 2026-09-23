import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../styles/skeuo_shadows.dart';
import '../../utils/haptics_helper.dart';
import '../common/led_indicator.dart';

/// A realistic vintage metal toggle switch with a heavy bat handle lever,
/// hex collar nut, directional lighting, and accompanying glowing jewel LED.
class SkeuoSwitch extends StatefulWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final String? label;
  final bool showLed;
  final LedColor ledColor;

  const SkeuoSwitch({
    super.key,
    required this.value,
    this.onChanged,
    this.label,
    this.showLed = true,
    this.ledColor = LedColor.red,
  });

  @override
  State<SkeuoSwitch> createState() => _SkeuoSwitchState();
}

class _SkeuoSwitchState extends State<SkeuoSwitch>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _leverAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
      value: widget.value ? 1.0 : 0.0,
    );
    _leverAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
      reverseCurve: Curves.easeOutBack,
    );
  }

  @override
  void didUpdateWidget(covariant SkeuoSwitch oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      if (widget.value) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (widget.onChanged != null) {
      HapticsHelper.mediumImpact();
      final newValue = !widget.value;
      widget.onChanged!(newValue);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Accompanying LED indicator above switch
          if (widget.showLed) ...[
            LedIndicator(
              isOn: widget.value,
              color: widget.ledColor,
              size: 14,
            ),
            const SizedBox(height: 8),
          ],

          // Switch Mount Plate and Bat Lever Assembly
          AnimatedBuilder(
            animation: _leverAnimation,
            builder: (context, child) {
              return Container(
                width: 58,
                height: 90,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  // Stamped metal sub-chassis plate
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFFBFC6CE),
                      Color(0xFF8B939E),
                      Color(0xFF676E78),
                    ],
                  ),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.6),
                    width: 1.0,
                  ),
                  boxShadow: [
                    const BoxShadow(
                      color: Color(0x99000000),
                      offset: Offset(1.5, 3),
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // ON / OFF debossed text plates
                    Positioned(
                      top: 6,
                      child: Text(
                        'ON',
                        style: TextStyle(
                          fontSize: 8.5,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.2,
                          color: widget.value
                              ? const Color(0xFF14171A)
                              : const Color(0xFF4A525D),
                          shadows: SkeuoShadows.engravedText(
                            darkShadow: const Color(0x99000000),
                            highlight: Colors.white.withValues(alpha: 0.5),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 6,
                      child: Text(
                        'OFF',
                        style: TextStyle(
                          fontSize: 8.5,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.2,
                          color: !widget.value
                              ? const Color(0xFF14171A)
                              : const Color(0xFF4A525D),
                          shadows: SkeuoShadows.engravedText(
                            darkShadow: const Color(0x99000000),
                            highlight: Colors.white.withValues(alpha: 0.5),
                          ),
                        ),
                      ),
                    ),

                    // Recessed circular well
                    Container(
                      width: 44,
                      height: 44,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF111417),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xCC000000),
                            offset: Offset(1, 2),
                            blurRadius: 3,
                          ),
                        ],
                      ),
                    ),

                    // Knurled chrome hex retaining nut
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const RadialGradient(
                          center: Alignment(-0.3, -0.3),
                          radius: 0.8,
                          colors: [
                            Color(0xFFFFFFFF),
                            Color(0xFFCBD1D8),
                            Color(0xFF7E8691),
                            Color(0xFF454B52),
                          ],
                          stops: [0.0, 0.35, 0.75, 1.0],
                        ),
                        border: Border.all(
                          color: const Color(0xFF383E46),
                          width: 1.0,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x99000000),
                            offset: Offset(0, 2),
                            blurRadius: 3,
                          ),
                        ],
                      ),
                    ),

                    // Inner slot where lever emerges
                    Container(
                      width: 14,
                      height: 24,
                      decoration: BoxDecoration(
                        color: const Color(0xFF090A0C),
                        borderRadius: BorderRadius.circular(7),
                        border: Border.all(
                          color: const Color(0xFF2E3339),
                          width: 1.0,
                        ),
                      ),
                    ),

                    // The 3D Lever itself
                    CustomPaint(
                      size: const Size(40, 60),
                      painter: _ToggleLeverPainter(progress: _leverAnimation.value),
                    ),
                  ],
                ),
              );
            },
          ),

          if (widget.label != null) ...[
            const SizedBox(height: 6),
            Text(
              widget.label!.toUpperCase(),
              style: TextStyle(
                fontSize: 10.0,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.5,
                color: const Color(0xFF262A2E),
                shadows: SkeuoShadows.engravedText(
                  darkShadow: const Color(0x99000000),
                  highlight: Colors.white.withValues(alpha: 0.5),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ToggleLeverPainter extends CustomPainter {
  final double progress; // 0.0 (OFF, tilted down) to 1.0 (ON, tilted up)
  _ToggleLeverPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // Lever angle: tilts from +24 degrees (down/OFF) to -24 degrees (up/ON)
    final double tiltAngle = (1.0 - progress * 2.0) * (26.0 * math.pi / 180.0);
    final double leverLength = 28.0;

    canvas.save();
    canvas.translate(center.dx, center.dy);

    // Dynamic cast shadow on the switch collar behind the lever
    final shadowOffset = Offset(
      math.sin(tiltAngle) * 8.0 + 3.0,
      math.cos(tiltAngle) * 6.0 + 4.0,
    );
    final shadowPaint = Paint()
      ..color = const Color(0xAA000000)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4.0);
    canvas.drawCircle(shadowOffset, 7.5, shadowPaint);

    // Rotate canvas along tilt axis
    canvas.rotate(tiltAngle);

    // Cylindrical chrome bat lever shaft
    final shaftRect = Rect.fromCenter(
      center: Offset(0, -leverLength * 0.4),
      width: 8.0,
      height: leverLength * 0.8,
    );
    final shaftPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          Color(0xFFE2E7ED),
          Color(0xFFFFFFFF),
          Color(0xFFAAB2BC),
          Color(0xFF5E6570),
        ],
        stops: [0.0, 0.35, 0.75, 1.0],
      ).createShader(shaftRect);
    canvas.drawRRect(
      RRect.fromRectAndRadius(shaftRect, const Radius.circular(3.0)),
      shaftPaint,
    );

    // Spherical chrome tip/bat handle
    final tipCenter = Offset(0, -leverLength);
    final tipRadius = 7.5;
    final tipPaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.35, -0.4),
        radius: 0.85,
        colors: const [
          Color(0xFFFFFFFF),
          Color(0xFFD6DBE2),
          Color(0xFF8F98A3),
          Color(0xFF4C525B),
        ],
        stops: const [0.0, 0.35, 0.75, 1.0],
      ).createShader(Rect.fromCircle(center: tipCenter, radius: tipRadius));

    canvas.drawCircle(tipCenter, tipRadius, tipPaint);

    // Crisp specular highlight on the tip
    final specPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.95)
      ..style = PaintingStyle.fill;
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(tipCenter.dx - tipRadius * 0.3, tipCenter.dy - tipRadius * 0.3),
        width: tipRadius * 0.45,
        height: tipRadius * 0.3,
      ),
      specPaint,
    );

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _ToggleLeverPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
