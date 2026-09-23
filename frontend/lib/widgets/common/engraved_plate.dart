import 'package:flutter/material.dart';
import '../../styles/skeuo_colors.dart';
import '../../styles/skeuo_decorations.dart';
import '../../styles/skeuo_shadows.dart';
import 'metal_screw.dart';

enum PlateMaterial { brass, aluminum, gunmetal }

/// A realistic engraved/embossed metal nameplate with chamfered bevels,
/// engraved letterpress typography, and corner mounting screws.
class EngravedPlate extends StatelessWidget {
  final String title;
  final String? subtitle;
  final PlateMaterial material;
  final double? width;
  final double paddingVertical;
  final double paddingHorizontal;
  final bool showScrews;
  final double titleFontSize;
  final double subtitleFontSize;
  final double? letterSpacing;

  const EngravedPlate({
    super.key,
    required this.title,
    this.subtitle,
    this.material = PlateMaterial.brass,
    this.width,
    this.paddingVertical = 12.0,
    this.paddingHorizontal = 24.0,
    this.showScrews = true,
    this.titleFontSize = 24.0,
    this.subtitleFontSize = 11.0,
    this.letterSpacing,
  });

  @override
  Widget build(BuildContext context) {
    final isBrass = material == PlateMaterial.brass;
    final isGunmetal = material == PlateMaterial.gunmetal;

    final screwMaterial = isBrass
        ? ScrewMaterial.brass
        : isGunmetal
            ? ScrewMaterial.blackIron
            : ScrewMaterial.chrome;

    final textColor = isBrass
        ? const Color(0xFF4A3208)
        : isGunmetal
            ? const Color(0xFF141618)
            : const Color(0xFF2E3339);

    final highlightColor = isBrass
        ? SkeuoColors.brassHighlight.withValues(alpha: 0.8)
        : isGunmetal
            ? SkeuoColors.charcoalBevel.withValues(alpha: 0.6)
            : Colors.white.withValues(alpha: 0.9);

    return Container(
      width: width,
      decoration: isBrass
          ? SkeuoStyles.brass(borderRadius: BorderRadius.circular(6))
          : SkeuoStyles.metal(
              isDark: isGunmetal,
              borderRadius: BorderRadius.circular(6),
            ),
      child: Stack(
        children: [
          // Corner screws
          if (showScrews) ...[
            Positioned(
              top: 6,
              left: 6,
              child: MetalScrew(size: 11, material: screwMaterial, angle: 0.7),
            ),
            Positioned(
              top: 6,
              right: 6,
              child: MetalScrew(size: 11, material: screwMaterial, angle: 2.1),
            ),
            Positioned(
              bottom: 6,
              left: 6,
              child: MetalScrew(size: 11, material: screwMaterial, angle: 1.2),
            ),
            Positioned(
              bottom: 6,
              right: 6,
              child: MetalScrew(size: 11, material: screwMaterial, angle: 3.4),
            ),
          ],

          // Stamped inner border and engraved content
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: paddingVertical,
              horizontal: paddingHorizontal,
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                border: Border.all(
                  color: isBrass
                      ? const Color(0x444A3208)
                      : isGunmetal
                          ? const Color(0x33000000)
                          : const Color(0x33444A52),
                  width: 0.8,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'serif',
                      fontSize: titleFontSize,
                      fontWeight: FontWeight.w900,
                      letterSpacing: letterSpacing ?? (titleFontSize <= 14 ? 1.8 : 4.5),
                      color: textColor,
                      shadows: SkeuoShadows.engravedText(
                        darkShadow: isBrass
                            ? const Color(0xAA3B2707)
                            : const Color(0xCC000000),
                        highlight: highlightColor,
                      ),
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle!.toUpperCase(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'sans-serif',
                        fontSize: subtitleFontSize,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 2.2,
                        color: textColor.withValues(alpha: 0.85),
                        shadows: SkeuoShadows.engravedText(
                          darkShadow: isBrass
                              ? const Color(0x883B2707)
                              : const Color(0xAA000000),
                          highlight: highlightColor.withValues(alpha: 0.7),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
