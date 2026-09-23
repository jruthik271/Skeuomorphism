import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../styles/skeuo_colors.dart';
import '../../styles/skeuo_shadows.dart';
import '../../utils/haptics_helper.dart';
import '../common/metal_screw.dart';

/// A miniature vintage rangefinder camera with multi-element glass lens,
/// mechanical spring shutter, electronic flash strobe, and photo exposure counter.
class SkeuoCamera extends StatefulWidget {
  const SkeuoCamera({super.key});

  @override
  State<SkeuoCamera> createState() => _SkeuoCameraState();
}

class _SkeuoCameraState extends State<SkeuoCamera> {
  int _exposureCount = 14;
  bool _isFlashing = false;
  bool _photoCaptured = false;
  bool _isShutterPressed = false;
  Timer? _capturedTimer;

  void _triggerShutter() {
    HapticsHelper.heavyImpact();
    setState(() {
      _isShutterPressed = true;
      _isFlashing = true;
      _exposureCount++;
      _photoCaptured = true;
    });

    // End shutter stroke & flash strobe quickly
    Future.delayed(const Duration(milliseconds: 90), () {
      if (mounted) {
        setState(() {
          _isShutterPressed = false;
        });
      }
    });

    Future.delayed(const Duration(milliseconds: 140), () {
      if (mounted) {
        setState(() {
          _isFlashing = false;
        });
      }
    });

    _capturedTimer?.cancel();
    _capturedTimer = Timer(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _photoCaptured = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _capturedTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        // Two-tone Rangefinder Chassis: Brushed Aluminum Top & Leatherette Base
        boxShadow: const [
          BoxShadow(
            color: Color(0xDD000000),
            offset: Offset(2, 6),
            blurRadius: 16,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Column(
          children: [
            // Top Brushed Aluminum Deck
            Container(
              height: 52,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFFFFFFF),
                    Color(0xFFDCE2E9),
                    Color(0xFFA5ACB6),
                    Color(0xFF7A828E),
                  ],
                  stops: [0.0, 0.2, 0.7, 1.0],
                ),
                border: Border(
                  top: const BorderSide(color: Colors.white, width: 1.5),
                  bottom: const BorderSide(color: Color(0xFF2C3035), width: 2.0),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Left Screw & Brand Name
                  Row(
                    children: [
                      const MetalScrew(size: 10, material: ScrewMaterial.chrome, angle: 0.9),
                      const SizedBox(width: 8),
                      Text(
                        'SKEUO-F1',
                        style: TextStyle(
                          fontFamily: 'sans-serif',
                          fontSize: 11.0,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2.0,
                          color: const Color(0xFF24272B),
                          shadows: SkeuoShadows.engravedText(
                            darkShadow: const Color(0x99000000),
                            highlight: Colors.white.withValues(alpha: 0.8),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Viewfinder Window & Flash Unit
                  Row(
                    children: [
                      // Viewfinder window
                      Container(
                        width: 28,
                        height: 18,
                        decoration: BoxDecoration(
                          color: const Color(0xFF101C24),
                          borderRadius: BorderRadius.circular(2),
                          border: Border.all(color: const Color(0xFF4A525C), width: 1.0),
                          boxShadow: const [
                            BoxShadow(color: Color(0x66000000), offset: Offset(0, 1), blurRadius: 2),
                          ],
                        ),
                        child: Center(
                          child: Container(
                            width: 12,
                            height: 8,
                            color: const Color(0x4464B5F6),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),

                      // Faceted Flash Strobe Window
                      Container(
                        width: 36,
                        height: 22,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3),
                          color: _isFlashing ? Colors.white : const Color(0xFFE2E7ED),
                          border: Border.all(color: const Color(0xFF3E444C), width: 1.0),
                          boxShadow: _isFlashing
                              ? [
                                  const BoxShadow(
                                    color: Colors.white,
                                    blurRadius: 20,
                                    spreadRadius: 8,
                                  ),
                                ]
                              : const [
                                  BoxShadow(
                                    color: Color(0x66000000),
                                    offset: Offset(0, 1),
                                    blurRadius: 2,
                                  ),
                                ],
                        ),
                        child: CustomPaint(
                          painter: _FlashFresnelPainter(isFlashing: _isFlashing),
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Mechanical Shutter Release Button
                      GestureDetector(
                        onTap: _triggerShutter,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 60),
                              width: 32,
                              height: _isShutterPressed ? 16 : 22,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3),
                                gradient: const LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Color(0xFFFFFFFF),
                                    Color(0xFFC7CDD4),
                                    Color(0xFF7B838E),
                                  ],
                                ),
                                border: Border.all(color: const Color(0xFF454B54), width: 0.8),
                                boxShadow: _isShutterPressed
                                    ? null
                                    : const [
                                        BoxShadow(
                                          color: Color(0xAA000000),
                                          offset: Offset(0, 2),
                                          blurRadius: 3,
                                        ),
                                      ],
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.camera_alt_rounded,
                                  size: 13,
                                  color: Color(0xFF2C3036),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Camera Body (Black Textured Leatherette Wrap & Large Multi-Element Lens)
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF1E2124),
                    Color(0xFF121416),
                    Color(0xFF0D0E10),
                  ],
                ),
              ),
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Textured leatherette background pattern
                  Positioned.fill(
                    child: CustomPaint(
                      painter: _LeatheretteGrainPainter(),
                    ),
                  ),

                  // Left Side Exposure Display & Captured Banner
                  Positioned(
                    left: 4,
                    top: 10,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Small LCD exposure counter
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFF090E0A),
                            borderRadius: BorderRadius.circular(3),
                            border: Border.all(color: const Color(0xFF2C342E), width: 0.8),
                          ),
                          child: Text(
                            'EXP: $_exposureCount',
                            style: const TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 10.0,
                              fontWeight: FontWeight.w900,
                              color: SkeuoColors.lcdPixelOn,
                              shadows: [
                                Shadow(color: SkeuoColors.lcdPixelGlow, blurRadius: 4),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Photo Captured Badge
                        AnimatedOpacity(
                          duration: const Duration(milliseconds: 200),
                          opacity: _photoCaptured ? 1.0 : 0.0,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                            decoration: BoxDecoration(
                              color: const Color(0xFF2E7D32),
                              borderRadius: BorderRadius.circular(3),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x992E7D32),
                                  blurRadius: 8,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: const Text(
                              'PHOTO CAPTURED',
                              style: TextStyle(
                                fontSize: 8.0,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // The Multi-Element Optical Lens Assembly
                  GestureDetector(
                    onTap: _triggerShutter,
                    child: _buildOpticalLens(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOpticalLens() {
    const lensDiameter = 136.0;

    return Container(
      width: lensDiameter,
      height: lensDiameter,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        // Drop shadow cast by protruding lens barrel onto camera body
        boxShadow: [
          BoxShadow(
            color: Color(0xFF000000),
            offset: Offset(3, 8),
            blurRadius: 18,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Layer 1: OUTER KNURLED METAL RING
          Container(
            width: lensDiameter,
            height: lensDiameter,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFE2E6EB),
                  Color(0xFF9AA1AA),
                  Color(0xFF555B63),
                  Color(0xFF33373D),
                ],
                stops: [0.0, 0.35, 0.7, 1.0],
              ),
              border: Border.all(color: Colors.white.withValues(alpha: 0.7), width: 1.2),
            ),
            child: CustomPaint(painter: _LensGripRibsPainter()),
          ),

          // Layer 2: INNER STEPPED METAL BARREL
          Container(
            width: lensDiameter * 0.84,
            height: lensDiameter * 0.84,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const RadialGradient(
                center: Alignment(-0.25, -0.25),
                colors: [
                  Color(0xFF282C31),
                  Color(0xFF141618),
                  Color(0xFF0A0C0E),
                ],
                stops: [0.0, 0.6, 1.0],
              ),
              border: Border.all(color: const Color(0xFF424750), width: 1.5),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Lens focal length markings in white/gold
                Positioned(
                  top: 5,
                  child: Text(
                    'F = 50mm  1:1.4',
                    style: TextStyle(
                      fontSize: 7.0,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.2,
                      color: const Color(0xFFE2B768),
                      shadows: [
                        Shadow(color: Colors.black.withValues(alpha: 0.8), offset: const Offset(0, 1)),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 5,
                  child: Text(
                    'OPTICAL SKEUO GLASS',
                    style: TextStyle(
                      fontSize: 6.0,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.0,
                      color: Colors.white.withValues(alpha: 0.6),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Layer 3: DEEP APERTURE BARREL
          Container(
            width: lensDiameter * 0.62,
            height: lensDiameter * 0.62,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF040608),
            ),
          ),

          // Layer 4: GLASS LENS WITH MULTI-COATED IRIDESCENT REFLECTION
          Container(
            width: lensDiameter * 0.58,
            height: lensDiameter * 0.58,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const RadialGradient(
                center: Alignment(0.1, 0.2),
                radius: 0.9,
                colors: [
                  Color(0xFF120B2E), // deep indigo
                  Color(0xFF0A1826), // deep cyan
                  Color(0xFF030508), // dark core
                ],
                stops: [0.0, 0.5, 1.0],
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x665C6BC0),
                  blurRadius: 8,
                ),
              ],
            ),
            child: Stack(
              children: [
                // Layer 5: CURVED SPECULAR CRESCENT GLARE
                Positioned.fill(
                  child: CustomPaint(
                    painter: _LensGlarePainter(),
                  ),
                ),

                // Center pupil glare point
                Center(
                  child: Container(
                    width: 7,
                    height: 7,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.9),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0xFF00E5FF),
                          blurRadius: 4,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FlashFresnelPainter extends CustomPainter {
  final bool isFlashing;
  _FlashFresnelPainter({required this.isFlashing});

  @override
  void paint(Canvas canvas, Size size) {
    if (isFlashing) return;
    final linePaint = Paint()
      ..color = const Color(0x44000000)
      ..strokeWidth = 0.8;

    for (double x = 4; x < size.width; x += 4) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), linePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _FlashFresnelPainter oldDelegate) => oldDelegate.isFlashing != isFlashing;
}

class _LeatheretteGrainPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final dotPaint = Paint()
      ..color = const Color(0x18FFFFFF)
      ..strokeWidth = 1.0;

    for (double y = 4; y < size.height; y += 6) {
      for (double x = 4; x < size.width; x += 6) {
        canvas.drawCircle(Offset(x, y), 0.75, dotPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _LensGripRibsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    const ribs = 48;
    final ribPaint = Paint()
      ..color = const Color(0xFF1E2125)
      ..strokeWidth = 1.2;

    for (int i = 0; i < ribs; i++) {
      final angle = (i / ribs) * 2 * 3.14159;
      final p1 = Offset(center.dx + math.cos(angle) * (radius - 5), center.dy + math.sin(angle) * (radius - 5));
      final p2 = Offset(center.dx + math.cos(angle) * radius, center.dy + math.sin(angle) * radius);
      canvas.drawLine(p1, p2, ribPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _LensGlarePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Cyan/violet crescent reflection
    final glarePaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.4, -0.4),
        radius: 0.7,
        colors: [
          Colors.white.withValues(alpha: 0.5),
          const Color(0x4480DEEA),
          Colors.transparent,
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx - radius * 0.28, center.dy - radius * 0.28),
        width: radius * 0.7,
        height: radius * 0.45,
      ),
      glarePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
