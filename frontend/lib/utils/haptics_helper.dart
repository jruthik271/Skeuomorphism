import 'sound_helper.dart';

/// HapticsHelper provides tactile feedback for physical switches,
/// button springs, and knob ratchets, integrating sound on web.
class HapticsHelper {
  HapticsHelper._();

  static void click() => SoundHelper.click();
  static void lightImpact() => SoundHelper.sliderTick();
  static void mediumImpact() => SoundHelper.switchClack();
  static void heavyImpact() => SoundHelper.heavyImpact();
}
