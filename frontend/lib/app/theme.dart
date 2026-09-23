import 'package:flutter/material.dart';
import '../styles/skeuo_colors.dart';

class SkeuoTheme {
  SkeuoTheme._();

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: SkeuoColors.walnutDeep,
      primaryColor: SkeuoColors.brassMid,
      colorScheme: const ColorScheme.dark(
        primary: SkeuoColors.brassLight,
        secondary: SkeuoColors.metalMid,
        surface: SkeuoColors.charcoalSurface,
      ),
      fontFamily: 'sans-serif',
      textTheme: const TextTheme(
        headlineMedium: TextStyle(
          fontFamily: 'serif',
          fontWeight: FontWeight.w900,
          color: SkeuoColors.paperIvory,
          letterSpacing: 2.0,
        ),
        titleMedium: TextStyle(
          fontWeight: FontWeight.w800,
          color: SkeuoColors.metalLight,
          letterSpacing: 1.5,
        ),
        bodyMedium: TextStyle(
          color: SkeuoColors.paperIvory,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
    );
  }
}
