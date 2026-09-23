import 'package:flutter/material.dart';

/// SkeuoColors defines a rich, authentic palette of real-world materials:
/// dark walnut wood, antique brass, brushed aluminum, stitched leather,
/// cream ledger paper, and glowing cathode/phosphor indicators.
class SkeuoColors {
  SkeuoColors._();

  // --- Dark Walnut Wood Palette ---
  static const Color walnutDeep = Color(0xFF140D08);
  static const Color walnutDark = Color(0xFF1F140D);
  static const Color walnutMedium = Color(0xFF2E1E14);
  static const Color walnutLight = Color(0xFF452C1E);
  static const Color walnutHighlight = Color(0xFF5E3D2A);
  static const Color woodGrainStreak = Color(0x18000000);

  // --- Machined Metal & Brushed Aluminum Palette ---
  static const Color metalSheen = Color(0xFFFFFFFF);
  static const Color metalLight = Color(0xFFE2E6EA);
  static const Color metalMid = Color(0xFFA8B0B8);
  static const Color metalDark = Color(0xFF6B737D);
  static const Color metalDeep = Color(0xFF383D43);
  static const Color metalBevel = Color(0xFF22252A);

  // --- Antique Brass & Bronze Palette ---
  static const Color brassHighlight = Color(0xFFFBE6A2);
  static const Color brassLight = Color(0xFFDFB660);
  static const Color brassMid = Color(0xFFB58832);
  static const Color brassDark = Color(0xFF735016);
  static const Color brassShadow = Color(0xFF3B2707);

  // --- Industrial Copper Palette ---
  static const Color copperHighlight = Color(0xFFFFBFA3);
  static const Color copperLight = Color(0xFFE08B63);
  static const Color copperMid = Color(0xFFB35933);
  static const Color copperDark = Color(0xFF6E3117);

  // --- Deep Charcoal / Cast Iron Chassis ---
  static const Color charcoalBlack = Color(0xFF0F1113);
  static const Color charcoalDeep = Color(0xFF181B1E);
  static const Color charcoalSurface = Color(0xFF24272B);
  static const Color charcoalBorder = Color(0xFF383D42);
  static const Color charcoalBevel = Color(0xFF50565E);

  // --- Rich Saddle Leather Palette ---
  static const Color leatherDeep = Color(0xFF1A120D);
  static const Color leatherDark = Color(0xFF281C14);
  static const Color leatherMid = Color(0xFF3B2A1E);
  static const Color leatherHighlight = Color(0xFF523B2B);
  static const Color leatherStitch = Color(0xFFD8AA56);

  // --- Aged Parchment & Cream Paper Palette ---
  static const Color paperIvory = Color(0xFFFAF7EE);
  static const Color paperAged = Color(0xFFEBE3D0);
  static const Color paperShadow = Color(0xFFD4CABA);
  static const Color paperRuledLine = Color(0x33446688);
  static const Color paperInk = Color(0xFF2B2620);
  static const Color paperInkStamp = Color(0xFF8B2500);

  // --- Retro LCD & VFD Phosphor Palette ---
  static const Color lcdScreenBg = Color(0xFF0E1A11);
  static const Color lcdScreenBezel = Color(0xFF070E08);
  static const Color lcdPixelOn = Color(0xFF39FF14);
  static const Color lcdPixelGlow = Color(0x6639FF14);
  static const Color lcdPixelDim = Color(0xFF18381C);

  static const Color amberLcdBg = Color(0xFF1F1306);
  static const Color amberPixelOn = Color(0xFFFFB703);
  static const Color amberPixelGlow = Color(0x66FFB703);
  static const Color amberPixelDim = Color(0xFF4A3008);

  // --- Jewel LEDs (Glass Indicators with Internal Reflector) ---
  static const Color ledRedOn = Color(0xFFFF2A2A);
  static const Color ledRedOff = Color(0xFF4D0D0D);
  static const Color ledRedGlow = Color(0x99FF2A2A);

  static const Color ledGreenOn = Color(0xFF00FF66);
  static const Color ledGreenOff = Color(0xFF0C471E);
  static const Color ledGreenGlow = Color(0x9900FF66);

  static const Color ledAmberOn = Color(0xFFFF9E00);
  static const Color ledAmberOff = Color(0xFF4A2C00);
  static const Color ledAmberGlow = Color(0x99FF9E00);

  static const Color ledBlueOn = Color(0xFF00C8FF);
  static const Color ledBlueOff = Color(0xFF003055);
  static const Color ledBlueGlow = Color(0x9900C8FF);

  // --- Universal Lighting Constants ---
  static const Color ambientHighlight = Color(0x40FFFFFF);
  static const Color ambientHighlightSoft = Color(0x20FFFFFF);
  static const Color ambientShadow = Color(0x80000000);
  static const Color ambientShadowDeep = Color(0xCC000000);

  // --- Convenience Core & Glow Tokens ---
  static const Color brassCore = brassLight;
  static const Color brassGlow = Color(0x66DFB660);
  static const Color aluminumCore = metalLight;
  static const Color aluminumShadow = metalDark;
}
