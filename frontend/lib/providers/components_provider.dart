import 'package:flutter/foundation.dart';
import '../models/component_model.dart';
import '../core/network/api_client.dart';
import '../utils/sound_helper.dart';

class ComponentsProvider extends ChangeNotifier {
  final ApiClient _api = ApiClient();

  final List<ComponentModel> _components = [
    const ComponentModel(
      id: 'rotary_knob',
      name: 'Heavy Knurled Rotary Dial',
      category: 'controls',
      description: 'Solid machined aluminum rotary potentiometer with continuous rotation, pointer notch, and radial specular highlights.',
      technique: 'Multi-layer Radial Conic Gradients & Pointer Rotation Matrix',
      configuration: {'min': 0, 'max': 100, 'step': 1, 'default': 45},
      material: 'aluminum',
      animationCurve: 'easeOutBack',
      flutterCode: 'SkeuoKnob(value: gain, onChanged: (v) => setGain(v), min: 0, max: 100, label: "GAIN dB")',
      interactionsCount: 1420,
    ),
    const ComponentModel(
      id: 'toggle_switch',
      name: 'Industrial Heavy Toggle Switch',
      category: 'controls',
      description: 'Solid bat-handle toggle with stamped metal bezel, mechanical throw resistance, and spring-snap return physics.',
      technique: 'Perspective 3D Shadow Projection & Spring Damping',
      configuration: {'state': 'ON', 'voltage': '250V AC'},
      material: 'brass',
      animationCurve: 'elasticOut',
      flutterCode: 'SkeuoSwitch(value: isPowered, onChanged: (v) => togglePower(v), label: "MASTER POWER")',
      interactionsCount: 2180,
    ),
    const ComponentModel(
      id: 'rocker_switch',
      name: 'Dual-State Illuminated Rocker',
      category: 'controls',
      description: 'Concave split rocker switch with internally illuminated neon lamp and bi-planar surface bevels.',
      technique: 'Bi-planar Linear Gradient Shift & Inset Bevel Shadow',
      configuration: {'illuminated': true, 'lampColor': 'Amber'},
      material: 'bakelite',
      animationCurve: 'easeInOutCubic',
      flutterCode: 'MechanicalRocker(value: isEngaged, onChanged: (v) => setEngaged(v), label: "STANDBY")',
      interactionsCount: 970,
    ),
    const ComponentModel(
      id: 'push_button',
      name: 'Tactile Concave Push Button',
      category: 'controls',
      description: 'Recessed momentary pushbutton with finger dish, deep mechanical travel, and microswitch snap.',
      technique: 'Bevel Inversion & Box-Shadow Compression on PointerDown',
      configuration: {'momentary': false, 'clickSound': 'mechanical'},
      material: 'bakelite',
      animationCurve: 'easeOutExpo',
      flutterCode: 'SkeuoButton(label: "TEST RUN", onPressed: () => runDiagnostics())',
      interactionsCount: 1840,
    ),
    const ComponentModel(
      id: 'slide_potentiometer',
      name: 'Studio Slide Potentiometer',
      category: 'controls',
      description: '100mm linear fader with grooved slider cap, engraved decibel scale, and inset track shadow.',
      technique: 'Compound Inset Groove Shadow & Milled Thumb Cap',
      configuration: {'travelMm': 100, 'detentCenter': true},
      material: 'aluminum',
      animationCurve: 'easeOut',
      flutterCode: 'SkeuoSlider(value: mixRatio, min: 0.0, max: 1.0, onChanged: (v) => setMix(v))',
      interactionsCount: 1620,
    ),
    const ComponentModel(
      id: 'vu_meter',
      name: 'Ballistic Analog VU Meter',
      category: 'displays',
      description: 'Warm incandescent backlit galvanometer with parabolic decibel scale and damped ballistic needle physics.',
      technique: 'CustomPainter Needle Canvas with Damped Oscillation',
      configuration: {'minDb': -20, 'maxDb': 3, 'peakHold': true},
      material: 'bakelite',
      animationCurve: 'easeOutQuad',
      flutterCode: 'AnalogMeter(value: audioSignal, label: "AUDIO dB", min: -20, max: 3)',
      interactionsCount: 3100,
    ),
    const ComponentModel(
      id: 'lcd_display',
      name: 'Vintage Segment LCD Display',
      category: 'displays',
      description: 'Diffuse liquid crystal matrix with faint ghost unlit segments, etched glass bezel, and polarization glare.',
      technique: 'Segment Bitmask Rendering & Ambient Occlusion Filter',
      configuration: {'digitCount': 8, 'backlit': true},
      material: 'glass',
      animationCurve: 'linear',
      flutterCode: 'LcdDisplay(text: "142.85 MHz", label: "CARRIER FREQ")',
      interactionsCount: 2450,
    ),
    const ComponentModel(
      id: 'radio_dial',
      name: 'Backlit Analog Tuning Dial',
      category: 'displays',
      description: 'Horizontal frequency band dial with physical brass pointer needle, broadcast markers, and warm backlight.',
      technique: 'Linear Calibrated Ruler & Smooth Inertial Dragger',
      configuration: {'minMhz': 88.0, 'maxMhz': 108.0, 'band': 'FM'},
      material: 'glass',
      animationCurve: 'easeOut',
      flutterCode: 'RadioDial(frequency: currentFreq, onChanged: (f) => setFreq(f))',
      interactionsCount: 1980,
    ),
    const ComponentModel(
      id: 'rangefinder_camera',
      name: 'Mechanical Rangefinder Camera',
      category: 'composite',
      description: 'Full interactive 35mm rangefinder with knurled aperture ring, shutter cocking, optical viewfinder, and mechanical shutter release.',
      technique: 'Multi-layer Composite Machine with State Machine Logic',
      configuration: {'filmIso': 400, 'aperture': 'f/2.8', 'shutter': '1/250s'},
      material: 'aluminum',
      animationCurve: 'elasticOut',
      flutterCode: 'SkeuoCamera(onShutter: () => takeExposure())',
      interactionsCount: 4200,
    ),
    const ComponentModel(
      id: 'vintage_player',
      name: 'Reel-to-Reel Audio Master Console',
      category: 'composite',
      description: 'Professional 1/4-inch tape deck with spinning magnetic tape reels, illuminated transport keys, and dual VU meters.',
      technique: 'Continuous Physics Tape Tension & Reel Acceleration',
      configuration: {'speedIps': 15, 'heads': '3-Head Master'},
      material: 'aluminum',
      animationCurve: 'linear',
      flutterCode: 'VintagePlayer(isPlaying: isPlayingTape, onPlayToggle: () => toggleTape())',
      interactionsCount: 5100,
    ),
    const ComponentModel(
      id: 'laboratory_notebook',
      name: 'Stitched Leather Laboratory Log',
      category: 'composite',
      description: 'Embossed leather-bound scientific journal with brass corners, tactile ribbon bookmark, and realistic page turns.',
      technique: 'Skeuomorphic Leather Grain, Page Curl Shadow, and Paper Texture',
      configuration: {'pages': 12, 'binding': 'Hand-stitched Saddle'},
      material: 'organics',
      animationCurve: 'easeInOutQuad',
      flutterCode: 'SkeuoNotebook(entries: operatorNotes, onAddEntry: (e) => saveNote(e))',
      interactionsCount: 2310,
    ),
  ];

  String _selectedCategory = 'all';
  String _searchQuery = '';
  ComponentModel? _activeComponent;

  List<ComponentModel> get components {
    return _components.where((c) {
      final matchesCategory = _selectedCategory == 'all' || c.category == _selectedCategory;
      final matchesSearch = _searchQuery.isEmpty ||
          c.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          c.description.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          c.technique.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  ComponentModel get activeComponent => _activeComponent ?? _components.first;
  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;

  void selectCategory(String category) {
    _selectedCategory = category;
    SoundHelper.playMechanicalClick();
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void selectComponent(ComponentModel component) {
    _activeComponent = component;
    SoundHelper.playMechanicalClick();
    _api.trackInteraction('COMPONENT_INSPECT', 'interaction', {'componentId': component.id, 'name': component.name});
    notifyListeners();
  }

  void recordInteraction(String componentId) {
    SoundHelper.playMechanicalClick();
    _api.trackInteraction('KINETIC_ENGAGEMENT', 'interaction', {'componentId': componentId});
  }
}
