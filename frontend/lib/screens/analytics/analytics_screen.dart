import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/analytics_provider.dart';
import '../../utils/sound_helper.dart';
import '../../widgets/common/engraved_plate.dart';
import '../../widgets/common/skeuo_panel.dart';
import '../../widgets/controls/analog_meter.dart';
import '../../widgets/controls/skeuo_button.dart';
import '../../widgets/controls/skeuo_switch.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  Timer? _decayTimer;
  final List<String> _crtLogs = [
    '[00:00:01] MAINFRAME INITIATION // OSCILLATOR LOCK: OK',
    '[00:00:03] BUS VOLTAGE STABILIZED AT 120.4 VAC',
    '[00:00:06] KINETIC DETENTS CALIBRATED ON ALL ROTARIES',
    '[00:00:12] REST API TELEMETRY GATEWAY ONLINE',
  ];

  @override
  void initState() {
    super.initState();
    // Decay VU meter ballistics smoothly
    _decayTimer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      if (mounted) {
        context.read<AnalyticsProvider>().decayVuMeter();
      }
    });

    // Fetch fresh metrics from backend
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AnalyticsProvider>().fetchAdminMetrics();
    });
  }

  @override
  void dispose() {
    _decayTimer?.cancel();
    super.dispose();
  }

  void _triggerDiagnosticPulse(AnalyticsProvider analytics) {
    SoundHelper.playMechanicalClick();
    analytics.trackInteraction('DIAGNOSTIC_PULSE');
    setState(() {
      final now = DateTime.now();
      final timeStr = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';
      _crtLogs.add('[$timeStr] KINETIC PULSE TRIGGERED // LINE VOLTAGE: ${analytics.systemVoltage.toStringAsFixed(1)}V');
      if (_crtLogs.length > 8) _crtLogs.removeAt(0);
    });
  }

  @override
  Widget build(BuildContext context) {
    final analytics = context.watch<AnalyticsProvider>();
    final metrics = analytics.adminMetrics;

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
                  title: 'CENTRAL TELEMETRY',
                  subtitle: 'Mainframe CRT & Analog Instrumentation',
                  material: PlateMaterial.brass,
                  titleFontSize: 20,
                  subtitleFontSize: 9,
                  paddingVertical: 10,
                  paddingHorizontal: 24,
                ),
              ),
              const SizedBox(height: 14),

              // Dual Analog Meters Section
              SkeuoPanel(
                material: PanelMaterial.walnut,
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'BALLISTIC METROLOGY',
                          style: TextStyle(
                            fontFamily: 'serif',
                            fontSize: 9.5,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.2,
                            color: Color(0xFFD4AF37),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0F172A),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: const Color(0xFF334155)),
                          ),
                          child: Text(
                            'VOLTAGE: ${analytics.systemVoltage.toStringAsFixed(1)} V',
                            style: const TextStyle(fontFamily: 'monospace', fontSize: 9.5, color: Color(0xFF4ADE80)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: AnalogMeter(
                            value: analytics.vuMeterLevel,
                            min: -20,
                            max: 3,
                            label: 'KINETIC SIGNAL dB',
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: AnalogMeter(
                            value: (analytics.systemVoltage - 110) / 20.0,
                            min: 110,
                            max: 130,
                            label: 'BUS LINE VOLTS',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SkeuoButton(
                          label: 'FIRE KINETIC PULSE',
                          size: SkeuoButtonSize.medium,
                          onPressed: () => _triggerDiagnosticPulse(analytics),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Phosphor CRT Terminal Display (Iconic Scanline Monitor)
              SkeuoPanel(
                material: PanelMaterial.darkMetal,
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.terminal, size: 14, color: Color(0xFF4ADE80)),
                            SizedBox(width: 6),
                            Text(
                              'P31 GREEN PHOSPHOR CRT',
                              style: TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 9.5,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.1,
                                color: Color(0xFF4ADE80),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFF4ADE80),
                            boxShadow: [
                              BoxShadow(color: Color(0xFF4ADE80), blurRadius: 6, spreadRadius: 1),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Curved CRT Screen Container with Scanlines
                    Container(
                      height: 150,
                      decoration: BoxDecoration(
                        color: const Color(0xFF03140C),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFF064E3B), width: 3),
                        boxShadow: const [
                          BoxShadow(color: Color(0x664ADE80), blurRadius: 12, spreadRadius: 1),
                          BoxShadow(color: Color(0xFF000000), offset: Offset(0, 4), blurRadius: 8),
                        ],
                      ),
                      child: Stack(
                        children: [
                          // Scanlines Painter Overlay
                          CustomPaint(
                            size: const Size(double.infinity, 150),
                            painter: _CrtScanlinesPainter(),
                          ),

                          // Text Log Feed
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: ListView.builder(
                              itemCount: _crtLogs.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 4),
                                  child: Text(
                                    _crtLogs[index],
                                    style: const TextStyle(
                                      fontFamily: 'monospace',
                                      fontSize: 9.0,
                                      color: Color(0xFF4ADE80),
                                      shadows: [
                                        Shadow(color: Color(0x994ADE80), blurRadius: 4),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Machine Telemetry Stats Grid
              SkeuoPanel(
                material: PanelMaterial.aluminum,
                padding: const EdgeInsets.all(14),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatDial('TOTAL PULSES', '${analytics.localInteractionCount}'),
                        _buildStatDial('ACTIVE USERS', '${metrics.activeUsers}'),
                        _buildStatDial('UPTIME', '${metrics.uptimeHours.toStringAsFixed(1)}h'),
                        _buildStatDial('CPU LOAD', metrics.cpuLoad),
                      ],
                    ),
                    const Divider(color: Color(0xFF4B5563), height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'SYNTHESIZER SOUND CLICKS',
                          style: TextStyle(fontFamily: 'serif', fontSize: 9.5, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                        ),
                        SkeuoSwitch(
                          value: analytics.audioEffectsEnabled,
                          label: 'WEB AUDIO',
                          onChanged: (v) => analytics.toggleAudioEffects(v),
                        ),
                      ],
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

  Widget _buildStatDial(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'monospace',
            fontSize: 16,
            fontWeight: FontWeight.w900,
            color: Color(0xFF1E293B),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'serif',
            fontSize: 7.5,
            fontWeight: FontWeight.bold,
            color: Color(0xFF475569),
          ),
        ),
      ],
    );
  }
}

class _CrtScanlinesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = const Color(0x224ADE80)
      ..strokeWidth = 1.0;

    for (double y = 0; y < size.height; y += 3) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), linePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
