import 'package:flutter/material.dart';
import 'skeuo_colors.dart';
import 'skeuo_gradients.dart';
import 'skeuo_shadows.dart';

/// SkeuoStyles provides ready-to-use BoxDecoration and style presets
/// fulfilling the core Skeuomorphic aesthetic requirements:
/// raised physical objects, depressed switches, machined metal,
/// stitched leather, cream parchment paper, and engraved plates.
class SkeuoStyles {
  SkeuoStyles._();

  /// 3D Raised plate or button with crisp metallic edge bevels and directional cast shadows
  static BoxDecoration raised({
    BorderRadius? borderRadius,
    Gradient? gradient,
    Color? color,
    double depth = 4.0,
    Border? border,
  }) {
    final effectiveRadius = borderRadius ?? BorderRadius.circular(8);
    final effectiveGradient = gradient ?? (color == null ? SkeuoGradients.brushedAluminum : null);
    return BoxDecoration(
      color: effectiveGradient == null ? color : null,
      gradient: effectiveGradient,
      borderRadius: effectiveRadius,
      border: border ??
          Border.all(
            color: SkeuoColors.ambientHighlight,
            width: 1.0,
          ),
      boxShadow: SkeuoShadows.raised(depth: depth),
    );
  }

  /// 3D Pressed / Inset plate or button: collapsed drop shadow, inner darkening
  static BoxDecoration pressed({
    BorderRadius? borderRadius,
    Gradient? gradient,
    Color? color,
    double depth = 1.5,
  }) {
    final effectiveRadius = borderRadius ?? BorderRadius.circular(8);
    final effectiveGradient = gradient ??
        (color == null
            ? const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF6E757F),
                  Color(0xFF8B939E),
                  Color(0xFFA5ADB8),
                ],
                stops: [0.0, 0.4, 1.0],
              )
            : null);
    return BoxDecoration(
      color: effectiveGradient == null ? color : null,
      gradient: effectiveGradient,
      borderRadius: effectiveRadius,
      border: Border.all(color: const Color(0xFF33383F), width: 1.2),
      boxShadow: SkeuoShadows.pressed(depth: depth),
    );
  }

  /// Machined metal panel (brushed aluminum or dark gunmetal)
  static BoxDecoration metal({
    bool isDark = false,
    BorderRadius? borderRadius,
    double elevation = 6.0,
  }) {
    return BoxDecoration(
      gradient: isDark ? SkeuoGradients.darkGunmetal : SkeuoGradients.brushedAluminum,
      borderRadius: borderRadius ?? BorderRadius.circular(10),
      border: Border.all(
        color: isDark ? SkeuoColors.charcoalBevel : SkeuoColors.metalLight,
        width: 1.2,
      ),
      boxShadow: SkeuoShadows.chassis(elevation: elevation),
    );
  }

  /// Turned Antique Brass plate with golden sheen and machined screws
  static BoxDecoration brass({
    BorderRadius? borderRadius,
    double elevation = 6.0,
  }) {
    return BoxDecoration(
      gradient: SkeuoGradients.antiqueBrass,
      borderRadius: borderRadius ?? BorderRadius.circular(8),
      border: Border.all(
        color: SkeuoColors.brassHighlight,
        width: 1.2,
      ),
      boxShadow: SkeuoShadows.chassis(elevation: elevation),
    );
  }

  /// Rich, dark saddle leather with grain gradient and depth
  static BoxDecoration leather({
    BorderRadius? borderRadius,
    double elevation = 8.0,
  }) {
    return BoxDecoration(
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          SkeuoColors.leatherHighlight,
          SkeuoColors.leatherMid,
          SkeuoColors.leatherDark,
          SkeuoColors.leatherDeep,
        ],
        stops: [0.0, 0.3, 0.7, 1.0],
      ),
      borderRadius: borderRadius ?? BorderRadius.circular(14),
      border: Border.all(
        color: SkeuoColors.leatherHighlight.withValues(alpha: 0.6),
        width: 1.5,
      ),
      boxShadow: SkeuoShadows.chassis(elevation: elevation),
    );
  }

  /// Aged vintage cream ledger paper
  static BoxDecoration paper({
    BorderRadius? borderRadius,
    double elevation = 5.0,
  }) {
    return BoxDecoration(
      color: SkeuoColors.paperIvory,
      borderRadius: borderRadius ?? BorderRadius.circular(4),
      border: Border.all(
        color: SkeuoColors.paperShadow,
        width: 1.0,
      ),
      boxShadow: [
        BoxShadow(
          color: const Color(0x33000000),
          offset: const Offset(2, 4),
          blurRadius: 8,
        ),
        BoxShadow(
          color: const Color(0x1A000000),
          offset: const Offset(0, 1),
          blurRadius: 3,
        ),
      ],
    );
  }

  /// Recessed bay / slot (for switches, faders, LCD screens, cassette wells)
  static BoxDecoration recessedBay({
    BorderRadius? borderRadius,
    Color backgroundColor = const Color(0xFF14171A),
    double borderWidth = 1.8,
  }) {
    return BoxDecoration(
      color: backgroundColor,
      borderRadius: borderRadius ?? BorderRadius.circular(6),
      border: Border.all(color: const Color(0xFF101316), width: borderWidth),
      boxShadow: const [
        BoxShadow(
          color: Color(0x99000000),
          offset: Offset(0, 2),
          blurRadius: 4,
          spreadRadius: -1,
        ),
      ],
    );
  }

  /// Engraved / debossed metal plaque
  static BoxDecoration engravedPlate({
    BorderRadius? borderRadius,
    bool isBrass = false,
  }) {
    return BoxDecoration(
      gradient: isBrass ? SkeuoGradients.antiqueBrass : SkeuoGradients.brushedAluminum,
      borderRadius: borderRadius ?? BorderRadius.circular(6),
      border: Border.all(
        color: isBrass ? SkeuoColors.brassHighlight : SkeuoColors.metalSheen,
        width: 1.2,
      ),
      boxShadow: [
        BoxShadow(
          color: const Color(0x80000000),
          offset: const Offset(1, 3),
          blurRadius: 6,
        ),
      ],
    );
  }
}
