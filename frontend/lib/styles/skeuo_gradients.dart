import 'package:flutter/material.dart';
import 'skeuo_colors.dart';

/// SkeuoGradients defines multi-stop linear and radial gradient models
/// that replicate brushed aluminum, turned brass, convex cylinders,
/// recessed cavities, and reflective optical glass.
class SkeuoGradients {
  SkeuoGradients._();

  /// Brushed aluminum with alternating metallic specular bands
  static const LinearGradient brushedAluminum = LinearGradient(
    begin: Alignment(-0.8, -1.0),
    end: Alignment(0.8, 1.0),
    colors: [
      Color(0xFFE6EAEF),
      Color(0xFFBFC6CE),
      Color(0xFFDFE4EB),
      Color(0xFFA6AFB8),
      Color(0xFFCDD4DC),
      Color(0xFF8E97A2),
      Color(0xFFB8C0CA),
    ],
    stops: [0.0, 0.18, 0.38, 0.55, 0.72, 0.88, 1.0],
  );

  /// Dark gunmetal / titanium brushed finish
  static const LinearGradient darkGunmetal = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF42474E),
      Color(0xFF2B2F34),
      Color(0xFF383D43),
      Color(0xFF1E2124),
      Color(0xFF31363C),
    ],
    stops: [0.0, 0.25, 0.5, 0.75, 1.0],
  );

  /// Antique turned brass with warm golden and bronze sheen
  static const LinearGradient antiqueBrass = LinearGradient(
    begin: Alignment(-0.9, -1.0),
    end: Alignment(0.9, 1.0),
    colors: [
      SkeuoColors.brassHighlight,
      SkeuoColors.brassLight,
      SkeuoColors.brassMid,
      SkeuoColors.brassHighlight,
      SkeuoColors.brassDark,
      SkeuoColors.brassMid,
    ],
    stops: [0.0, 0.22, 0.48, 0.65, 0.85, 1.0],
  );

  /// Industrial copper gradient with radiant warm tones
  static const LinearGradient copper = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      SkeuoColors.copperHighlight,
      SkeuoColors.copperLight,
      SkeuoColors.copperMid,
      SkeuoColors.copperHighlight,
      SkeuoColors.copperDark,
    ],
    stops: [0.0, 0.25, 0.55, 0.75, 1.0],
  );

  /// Dark walnut chassis wood subtle depth gradient
  static const LinearGradient walnutChassis = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      SkeuoColors.walnutLight,
      SkeuoColors.walnutMedium,
      SkeuoColors.walnutDark,
      SkeuoColors.walnutDeep,
    ],
    stops: [0.0, 0.15, 0.7, 1.0],
  );

  /// Convex cylindrical button (simulates 3D curved cylinder facing the user)
  static const LinearGradient convexCylinder = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFFFFFFF),
      Color(0xFFD4D9DF),
      Color(0xFFA0A8B2),
      Color(0xFF6B727C),
      Color(0xFF4C525B),
    ],
    stops: [0.0, 0.1, 0.5, 0.85, 1.0],
  );

  /// Concave recessed indentation (simulates pressed thumb-well)
  static const LinearGradient concaveWell = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF282C32),
      Color(0xFF383E46),
      Color(0xFF565D68),
      Color(0xFF707986),
    ],
    stops: [0.0, 0.35, 0.8, 1.0],
  );

  /// Industrial push button cap (heavy red or amber industrial mushroom button)
  static LinearGradient pushButtonCap({
    required Color primaryColor,
    required Color highlightColor,
    required Color shadowColor,
  }) {
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        highlightColor,
        primaryColor,
        primaryColor,
        shadowColor,
      ],
      stops: const [0.0, 0.2, 0.8, 1.0],
    );
  }

  /// Radial metallic reflection for circular knobs and rotary dials
  static RadialGradient rotaryKnobTop({
    Color centerHighlight = const Color(0xFFFFFFFF),
    Color midTone = const Color(0xFFC0C7CE),
    Color edgeTone = const Color(0xFF757D87),
  }) {
    return RadialGradient(
      center: const Alignment(-0.25, -0.3),
      radius: 0.85,
      colors: [
        centerHighlight,
        midTone,
        edgeTone,
        edgeTone.withValues(alpha: 0.9),
      ],
      stops: const [0.0, 0.45, 0.85, 1.0],
    );
  }

  /// Curved glass specular reflection (e.g., lens, gauge face, LCD bezel)
  static const LinearGradient glassSpecularSheen = LinearGradient(
    begin: Alignment(-0.8, -1.0),
    end: Alignment(0.8, 1.0),
    colors: [
      Color(0x55FFFFFF),
      Color(0x1AFFFFFF),
      Color(0x00FFFFFF),
      Color(0x10FFFFFF),
      Color(0x35FFFFFF),
    ],
    stops: [0.0, 0.28, 0.5, 0.72, 1.0],
  );

  /// Recessed rail slot gradient (audio mixer fader track)
  static const LinearGradient recessedTrack = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      Color(0xFF0C0E10),
      Color(0xFF1B1E22),
      Color(0xFF0C0E10),
    ],
    stops: [0.0, 0.5, 1.0],
  );
}
