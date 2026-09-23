import 'package:flutter/material.dart';
import '../../styles/skeuo_colors.dart';
import '../common/metal_screw.dart';

enum LcdTheme { greenPhosphor, amberVfd }

/// A realistic industrial LCD / VFD cathode display with cathode scanlines,
/// phosphorescent glow, recessed screen cavity, and metallic mounting bezel.
class LcdDisplay extends StatelessWidget {
  final Map<String, String> statusItems;
  final String title;
  final LcdTheme theme;
  final double width;
  final bool showScrews;

  const LcdDisplay({
    super.key,
    required this.statusItems,
    this.title = 'SYSTEM STATUS',
    this.theme = LcdTheme.greenPhosphor,
    this.width = double.infinity,
    this.showScrews = true,
  });

  @override
  Widget build(BuildContext context) {
    final isGreen = theme == LcdTheme.greenPhosphor;
    final Color screenBg = isGreen ? SkeuoColors.lcdScreenBg : SkeuoColors.amberLcdBg;
    final Color pixelOn = isGreen ? SkeuoColors.lcdPixelOn : SkeuoColors.amberPixelOn;
    final Color pixelGlow = isGreen ? SkeuoColors.lcdPixelGlow : SkeuoColors.amberPixelGlow;
    final Color pixelDim = isGreen ? SkeuoColors.lcdPixelDim : SkeuoColors.amberPixelDim;

    return Container(
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        // Machined dark chassis bezel
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF383D43),
            Color(0xFF24272B),
            Color(0xFF191B1E),
          ],
        ),
        border: Border.all(color: const Color(0xFF383D43), width: 1.2),
        boxShadow: const [
          BoxShadow(
            color: Color(0xBB000000),
            offset: Offset(1, 3),
            blurRadius: 6,
          ),
        ],
      ),
      padding: const EdgeInsets.all(7.0),
      child: Stack(
        children: [
          // Corner screws on the display bezel
          if (showScrews) ...[
            const Positioned(
              top: 3,
              left: 3,
              child: MetalScrew(size: 8, material: ScrewMaterial.blackIron, angle: 0.6),
            ),
            const Positioned(
              top: 3,
              right: 3,
              child: MetalScrew(size: 8, material: ScrewMaterial.blackIron, angle: 2.3),
            ),
            const Positioned(
              bottom: 3,
              left: 3,
              child: MetalScrew(size: 8, material: ScrewMaterial.blackIron, angle: 1.4),
            ),
            const Positioned(
              bottom: 3,
              right: 3,
              child: MetalScrew(size: 8, material: ScrewMaterial.blackIron, angle: 3.8),
            ),
          ],

          // Recessed Screen Cavity
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Container(
              decoration: BoxDecoration(
                color: screenBg,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: const Color(0xFF030704), width: 1.5),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0xDD000000),
                    offset: Offset(0, 2),
                    blurRadius: 4,
                    spreadRadius: -1,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(3),
                child: Stack(
                  children: [
                    // 1. Scanlines background
                    Positioned.fill(
                      child: CustomPaint(
                        painter: _ScanlinesPainter(isGreen: isGreen),
                      ),
                    ),

                    // 2. Phosphor LCD Content
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Header line with subtle matrix dots
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                title.toUpperCase(),
                                style: TextStyle(
                                  fontFamily: 'monospace',
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 2.5,
                                  color: pixelOn,
                                  shadows: [
                                    Shadow(color: pixelGlow, blurRadius: 6),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  for (int i = 0; i < 3; i++)
                                    Container(
                                      width: 4,
                                      height: 4,
                                      margin: const EdgeInsets.only(left: 3),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: i == 0 ? pixelOn : pixelDim,
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Container(
                            height: 1.0,
                            color: pixelDim.withValues(alpha: 0.6),
                          ),
                          const SizedBox(height: 8),

                          // Dynamic Key-Value Rows
                          ...statusItems.entries.map((entry) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2.5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      entry.key.toUpperCase(),
                                      style: TextStyle(
                                        fontFamily: 'monospace',
                                        fontSize: 10.5,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 1.2,
                                        color: pixelOn.withValues(alpha: 0.9),
                                        shadows: [
                                          Shadow(color: pixelGlow, blurRadius: 4),
                                        ],
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    entry.value.toUpperCase(),
                                    style: TextStyle(
                                      fontFamily: 'monospace',
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 1.2,
                                      color: pixelOn,
                                      shadows: [
                                        Shadow(color: pixelGlow, blurRadius: 8),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ],
                      ),
                    ),

                    // 3. Glass surface glare sheen
                    Positioned.fill(
                      child: IgnorePointer(
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(0x22FFFFFF),
                                Color(0x08FFFFFF),
                                Color(0x00FFFFFF),
                                Color(0x14FFFFFF),
                              ],
                              stops: [0.0, 0.3, 0.6, 1.0],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ScanlinesPainter extends CustomPainter {
  final bool isGreen;
  _ScanlinesPainter({required this.isGreen});

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = const Color(0x24000000)
      ..strokeWidth = 1.0;

    for (double y = 0; y < size.height; y += 3.0) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), linePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _ScanlinesPainter oldDelegate) => false;
}
