import 'package:flutter/material.dart';
import 'skeuo_colors.dart';

/// SkeuoShadows provides realistic lighting and shadow models
/// assuming a consistent primary directional key light from the top-left (315°).
class SkeuoShadows {
  SkeuoShadows._();

  /// Soft, deep shadow for heavy physical chassis and floating modules.
  static List<BoxShadow> chassis({double elevation = 8}) {
    return [
      BoxShadow(
        color: SkeuoColors.ambientShadowDeep,
        offset: Offset(elevation * 0.75, elevation),
        blurRadius: elevation * 2.5,
        spreadRadius: 1,
      ),
      BoxShadow(
        color: const Color(0x66000000),
        offset: Offset(elevation * 0.3, elevation * 0.4),
        blurRadius: elevation,
      ),
    ];
  }

  /// 3D Raised component: prominent cast shadow bottom-right,
  /// subtle ambient bleed, and crisp physical detachment.
  static List<BoxShadow> raised({
    double depth = 4.0,
    Color shadowColor = const Color(0x8A000000),
    Color ambientColor = const Color(0x33000000),
  }) {
    return [
      // Primary directional cast shadow (bottom-right)
      BoxShadow(
        color: shadowColor,
        offset: Offset(depth * 0.7, depth),
        blurRadius: depth * 2.0,
        spreadRadius: 0.5,
      ),
      // Ambient contact shadow immediately under the object
      BoxShadow(
        color: ambientColor,
        offset: Offset(0, depth * 0.3),
        blurRadius: depth,
      ),
      // Top-left ambient reflection catch
      BoxShadow(
        color: SkeuoColors.ambientHighlightSoft,
        offset: Offset(-depth * 0.25, -depth * 0.25),
        blurRadius: depth * 0.5,
      ),
    ];
  }

  /// Pressed / Depressed state: collapsed outer shadow with dark perimeter
  static List<BoxShadow> pressed({
    double depth = 1.5,
    Color shadowColor = const Color(0x99000000),
  }) {
    return [
      BoxShadow(
        color: shadowColor,
        offset: Offset(depth * 0.3, depth * 0.5),
        blurRadius: depth * 1.5,
        spreadRadius: 0,
      ),
    ];
  }

  /// Circular dial and knob casting a realistic spherical/cylindrical shadow
  static List<BoxShadow> knob({double radius = 30}) {
    final double d = radius * 0.15;
    return [
      BoxShadow(
        color: const Color(0xBF000000),
        offset: Offset(d * 0.8, d * 1.2),
        blurRadius: d * 2.4,
        spreadRadius: 1,
      ),
      BoxShadow(
        color: const Color(0x66000000),
        offset: Offset(d * 0.3, d * 0.5),
        blurRadius: d * 1.0,
      ),
    ];
  }

  /// Glowing jewel LED casting soft radial emission bloom
  static List<BoxShadow> ledGlow(Color glowColor, {bool isOn = true}) {
    if (!isOn) {
      return [
        const BoxShadow(
          color: Color(0x40000000),
          offset: Offset(0, 1),
          blurRadius: 2,
        ),
      ];
    }
    return [
      BoxShadow(
        color: glowColor.withValues(alpha: 0.7),
        blurRadius: 12,
        spreadRadius: 2,
      ),
      BoxShadow(
        color: glowColor.withValues(alpha: 0.4),
        blurRadius: 24,
        spreadRadius: 6,
      ),
      BoxShadow(
        color: Colors.white.withValues(alpha: 0.6),
        blurRadius: 4,
        spreadRadius: 0,
      ),
    ];
  }

  /// Engraved / debossed text shadows (creates the illusion of text stamped into metal/wood)
  static List<Shadow> engravedText({
    Color darkShadow = const Color(0xFF000000),
    Color highlight = const Color(0x66FFFFFF),
  }) {
    return [
      // Top/left inward shadow
      Shadow(
        color: darkShadow,
        offset: const Offset(-0.8, -0.8),
        blurRadius: 1.0,
      ),
      // Bottom/right reflective lip
      Shadow(
        color: highlight,
        offset: const Offset(0.8, 0.8),
        blurRadius: 1.0,
      ),
    ];
  }

  /// Embossed / raised text shadows (creates the illusion of raised letters)
  static List<Shadow> embossedText({
    Color darkShadow = const Color(0xAA000000),
    Color highlight = const Color(0x99FFFFFF),
  }) {
    return [
      // Top highlight
      Shadow(
        color: highlight,
        offset: const Offset(0, -1.0),
        blurRadius: 1.0,
      ),
      // Bottom drop shadow
      Shadow(
        color: darkShadow,
        offset: const Offset(0, 1.2),
        blurRadius: 1.5,
      ),
    ];
  }
}
