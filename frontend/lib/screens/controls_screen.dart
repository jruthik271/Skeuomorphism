import 'package:flutter/material.dart';
import '../styles/skeuo_colors.dart';
import '../widgets/common/engraved_plate.dart';
import '../widgets/common/led_indicator.dart';
import '../widgets/common/skeuo_panel.dart';
import '../widgets/controls/analog_meter.dart';
import '../widgets/controls/mechanical_rocker.dart';
import '../widgets/controls/physical_checkbox.dart';
import '../widgets/controls/skeuo_button.dart';
import '../widgets/controls/skeuo_knob.dart';
import '../widgets/controls/skeuo_slider.dart';
import '../widgets/controls/skeuo_switch.dart';

/// ControlsScreen provides an expansive, high-density vintage laboratory
/// dashboard featuring dual calibrated VU gauges, multi-band sliders,
/// heavy industrial rockers, annunciator warning lights, and tactile switches.
class ControlsScreen extends StatefulWidget {
  const ControlsScreen({super.key});

  @override
  State<ControlsScreen> createState() => _ControlsScreenState();
}

class _ControlsScreenState extends State<ControlsScreen> {
  double _channelA = 48.0;
  double _channelB = 68.0;
  double _frequency = 35.0;
  double _resonance = 82.0;

  bool _auxPower = true;
  bool _generatorLock = true;
  bool _rockerState = false;

  int _selectedMode = 2; // 0=OFF, 1=LOW, 2=MED, 3=HIGH, 4=MAX
  static const List<String> _modes = ['OFF', 'LOW', 'MED', 'HIGH', 'MAX'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF14171A), // Dark charcoal cast iron chassis
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
                  title: 'LABORATORY BENCH',
                  subtitle: 'Tactile Physical Instrumentation',
                  material: PlateMaterial.aluminum,
                  titleFontSize: 20,
                  subtitleFontSize: 10,
                  paddingVertical: 12,
                  paddingHorizontal: 22,
                ),
              ),
              const SizedBox(height: 12),

              // 1. Dual Calibrated VU Meters Panel
              SkeuoPanel(
                material: PanelMaterial.aluminum,
                padding: const EdgeInsets.all(14),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'DUAL ANALOG TELEMETRY',
                          style: TextStyle(
                            fontSize: 10.0,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 2.0,
                            color: Color(0xFF2C3138),
                          ),
                        ),
                        Row(
                          children: [
                            LedIndicator(isOn: _auxPower, color: LedColor.green, size: 9, labelBelow: false),
                            const SizedBox(width: 8),
                            LedIndicator(isOn: _channelA > 75 || _channelB > 75, color: LedColor.red, size: 9, labelBelow: false),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: AnalogMeter(
                            value: _auxPower ? _channelA : 0.0,
                            label: 'CH-A',
                            unit: 'VU',
                            height: 110,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: AnalogMeter(
                            value: _auxPower ? _channelB : 0.0,
                            label: 'CH-B',
                            unit: 'VU',
                            height: 110,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // 2. Multi-Position Selector & Precision Knobs
              SkeuoPanel(
                material: PanelMaterial.gunmetal,
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'PRECISION FREQUENCY TUNING',
                      style: TextStyle(
                        fontSize: 10.0,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2.0,
                        color: Color(0xFFBAC3CE),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Knobs Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SkeuoKnob(
                          value: _frequency,
                          min: 10,
                          max: 100,
                          label: 'FREQ Hz',
                          unit: 'k',
                          size: 100,
                          onChanged: (val) {
                            setState(() {
                              _frequency = val;
                              _channelA = (_channelA + (val - _frequency) * 0.2).clamp(0.0, 100.0);
                            });
                          },
                        ),
                        SkeuoKnob(
                          value: _resonance,
                          min: 0,
                          max: 100,
                          label: 'RESONANCE',
                          size: 100,
                          onChanged: (val) {
                            setState(() {
                              _resonance = val;
                              _channelB = (_channelB + (val - _resonance) * 0.2).clamp(0.0, 100.0);
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Multi-Position Stepped Mode Selector Bar
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF101316),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: const Color(0xFF282C31), width: 1.0),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                      child: Column(
                        children: [
                          const Text(
                            'OPERATING RANGE SELECTOR',
                            style: TextStyle(
                              fontSize: 9.0,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.5,
                              color: Color(0xFF7A838E),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: List.generate(_modes.length, (idx) {
                              final isCurrent = _selectedMode == idx;
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedMode = idx;
                                    _channelA = (idx * 22.0).clamp(0.0, 100.0);
                                  });
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 120),
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    gradient: isCurrent
                                        ? const LinearGradient(
                                            colors: [Color(0xFFDFB660), Color(0xFF8A5D19)],
                                          )
                                        : const LinearGradient(
                                            colors: [Color(0xFF2E3339), Color(0xFF1B1E22)],
                                          ),
                                    border: Border.all(
                                      color: isCurrent ? SkeuoColors.brassHighlight : const Color(0xFF3E444C),
                                      width: 1.0,
                                    ),
                                    boxShadow: isCurrent
                                        ? const [
                                            BoxShadow(color: Color(0x66DFB660), blurRadius: 6),
                                          ]
                                        : null,
                                  ),
                                  child: Text(
                                    _modes[idx],
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w900,
                                      color: isCurrent ? const Color(0xFF1F1202) : const Color(0xFF8E97A2),
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // 3. Dual Channel Audio Mixing Faders
              SkeuoPanel(
                material: PanelMaterial.aluminum,
                padding: const EdgeInsets.all(14),
                child: Column(
                  children: [
                    SkeuoSlider(
                      value: _channelA,
                      label: 'BUS A GAIN',
                      length: 270,
                      onChanged: (v) => setState(() => _channelA = v),
                    ),
                    const SizedBox(height: 12),
                    SkeuoSlider(
                      value: _channelB,
                      label: 'BUS B GAIN',
                      length: 270,
                      onChanged: (v) => setState(() => _channelB = v),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // 4. Mechanical Rockers & Latch Interlocks
              SkeuoPanel(
                material: PanelMaterial.walnut,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'SAFETY INTERLOCKS & BREAKERS',
                      style: TextStyle(
                        fontSize: 10.0,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2.0,
                        color: Color(0xFFE8C88B),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Rocker Switch
                        MechanicalRocker(
                          value: _rockerState,
                          label: 'GENERATOR',
                          onChanged: (v) => setState(() => _rockerState = v),
                        ),

                        // Toggle Switch
                        SkeuoSwitch(
                          value: _auxPower,
                          label: 'AUX BUS',
                          ledColor: LedColor.amber,
                          onChanged: (v) => setState(() => _auxPower = v),
                        ),

                        // Heavy push button
                        SkeuoButton(
                          label: 'TRIP',
                          type: ButtonType.industrialRed,
                          width: 68,
                          height: 50,
                          onPressed: () {
                            setState(() {
                              _channelA = 0;
                              _channelB = 0;
                              _auxPower = false;
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: PhysicalCheckbox(
                        value: _generatorLock,
                        label: 'CIRCUIT BREAKER LOCKOUT',
                        onChanged: (v) => setState(() => _generatorLock = v),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
