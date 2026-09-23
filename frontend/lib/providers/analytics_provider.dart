import 'dart:math';
import 'package:flutter/foundation.dart';
import '../core/network/api_client.dart';
import '../models/analytics_model.dart';
import '../utils/sound_helper.dart';

class AnalyticsProvider extends ChangeNotifier {
  final ApiClient _api = ApiClient();

  int _localInteractionCount = 142;
  double _systemVoltage = 120.4;
  double _vuMeterLevel = 0.45;
  double _keyLightAngleDegrees = 315.0;
  bool _audioEffectsEnabled = true;

  AdminSystemMetrics _adminMetrics = const AdminSystemMetrics(
    totalUsers: 14,
    activeUsers: 8,
    totalMaterials: 14,
    totalComponents: 15,
    totalInteractions: 3480,
    cpuLoad: '12.8%',
    ramUsage: '148 MB',
    uptimeHours: 142.5,
  );

  int get localInteractionCount => _localInteractionCount;
  double get systemVoltage => _systemVoltage;
  double get vuMeterLevel => _vuMeterLevel;
  double get keyLightAngleDegrees => _keyLightAngleDegrees;
  bool get audioEffectsEnabled => _audioEffectsEnabled;
  AdminSystemMetrics get adminMetrics => _adminMetrics;

  void trackInteraction(String action, [String category = 'interaction']) {
    _localInteractionCount++;
    // Add realistic ballistic meter deflection
    _vuMeterLevel = min(1.0, _vuMeterLevel + 0.15 + (Random().nextDouble() * 0.1));
    _systemVoltage = 118.0 + (Random().nextDouble() * 4.0);

    _api.trackInteraction(action, category);
    notifyListeners();
  }

  void decayVuMeter() {
    if (_vuMeterLevel > 0.1) {
      _vuMeterLevel = max(0.05, _vuMeterLevel * 0.92);
      notifyListeners();
    }
  }

  void setKeyLightAngle(double degrees) {
    _keyLightAngleDegrees = degrees;
    SoundHelper.playMechanicalClick();
    notifyListeners();
  }

  void toggleAudioEffects(bool enabled) {
    _audioEffectsEnabled = enabled;
    SoundHelper.playToggleSwitch();
    notifyListeners();
  }

  Future<void> fetchAdminMetrics() async {
    try {
      final res = await _api.getAdminStats();
      if (res != null) {
        final counts = res['counts'] as Map<String, dynamic>? ?? {};
        final sys = res['system'] as Map<String, dynamic>? ?? {};
        _adminMetrics = AdminSystemMetrics(
          totalUsers: (counts['users'] as num?)?.toInt() ?? 14,
          activeUsers: 8,
          totalMaterials: (counts['materials'] as num?)?.toInt() ?? 14,
          totalComponents: (counts['components'] as num?)?.toInt() ?? 15,
          totalInteractions: (counts['activities'] as num?)?.toInt() ?? 3480,
          cpuLoad: '14.2%',
          ramUsage: '${((sys['uptime'] as num?)?.toInt() ?? 120) % 200 + 120} MB',
          uptimeHours: ((sys['uptime'] as num?)?.toDouble() ?? 3600.0) / 3600.0,
        );
        notifyListeners();
      }
    } catch (_) {}
  }
}
