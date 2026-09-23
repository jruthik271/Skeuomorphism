import 'package:flutter/material.dart';
import '../styles/skeuo_colors.dart';
import '../widgets/common/metal_screw.dart';

enum AppThemeMode {
  walnut('Dark Walnut', 'Solid oiled timber & brass', SkeuoColors.walnutDeep, ScrewMaterial.brass),
  aluminum('Brushed Aluminum', 'Aerospace alloy & chrome', Color(0xFF2C3238), ScrewMaterial.chrome),
  gunmetal('Stealth Gunmetal', 'Cast iron & black titanium', SkeuoColors.charcoalBlack, ScrewMaterial.blackIron),
  amberCrt('Amber Terminal', 'Retro vacuum tube chamber', Color(0xFF140B04), ScrewMaterial.brass);

  final String label;
  final String description;
  final Color backgroundColor;
  final ScrewMaterial screwMaterial;

  const AppThemeMode(this.label, this.description, this.backgroundColor, this.screwMaterial);
}

enum DesktopViewMode {
  responsiveStudio, // Multi-panel responsive desktop workbench
  focusedConsole,   // Fixed centered hardware console
}

class ThemeController extends ChangeNotifier {
  static final ThemeController instance = ThemeController._internal();
  ThemeController._internal();

  AppThemeMode _themeMode = AppThemeMode.walnut;
  bool _soundEnabled = true;
  DesktopViewMode _viewMode = DesktopViewMode.responsiveStudio;

  AppThemeMode get themeMode => _themeMode;
  bool get soundEnabled => _soundEnabled;
  DesktopViewMode get viewMode => _viewMode;

  void setThemeMode(AppThemeMode mode) {
    if (_themeMode != mode) {
      _themeMode = mode;
      notifyListeners();
    }
  }

  void toggleSound() {
    _soundEnabled = !_soundEnabled;
    notifyListeners();
  }

  void setSoundEnabled(bool enabled) {
    if (_soundEnabled != enabled) {
      _soundEnabled = enabled;
      notifyListeners();
    }
  }

  void toggleViewMode() {
    _viewMode = _viewMode == DesktopViewMode.responsiveStudio
        ? DesktopViewMode.focusedConsole
        : DesktopViewMode.responsiveStudio;
    notifyListeners();
  }
}
