import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../providers/analytics_provider.dart';
import '../../utils/sound_helper.dart';
import '../../widgets/common/engraved_plate.dart';
import '../../widgets/common/skeuo_panel.dart';
import '../../widgets/controls/analog_meter.dart';
import '../../widgets/controls/mechanical_rocker.dart';
import '../../widgets/controls/skeuo_button.dart';
import '../../widgets/controls/skeuo_knob.dart';
import '../../widgets/controls/skeuo_slider.dart';
import '../../widgets/controls/skeuo_switch.dart';

enum PlaygroundComponentType {
  rotaryKnob('Rotary Knob', 'Machined aluminum detented dial'),
  toggleSwitch('Toggle Switch', 'Solid bat handle toggle switch'),
  rockerSwitch('Rocker Switch', 'Dual-state illuminated rocker'),
  pushButton('Push Button', 'Tactile concave momentary button'),
  vuMeter('VU Meter', 'Ballistic backlit galvanometer'),
  sliderFader('Linear Fader', '100mm studio slide potentiometer');

  final String title;
  final String description;
  const PlaygroundComponentType(this.title, this.description);
}

class PlaygroundScreen extends StatefulWidget {
  const PlaygroundScreen({super.key});

  @override
  State<PlaygroundScreen> createState() => _PlaygroundScreenState();
}

class _PlaygroundScreenState extends State<PlaygroundScreen> {
  PlaygroundComponentType _activeType = PlaygroundComponentType.rotaryKnob;
  String _selectedMaterialId = 'aluminum';

  // Live component states
  double _knobValue = 45.0;
  bool _switchValue = true;
  bool _rockerValue = true;
  int _buttonPressCount = 0;
  final double _meterValue = 0.55;
  double _sliderValue = 0.70;

  int _selectedCodeTab = 0; // 0: Flutter, 1: CSS, 2: JSON
  bool _copied = false;

  @override
  Widget build(BuildContext context) {
    final analytics = context.read<AnalyticsProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFF140D08),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              const Center(
                child: EngravedPlate(
                  title: 'COMPONENT PLAYGROUND',
                  subtitle: 'Live Skeuomorphic Synthesizer & Code Exporter',
                  material: PlateMaterial.brass,
                  titleFontSize: 20,
                  subtitleFontSize: 9,
                  paddingVertical: 10,
                  paddingHorizontal: 24,
                ),
              ),
              const SizedBox(height: 14),

              // Component Type Selector
              SkeuoPanel(
                material: PanelMaterial.darkMetal,
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'INSTRUMENT COMPONENT CLASS',
                      style: TextStyle(
                        fontFamily: 'serif',
                        fontSize: 9.5,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.2,
                        color: Color(0xFFE2B450),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: PlaygroundComponentType.values.map((type) {
                        final isSelected = _activeType == type;
                        return GestureDetector(
                          onTap: () {
                            SoundHelper.playMechanicalClick();
                            setState(() => _activeType = type);
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 120),
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              gradient: isSelected
                                  ? const LinearGradient(
                                      colors: [Color(0xFFDFB660), Color(0xFF8A6218)],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    )
                                  : const LinearGradient(
                                      colors: [Color(0xFF282C33), Color(0xFF181B1F)],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ),
                              border: Border.all(
                                color: isSelected ? const Color(0xFFFFD573) : const Color(0xFF383E48),
                                width: 1.1,
                              ),
                            ),
                            child: Text(
                              type.title.toUpperCase(),
                              style: TextStyle(
                                fontFamily: 'serif',
                                fontSize: 8.5,
                                fontWeight: FontWeight.w900,
                                color: isSelected ? const Color(0xFF1F1202) : const Color(0xFFCBD5E1),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Interactive Testing Stage
              SkeuoPanel(
                material: _getPanelMaterial(),
                padding: const EdgeInsets.all(18),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            _activeType.description.toUpperCase(),
                            style: const TextStyle(
                              fontFamily: 'serif',
                              fontSize: 9.5,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.1,
                              color: Color(0xFFD4AF37),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0F172A),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: const Color(0xFF334155)),
                          ),
                          child: const Text(
                            'LIVE KINETIC STAGE',
                            style: TextStyle(fontFamily: 'monospace', fontSize: 8.5, color: Color(0xFF4ADE80)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Component Showcase Center
                    Container(
                      height: 170,
                      alignment: Alignment.center,
                      child: _buildActiveComponent(analytics),
                    ),
                    const SizedBox(height: 14),

                    // Live Telemetry Readout
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0A0E14),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: const Color(0xFF222B38)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              'STATE: ${_getStateString()}',
                              style: const TextStyle(fontFamily: 'monospace', fontSize: 9.5, color: Color(0xFF38BDF8)),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text('AUDIO: ON',
                              style: TextStyle(fontFamily: 'monospace', fontSize: 9, color: Color(0xFF94A3B8))),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Material Finish Substrate Selector
              SkeuoPanel(
                material: PanelMaterial.darkMetal,
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'CHASSIS FINISH SUBSTRATE',
                      style: TextStyle(
                        fontFamily: 'serif',
                        fontSize: 9.5,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.2,
                        color: Color(0xFFE2B450),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _buildMaterialChip('aluminum', 'ALUMINUM'),
                        const SizedBox(width: 8),
                        _buildMaterialChip('brass', 'BRASS'),
                        const SizedBox(width: 8),
                        _buildMaterialChip('bakelite', 'BAKELITE'),
                        const SizedBox(width: 8),
                        _buildMaterialChip('walnut', 'WALNUT'),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Multi-Tab Code Generation Artifact
              SkeuoPanel(
                material: PanelMaterial.darkMetal,
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Code Tab Switchers
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                _buildCodeTab(0, 'FLUTTER'),
                                const SizedBox(width: 6),
                                _buildCodeTab(1, 'CSS'),
                                const SizedBox(width: 6),
                                _buildCodeTab(2, 'JSON'),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        SkeuoButton(
                          label: _copied ? 'COPIED!' : 'COPY',
                          size: SkeuoButtonSize.small,
                          onPressed: () {
                            SoundHelper.playMechanicalClick();
                            Clipboard.setData(ClipboardData(text: _generateActiveCode()));
                            setState(() => _copied = true);
                            Future.delayed(const Duration(seconds: 2), () {
                              if (mounted) setState(() => _copied = false);
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF070B0E),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: const Color(0xFF1E293B)),
                      ),
                      child: SelectableText(
                        _generateActiveCode(),
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 9.5,
                          height: 1.45,
                          color: Color(0xFF38BDF8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActiveComponent(AnalyticsProvider analytics) {
    switch (_activeType) {
      case PlaygroundComponentType.rotaryKnob:
        return SkeuoKnob(
          value: _knobValue,
          min: 0,
          max: 100,
          label: 'CALIBRATION GAIN',
          onChanged: (v) {
            setState(() => _knobValue = v);
            analytics.trackInteraction('KNOB_CALIBRATE');
          },
        );
      case PlaygroundComponentType.toggleSwitch:
        return SkeuoSwitch(
          value: _switchValue,
          label: 'MAIN BUS VOLTAGE',
          onChanged: (v) {
            setState(() => _switchValue = v);
            analytics.trackInteraction('SWITCH_THROW');
          },
        );
      case PlaygroundComponentType.rockerSwitch:
        return MechanicalRocker(
          value: _rockerValue,
          label: 'CIRCUIT INTERLOCK',
          onChanged: (v) {
            setState(() => _rockerValue = v);
            analytics.trackInteraction('ROCKER_FLIP');
          },
        );
      case PlaygroundComponentType.pushButton:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SkeuoButton(
              label: 'ACTUATE PULSE',
              size: SkeuoButtonSize.large,
              onPressed: () {
                setState(() => _buttonPressCount++);
                analytics.trackInteraction('BUTTON_ACTUATE');
              },
            ),
            const SizedBox(height: 8),
            Text('CYCLES: $_buttonPressCount', style: const TextStyle(fontFamily: 'monospace', fontSize: 9, color: Color(0xFF94A3B8))),
          ],
        );
      case PlaygroundComponentType.vuMeter:
        return AnalogMeter(
          value: _meterValue,
          label: 'SIGNAL dBm',
          min: -20,
          max: 3,
        );
      case PlaygroundComponentType.sliderFader:
        return SizedBox(
          width: 260,
          child: SkeuoSlider(
            value: _sliderValue,
            min: 0.0,
            max: 1.0,
            onChanged: (v) {
              setState(() => _sliderValue = v);
              analytics.trackInteraction('FADER_SLIDE');
            },
          ),
        );
    }
  }

  String _getStateString() {
    switch (_activeType) {
      case PlaygroundComponentType.rotaryKnob:
        return '${_knobValue.toStringAsFixed(1)} dB';
      case PlaygroundComponentType.toggleSwitch:
        return _switchValue ? 'CLOSED (250V)' : 'OPEN';
      case PlaygroundComponentType.rockerSwitch:
        return _rockerValue ? 'ENGAGED' : 'STANDBY';
      case PlaygroundComponentType.pushButton:
        return 'READY ($_buttonPressCount ACTUATIONS)';
      case PlaygroundComponentType.vuMeter:
        return '${(_meterValue * 23 - 20).toStringAsFixed(1)} dB';
      case PlaygroundComponentType.sliderFader:
        return '${(_sliderValue * 100).toStringAsFixed(0)}%';
    }
  }

  PanelMaterial _getPanelMaterial() {
    switch (_selectedMaterialId) {
      case 'brass':
        return PanelMaterial.brass;
      case 'aluminum':
        return PanelMaterial.aluminum;
      case 'bakelite':
        return PanelMaterial.darkMetal;
      case 'walnut':
      default:
        return PanelMaterial.walnut;
    }
  }

  Widget _buildMaterialChip(String id, String label) {
    final isSelected = _selectedMaterialId == id;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          SoundHelper.playMechanicalClick();
          setState(() => _selectedMaterialId = id);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          padding: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: isSelected ? const Color(0xFFDFB660) : const Color(0xFF1E232A),
            border: Border.all(
              color: isSelected ? const Color(0xFFFFD573) : const Color(0xFF333B47),
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontFamily: 'serif',
                fontSize: 8,
                fontWeight: FontWeight.w900,
                color: isSelected ? const Color(0xFF1F1202) : const Color(0xFFA1A1AA),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCodeTab(int index, String label) {
    final isSelected = _selectedCodeTab == index;
    return GestureDetector(
      onTap: () {
        SoundHelper.playMechanicalClick();
        setState(() => _selectedCodeTab = index);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: isSelected ? const Color(0xFF222B38) : Colors.transparent,
          border: Border.all(
            color: isSelected ? const Color(0xFF38BDF8) : Colors.transparent,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'serif',
            fontSize: 8.5,
            fontWeight: FontWeight.w900,
            color: isSelected ? const Color(0xFF38BDF8) : const Color(0xFF64748B),
          ),
        ),
      ),
    );
  }

  String _generateActiveCode() {
    if (_selectedCodeTab == 0) {
      // Flutter Dart
      switch (_activeType) {
        case PlaygroundComponentType.rotaryKnob:
          return '''// Skeuomorphic Knurled Rotary Potentiometer
SkeuoKnob(
  value: $_knobValue,
  min: 0,
  max: 100,
  label: "CALIBRATION GAIN",
  onChanged: (double val) => setState(() => gain = val),
)''';
        case PlaygroundComponentType.toggleSwitch:
          return '''// Heavy Industrial Bat-Handle Toggle Switch
SkeuoSwitch(
  value: $_switchValue,
  label: "MAIN BUS VOLTAGE",
  onChanged: (bool state) => setState(() => isPowered = state),
)''';
        case PlaygroundComponentType.rockerSwitch:
          return '''// Dual-State Concave Illuminated Rocker
MechanicalRocker(
  value: $_rockerValue,
  label: "CIRCUIT INTERLOCK",
  onChanged: (bool active) => setState(() => isInterlocked = active),
)''';
        case PlaygroundComponentType.pushButton:
          return '''// Tactile Concave Momentary Pushbutton
SkeuoButton(
  label: "ACTUATE PULSE",
  size: SkeuoButtonSize.large,
  onPressed: () => triggerSkeuoPulse(),
)''';
        case PlaygroundComponentType.vuMeter:
          return '''// Ballistic Damped Analog Galvanometer VU Meter
AnalogMeter(
  value: $_meterValue,
  min: -20,
  max: 3,
  label: "SIGNAL dBm",
)''';
        case PlaygroundComponentType.sliderFader:
          return '''// 100mm Studio Slide Potentiometer
SkeuoSlider(
  value: $_sliderValue,
  min: 0.0,
  max: 1.0,
  onChanged: (double fader) => setState(() => mix = fader),
)''';
      }
    } else if (_selectedCodeTab == 1) {
      // CSS
      return '''/* Skeuomorphic ${_activeType.title} Chassis Styling */
.skeuo-${_activeType.name.toLowerCase()} {
  background: linear-gradient(180deg, #FFFFFF 0%, #D1D5DB 30%, #9CA3AF 70%, #4B5563 100%);
  border: 1.5px solid rgba(255, 255, 255, 0.7);
  box-shadow: 
    inset 0 1px 2px rgba(255, 255, 255, 0.9),
    inset 0 -2px 3px rgba(0, 0, 0, 0.6),
    0 8px 16px rgba(0, 0, 0, 0.5);
  border-radius: 8px;
  cursor: pointer;
  transition: transform 120ms cubic-bezier(0.175, 0.885, 0.32, 1.275);
}
.skeuo-${_activeType.name.toLowerCase()}:active {
  transform: translateY(2px);
  box-shadow: inset 0 2px 5px rgba(0, 0, 0, 0.8);
}''';
    } else {
      // JSON
      return '''{
  "component": "${_activeType.name}",
  "title": "${_activeType.title}",
  "material": "$_selectedMaterialId",
  "tactileFeedback": {
    "sound": "mechanical_click",
    "springDamping": 0.85,
    "throwDegrees": 45
  },
  "calibration": {
    "initial": ${_activeType == PlaygroundComponentType.rotaryKnob ? _knobValue : _sliderValue},
    "state": "$_switchValue"
  }
}''';
    }
  }
}
