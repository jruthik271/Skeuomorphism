import 'package:flutter/material.dart';
import '../styles/skeuo_colors.dart';
import '../widgets/common/engraved_plate.dart';
import '../widgets/common/skeuo_panel.dart';
import '../widgets/composite/skeuo_camera.dart';
import '../widgets/composite/skeuo_notebook.dart';
import '../widgets/composite/vintage_player.dart';
import '../widgets/controls/analog_meter.dart';
import '../widgets/controls/skeuo_button.dart';
import '../widgets/controls/skeuo_knob.dart';
import '../widgets/controls/skeuo_slider.dart';
import '../widgets/controls/skeuo_switch.dart';
import '../widgets/displays/lcd_display.dart';

/// HomeScreen presents the flagship SkeuoLab laboratory console:
/// the engraved brass nameplate, main interactive control panel,
/// industrial status LCD, vintage tape deck, rangefinder camera, and leather notebook.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _powerOn = true;
  double _volume = 72.0;
  double _intensity = 64.0;
  int _pressCount = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF140D08), // Dark walnut background tone
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Realistic Engraved Title Plate
              const Center(
                child: EngravedPlate(
                  title: 'SKEUOLAB',
                  subtitle: 'Flutter Skeuomorphism Showcase',
                  material: PlateMaterial.brass,
                  titleFontSize: 26,
                  subtitleFontSize: 10,
                  paddingVertical: 14,
                  paddingHorizontal: 28,
                ),
              ),
              const SizedBox(height: 14),

              // 2. Main Laboratory Control Panel (Walnut Wood & Brushed Metal)
              SkeuoPanel(
                material: PanelMaterial.walnut,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Section title plate
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Flexible(
                          child: EngravedPlate(
                            title: 'MAIN CONTROL CONSOLE',
                            material: PlateMaterial.gunmetal,
                            showScrews: false,
                            titleFontSize: 10,
                            letterSpacing: 1.5,
                            paddingVertical: 4,
                            paddingHorizontal: 8,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFF101214),
                            borderRadius: BorderRadius.circular(3),
                            border: Border.all(color: const Color(0xFF32363C)),
                          ),
                          child: Text(
                            _powerOn ? 'SYSTEM ACTIVE' : 'STANDBY',
                            style: TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 9.0,
                              fontWeight: FontWeight.w900,
                              color: _powerOn ? SkeuoColors.ledGreenOn : const Color(0xFF5A6068),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Top Controls Row: Toggle Switch + Push Button + VU Meter
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Metal Toggle Switch
                        SkeuoSwitch(
                          value: _powerOn,
                          label: 'POWER',
                          onChanged: (val) {
                            setState(() => _powerOn = val);
                          },
                        ),

                        // Push Button with spring travel
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SkeuoButton(
                              label: 'PRESS',
                              width: 86,
                              height: 52,
                              onPressed: () {
                                setState(() => _pressCount++);
                              },
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'COUNT: $_pressCount',
                              style: const TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 9.0,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFD4A853),
                              ),
                            ),
                          ],
                        ),

                        // Analog VU Meter
                        AnalogMeter(
                          value: _powerOn ? _intensity : 0.0,
                          label: 'LOAD',
                          width: 120,
                          height: 95,
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),

                    // Middle Controls Row: Rotary Knob + Mixer Slider
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Rotary Volume Knob
                        SkeuoKnob(
                          value: _volume,
                          min: 0,
                          max: 100,
                          label: 'VOLUME',
                          size: 105,
                          onChanged: (val) {
                            setState(() => _volume = val);
                          },
                        ),

                        // Mechanical Mixer Slider
                        SkeuoSlider(
                          value: _intensity,
                          min: 0,
                          max: 100,
                          label: 'INTENSITY',
                          length: 170,
                          onChanged: (val) {
                            setState(() => _intensity = val);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // 3. Physical Industrial Status Display (LCD / VFD)
              LcdDisplay(
                title: 'SYSTEM TELEMETRY',
                statusItems: {
                  'POWER': _powerOn ? 'ONLINE [ON]' : 'STANDBY [OFF]',
                  'VOLUME': '${_volume.round()} dB',
                  'INTENSITY': '${_intensity.round()}%',
                  'MODE': 'CLASSIC SKEUO',
                  'CYCLES': '$_pressCount ACTS',
                },
              ),
              const SizedBox(height: 16),

              // 4. Vintage Cassette Player Section
              const VintagePlayer(),
              const SizedBox(height: 16),

              // 5. Digital Camera Component
              const SkeuoCamera(),
              const SizedBox(height: 16),

              // 6. Skeuomorphic Leather Notebook
              const SkeuoNotebook(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
