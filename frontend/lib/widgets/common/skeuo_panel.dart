import 'package:flutter/material.dart';
import '../../styles/skeuo_colors.dart';
import '../../styles/skeuo_decorations.dart';
import '../../styles/skeuo_gradients.dart';
import 'metal_screw.dart';

enum PanelMaterial { walnut, aluminum, gunmetal, darkMetal, brass, leather, recessed }

/// A realistic physical enclosure panel with tactile material textures,
/// corner bolts, and dimensional borders.
class SkeuoPanel extends StatelessWidget {
  final Widget child;
  final PanelMaterial material;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final bool showCornerScrews;
  final double? width;
  final double? height;
  final double borderRadius;
  final ScrewMaterial? screwMaterial;

  const SkeuoPanel({
    super.key,
    required this.child,
    this.material = PanelMaterial.aluminum,
    this.padding = const EdgeInsets.all(16.0),
    this.margin = const EdgeInsets.symmetric(vertical: 8.0),
    this.showCornerScrews = true,
    this.width,
    this.height,
    this.borderRadius = 10.0,
    this.screwMaterial,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveScrewMaterial = screwMaterial ??
        (material == PanelMaterial.walnut
            ? ScrewMaterial.brass
            : material == PanelMaterial.gunmetal
                ? ScrewMaterial.blackIron
                : ScrewMaterial.chrome);

    BoxDecoration panelDecoration;
    switch (material) {
      case PanelMaterial.walnut:
        panelDecoration = BoxDecoration(
          gradient: SkeuoGradients.walnutChassis,
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(
            color: SkeuoColors.walnutHighlight.withValues(alpha: 0.7),
            width: 1.5,
          ),
          boxShadow: [
            const BoxShadow(
              color: Color(0xDD000000),
              offset: Offset(3, 6),
              blurRadius: 16,
              spreadRadius: 2,
            ),
            const BoxShadow(
              color: Color(0x66000000),
              offset: Offset(0, 1),
              blurRadius: 3,
            ),
          ],
        );
        break;
      case PanelMaterial.aluminum:
        panelDecoration = SkeuoStyles.metal(
          isDark: false,
          borderRadius: BorderRadius.circular(borderRadius),
        );
        break;
      case PanelMaterial.gunmetal:
      case PanelMaterial.darkMetal:
        panelDecoration = SkeuoStyles.metal(
          isDark: true,
          borderRadius: BorderRadius.circular(borderRadius),
        );
        break;
      case PanelMaterial.brass:
        panelDecoration = BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFE5C070), Color(0xFF9E7728), Color(0xFF6B4E12)],
          ),
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(color: const Color(0xFFFFE8A3), width: 1.5),
          boxShadow: const [
            BoxShadow(color: Color(0xAA000000), offset: Offset(2, 4), blurRadius: 10),
          ],
        );
        break;
      case PanelMaterial.leather:
        panelDecoration = SkeuoStyles.leather(
          borderRadius: BorderRadius.circular(borderRadius),
        );
        break;
      case PanelMaterial.recessed:
        panelDecoration = SkeuoStyles.recessedBay(
          borderRadius: BorderRadius.circular(borderRadius),
        );
        break;
    }

    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: panelDecoration,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Stack(
          children: [
            // Custom wood grain lines if walnut material
            if (material == PanelMaterial.walnut)
              Positioned.fill(
                child: CustomPaint(
                  painter: _WoodGrainPainter(),
                ),
              ),

            // Subtle perimeter highlight line for 3D bevel
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 1.0,
              child: Container(
                color: Colors.white.withValues(alpha: 0.25),
              ),
            ),

            // Corner Screws
            if (showCornerScrews && material != PanelMaterial.recessed) ...[
              Positioned(
                top: 8,
                left: 8,
                child: MetalScrew(
                  size: 12,
                  material: effectiveScrewMaterial,
                  angle: 0.4,
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: MetalScrew(
                  size: 12,
                  material: effectiveScrewMaterial,
                  angle: 1.8,
                ),
              ),
              Positioned(
                bottom: 8,
                left: 8,
                child: MetalScrew(
                  size: 12,
                  material: effectiveScrewMaterial,
                  angle: 2.7,
                ),
              ),
              Positioned(
                bottom: 8,
                right: 8,
                child: MetalScrew(
                  size: 12,
                  material: effectiveScrewMaterial,
                  angle: 4.1,
                ),
              ),
            ],

            // Content
            Padding(
              padding: padding,
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}

class _WoodGrainPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final grainPaint = Paint()
      ..color = const Color(0x12000000)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    final step = 7.0;
    for (double y = 4; y < size.height; y += step) {
      final path = Path();
      path.moveTo(0, y);
      path.cubicTo(
        size.width * 0.3,
        y - 2.5,
        size.width * 0.7,
        y + 2.5,
        size.width,
        y,
      );
      canvas.drawPath(path, grainPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
