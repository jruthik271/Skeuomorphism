import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/network/api_client.dart';
import '../../providers/auth_provider.dart';
import '../../utils/sound_helper.dart';
import '../../widgets/common/engraved_plate.dart';
import '../../widgets/common/skeuo_panel.dart';
import '../../widgets/controls/skeuo_button.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final ApiClient _api = ApiClient();
  bool _isReseeding = false;
  String? _reseedStatus;

  Future<void> _handleReseed() async {
    SoundHelper.playMechanicalClick();
    setState(() {
      _isReseeding = true;
      _reseedStatus = 'Recalibrating factory database instruments...';
    });

    final success = await _api.reseedDatabase();
    SoundHelper.playToggleSwitch();

    setState(() {
      _isReseeding = false;
      _reseedStatus = success
          ? 'Factory presets calibrated successfully.'
          : 'Local mode active: Presets loaded into RAM.';
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final isAdmin = auth.isAdmin;

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
                  title: 'ADMIN INSTRUMENT CONSOLE',
                  subtitle: 'Chief Engineer Privileged Mainframe Controls',
                  material: PlateMaterial.brass,
                  titleFontSize: 19,
                  subtitleFontSize: 9,
                  paddingVertical: 10,
                  paddingHorizontal: 20,
                ),
              ),
              const SizedBox(height: 14),

              if (!isAdmin) ...[
                // Access Restricted Notice
                SkeuoPanel(
                  material: PanelMaterial.darkMetal,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const Icon(Icons.lock_clock, size: 40, color: Color(0xFFEF4444)),
                      const SizedBox(height: 10),
                      const Text(
                        'CLEARANCE LEVEL RESTRICTED',
                        style: TextStyle(
                          fontFamily: 'serif',
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFFFCA5A5),
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'This instrument terminal requires "ADMIN" clearance. Please authenticate via Operator Clearance using the Admin Key.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 10, color: Color(0xFF94A3B8)),
                      ),
                    ],
                  ),
                ),
              ] else ...[
                // Factory Recalibration Panel
                SkeuoPanel(
                  material: PanelMaterial.walnut,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'FACTORY CALIBRATION & RE-SEED',
                        style: TextStyle(
                          fontFamily: 'serif',
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.2,
                          color: Color(0xFFD4AF37),
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Restores all default skeuomorphic materials, components, and default operator accounts to factory specifications.',
                        style: TextStyle(fontSize: 9.5, color: Color(0xFFCBD5E1), height: 1.3),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          SkeuoButton(
                            label: _isReseeding ? 'CALIBRATING...' : 'RESET TO FACTORY PRESETS',
                            size: SkeuoButtonSize.medium,
                            onPressed: _isReseeding ? () {} : _handleReseed,
                          ),
                        ],
                      ),
                      if (_reseedStatus != null) ...[
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0F172A),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: const Color(0xFF334155)),
                          ),
                          child: Text(
                            _reseedStatus!,
                            style: const TextStyle(fontFamily: 'monospace', fontSize: 9.5, color: Color(0xFF4ADE80)),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // Registered Operators Table
                SkeuoPanel(
                  material: PanelMaterial.darkMetal,
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'REGISTERED OPERATOR MANIFEST',
                        style: TextStyle(
                          fontFamily: 'serif',
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.1,
                          color: Color(0xFFE2B450),
                        ),
                      ),
                      const SizedBox(height: 10),
                      _buildOperatorRow('Chief Instrument Engineer', 'admin@skeuolab.com', 'ADMIN', true),
                      const Divider(color: Color(0xFF334155), height: 14),
                      _buildOperatorRow('Apprentice Operator', 'user@skeuolab.com', 'USER', true),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // Server Health Telemetry
                SkeuoPanel(
                  material: PanelMaterial.aluminum,
                  padding: const EdgeInsets.all(14),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'SYSTEM DIAGNOSTICS REPORT',
                        style: TextStyle(
                          fontFamily: 'serif',
                          fontSize: 9.5,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      SizedBox(height: 8),
                      Text('• BACKEND REST API: http://localhost:5000/api', style: TextStyle(fontFamily: 'monospace', fontSize: 9, color: Color(0xFF334155))),
                      Text('• CORS SECURITY: Active (All Origins Enabled)', style: TextStyle(fontFamily: 'monospace', fontSize: 9, color: Color(0xFF334155))),
                      Text('• AUTHENTICATION: JWT Bearer Token (HMAC-SHA256)', style: TextStyle(fontFamily: 'monospace', fontSize: 9, color: Color(0xFF334155))),
                      Text('• KINETIC AUDIO: Web Audio API Oscillator Matrix', style: TextStyle(fontFamily: 'monospace', fontSize: 9, color: Color(0xFF334155))),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOperatorRow(String name, String email, String role, bool isActive) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10.5, color: Colors.white)),
            Text(email, style: const TextStyle(fontSize: 8.5, color: Color(0xFF94A3B8))),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: role == 'ADMIN' ? const Color(0xFF7C2D12) : const Color(0xFF1E293B),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: role == 'ADMIN' ? const Color(0xFFF97316) : const Color(0xFF38BDF8),
            ),
          ),
          child: Text(
            role,
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 8,
              fontWeight: FontWeight.bold,
              color: role == 'ADMIN' ? const Color(0xFFFED7AA) : const Color(0xFFBAE6FD),
            ),
          ),
        ),
      ],
    );
  }
}
