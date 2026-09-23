import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import '../services/theme_controller.dart';
import 'sound_helper_stub.dart' if (dart.library.js_interop) 'sound_helper_web.dart';

/// SoundHelper coordinates tactile haptics on mobile devices and synthesized
/// mechanical acoustic feedback on web browsers.
class SoundHelper {
  SoundHelper._();

  static void click() {
    if (!ThemeController.instance.soundEnabled) return;
    try {
      HapticFeedback.selectionClick();
    } catch (_) {}
    if (kIsWeb) {
      playWebSound('click');
    }
  }

  static void switchClack() {
    if (!ThemeController.instance.soundEnabled) return;
    try {
      HapticFeedback.mediumImpact();
    } catch (_) {}
    if (kIsWeb) {
      playWebSound('clack');
    }
  }

  static void sliderTick() {
    if (!ThemeController.instance.soundEnabled) return;
    try {
      HapticFeedback.lightImpact();
    } catch (_) {}
    if (kIsWeb) {
      playWebSound('tick');
    }
  }

  static void heavyImpact() {
    if (!ThemeController.instance.soundEnabled) return;
    try {
      HapticFeedback.heavyImpact();
    } catch (_) {}
    if (kIsWeb) {
      playWebSound('clack');
    }
  }

  static void playMechanicalClick() => click();
  static void playToggleSwitch() => switchClack();
}
