import 'package:flutter/material.dart';

class AppConstants {
  AppConstants._();

  static const String appName = 'SkeuoLab';
  static const String appTitle = 'SKEUOLAB';
  static const String appSubtitle = 'Flutter Skeuomorphism Showcase';

  // Animation Timings
  static const Duration buttonPressDuration = Duration(milliseconds: 90);
  static const Duration switchToggleDuration = Duration(milliseconds: 180);
  static const Duration knobDragResponse = Duration(milliseconds: 16);
  static const Duration needleSpringDuration = Duration(milliseconds: 600);
  static const Duration shutterFlashDuration = Duration(milliseconds: 140);
  static const Duration notebookFlipDuration = Duration(milliseconds: 400);

  // Physical Dimensions
  static const double screwSizeSmall = 10.0;
  static const double screwSizeMedium = 14.0;
  static const double screwSizeLarge = 18.0;

  static const double standardBorderRadius = 10.0;
  static const double heavyBevelRadius = 14.0;

  // Custom Curves
  static const Curve springReleaseCurve = Curves.elasticOut;
  static const Curve mechanicalSnapCurve = Curves.easeOutBack;
}
