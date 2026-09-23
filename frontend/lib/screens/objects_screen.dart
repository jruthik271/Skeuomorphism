import 'package:flutter/material.dart';
import '../styles/skeuo_colors.dart';
import '../styles/skeuo_shadows.dart';
import '../widgets/common/engraved_plate.dart';
import '../widgets/common/metal_screw.dart';
import '../widgets/common/skeuo_panel.dart';
import '../widgets/controls/analog_meter.dart';
import '../widgets/controls/mechanical_rocker.dart';
import '../widgets/controls/physical_checkbox.dart';
import '../widgets/controls/skeuo_button.dart';
import '../widgets/controls/skeuo_knob.dart';
import '../widgets/controls/skeuo_slider.dart';
import '../widgets/controls/skeuo_switch.dart';
import '../widgets/displays/lcd_display.dart';
import '../widgets/displays/radio_dial.dart';

/// ObjectsScreen showcases the 10 individual Skeuomorphic UI components,
/// each demonstrating a distinct physical modeling technique:
/// materials, specular lighting, mechanical spring physics, and reflections.
class ObjectsScreen extends StatefulWidget {
  const ObjectsScreen({super.key});

  @override
  State<ObjectsScreen> createState() => _ObjectsScreenState();
}

class _ObjectsScreenState extends State<ObjectsScreen> {
  // Showcase state variables
  bool _toggleVal = true;
  double _knobVal = 64.0;
  double _sliderVal = 45.0;
  double _meterVal = 72.0;
  bool _checkboxVal = true;
  bool _rockerVal = true;
  int _buttonPresses = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF140E0A), // Deep walnut base
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Plaque Header
              const Center(
                child: EngravedPlate(
                  title: 'OBJECTS SHOWCASE',
                  subtitle: '10 Skeuomorphic Artifacts & Techniques',
                  material: PlateMaterial.brass,
                  titleFontSize: 20,
                  subtitleFontSize: 10,
                  paddingVertical: 12,
                  paddingHorizontal: 20,
                ),
              ),
              const SizedBox(height: 14),

              // 1. Metal Button
              _buildShowcaseCard(
                index: '01',
                title: 'MACHINED METAL BUTTON',
                technique: 'Cylindrical 3D Stroke • Lathe Bevel • Dynamic Contact Shadow',
                child: Center(
                  child: Column(
                    children: [
                      SkeuoButton(
                        label: 'TRIGGER',
                        type: ButtonType.machinedMetal,
                        width: 120,
                        height: 52,
                        onPressed: () {
                          setState(() => _buttonPresses++);
                        },
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'PRESS COUNT: $_buttonPresses',
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4A525D),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 2. Toggle Switch
              _buildShowcaseCard(
                index: '02',
                title: 'CHROME TOGGLE SWITCH',
                technique: 'Bat Lever Pivot • Hex Collar Nut • Jewel LED Bloom',
                child: Center(
                  child: SkeuoSwitch(
                    value: _toggleVal,
                    label: 'IGNITION',
                    onChanged: (v) => setState(() => _toggleVal = v),
                  ),
                ),
              ),

              // 3. Rotary Knob
              _buildShowcaseCard(
                index: '03',
                title: 'ROTARY POTENTIOMETER',
                technique: 'Knurled Fluting • Offset Specular Flare • Circular Engraved Scale',
                child: Center(
                  child: SkeuoKnob(
                    value: _knobVal,
                    label: 'OUTPUT LEVEL',
                    size: 110,
                    onChanged: (v) => setState(() => _knobVal = v),
                  ),
                ),
              ),

              // 4. Slider
              _buildShowcaseCard(
                index: '04',
                title: 'MIXING CONSOLE FADER',
                technique: 'Recessed Cavity Slot • Ribbed Finger Cap • Decibel Scale',
                child: Center(
                  child: SkeuoSlider(
                    value: _sliderVal,
                    label: 'REVERB SEND',
                    length: 260,
                    onChanged: (v) => setState(() => _sliderVal = v),
                  ),
                ),
              ),

              // 5. Radio Dial
              _buildShowcaseCard(
                index: '05',
                title: 'ILLUMINATED RADIO DIAL',
                technique: 'Incandescent Amber Backlight • Sliding Cursor • Glass Glare',
                child: const RadioDial(),
              ),

              // 6. Analog Meter
              _buildShowcaseCard(
                index: '06',
                title: 'ANALOG VU POWER GAUGE',
                technique: 'Curved Calibrated Scale • Logarithmic Redline • Needle Dampening',
                child: Center(
                  child: Column(
                    children: [
                      AnalogMeter(
                        value: _meterVal,
                        label: 'SIGNAL',
                        unit: 'dB',
                        width: 180,
                        height: 120,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildMicroAdjustButton('-10', () {
                            setState(() => _meterVal = (_meterVal - 10).clamp(0.0, 100.0));
                          }),
                          const SizedBox(width: 12),
                          _buildMicroAdjustButton('+10', () {
                            setState(() => _meterVal = (_meterVal + 10).clamp(0.0, 100.0));
                          }),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // 7. Physical Checkbox
              _buildShowcaseCard(
                index: '07',
                title: 'SLIDING BRASS BOLT CHECKBOX',
                technique: 'Heavy Machined Bolt • Cavity Reveal • Physical Travel',
                child: Center(
                  child: PhysicalCheckbox(
                    value: _checkboxVal,
                    label: 'ARM SAFETY SYSTEM',
                    onChanged: (v) => setState(() => _checkboxVal = v),
                  ),
                ),
              ),

              // 8. Mechanical Switch
              _buildShowcaseCard(
                index: '08',
                title: 'INDUSTRIAL ROCKER SWITCH',
                technique: 'Two-Position Central Pivot • Tactile Click • High-Contrast State',
                child: Center(
                  child: MechanicalRocker(
                    value: _rockerVal,
                    label: 'PUMP INTERLOCK',
                    onChanged: (v) => setState(() => _rockerVal = v),
                  ),
                ),
              ),

              // 9. LCD Display
              _buildShowcaseCard(
                index: '09',
                title: 'CATHODE VFD DISPLAY',
                technique: 'Phosphor Bloom • CRT Horizontal Scanlines • Glass Bezel Frame',
                child: const LcdDisplay(
                  title: 'TELETYPE RX-9',
                  statusItems: {
                    'CHANNEL': '04-BETA',
                    'BAUD': '9600 BPS',
                    'CARRIER': 'DETECTED',
                    'SIGNAL': '-42 dBm',
                  },
                ),
              ),

              // 10. Vintage Card
              _buildShowcaseCard(
                index: '10',
                title: 'VINTAGE WARRANTY CARD',
                technique: 'Aged Cream Manila Paper • Brass Grommet • Letterpress Ink Stamp',
                child: _buildVintagePaperCard(),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShowcaseCard({
    required String index,
    required String title,
    required String technique,
    required Widget child,
  }) {
    return SkeuoPanel(
      material: PanelMaterial.aluminum,
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Row: Index number badge & Title
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                  color: const Color(0xFF1B1E22),
                  border: Border.all(color: const Color(0xFF383D44)),
                ),
                child: Text(
                  index,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    color: SkeuoColors.brassLight,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 11.0,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.5,
                    color: const Color(0xFF24272B),
                    shadows: SkeuoShadows.engravedText(
                      darkShadow: const Color(0x99000000),
                      highlight: Colors.white.withValues(alpha: 0.6),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),

          // Technique pill
          Text(
            technique.toUpperCase(),
            style: const TextStyle(
              fontSize: 8.5,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
              color: Color(0xFF6B737D),
            ),
          ),
          const SizedBox(height: 12),

          // Component Sandbox
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF14171A),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFF0F1113), width: 1.2),
              boxShadow: const [
                BoxShadow(
                  color: Color(0xAA000000),
                  offset: Offset(0, 2),
                  blurRadius: 4,
                ),
              ],
            ),
            child: child,
          ),
        ],
      ),
    );
  }

  Widget _buildMicroAdjustButton(String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          gradient: const LinearGradient(
            colors: [Color(0xFFE2E7ED), Color(0xFF8B939E)],
          ),
          border: Border.all(color: Colors.white.withValues(alpha: 0.7), width: 0.8),
          boxShadow: const [
            BoxShadow(color: Color(0x88000000), offset: Offset(0, 1), blurRadius: 2),
          ],
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w900,
            color: Color(0xFF1E2226),
          ),
        ),
      ),
    );
  }

  Widget _buildVintagePaperCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFFAF6EB),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: const Color(0xFFD4C8B2), width: 1.0),
        boxShadow: const [
          BoxShadow(
            color: Color(0xAA000000),
            offset: Offset(2, 4),
            blurRadius: 8,
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Stack(
        children: [
          // Brass Grommet Eyelet in top-right corner
          const Positioned(
            top: 0,
            right: 0,
            child: MetalScrew(
              size: 14,
              material: ScrewMaterial.brass,
              angle: 1.1,
            ),
          ),

          // Content
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'CERTIFICATE OF CRAFTSMANSHIP',
                style: TextStyle(
                  fontFamily: 'serif',
                  fontSize: 11.5,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2.0,
                  color: Color(0xFF4A3420),
                ),
              ),
              const SizedBox(height: 4),
              Container(width: 80, height: 1.0, color: const Color(0xFFB58832)),
              const SizedBox(height: 10),
              const Text(
                'Every curve, shadow gradient, and tactile stroke in this showcase is rendered natively using Flutter CustomPainter and BoxDecorations without external bitmap sprites.',
                style: TextStyle(
                  fontFamily: 'serif',
                  fontSize: 11.0,
                  height: 1.45,
                  color: Color(0xFF2C241B),
                ),
              ),
              const SizedBox(height: 12),

              // Letterpress Wax Stamp
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 12,
                runSpacing: 8,
                children: [
                  const Text(
                    'SERIES NO: SK-2026-FLTR',
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 9.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF7A6855),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFFB71C1C), width: 1.5),
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: const Text(
                      'VERIFIED SKEUOMORPHIC',
                      style: TextStyle(
                        fontFamily: 'sans-serif',
                        fontSize: 7.5,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.2,
                        color: Color(0xFFB71C1C),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
