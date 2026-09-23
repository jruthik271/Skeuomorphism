import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../utils/sound_helper.dart';
import '../../widgets/common/engraved_plate.dart';
import '../../widgets/common/skeuo_panel.dart';
import '../../widgets/controls/skeuo_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isRegisterMode = false;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController(text: 'admin@skeuolab.com');
  final TextEditingController _passwordController = TextEditingController(text: 'AdminPass123!');

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _loadPreset(String email, String pass) {
    SoundHelper.playMechanicalClick();
    setState(() {
      _emailController.text = email;
      _passwordController.text = pass;
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.user;

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
                  title: 'OPERATOR CLEARANCE',
                  subtitle: 'Central Machine Access & Authentication',
                  material: PlateMaterial.brass,
                  titleFontSize: 20,
                  subtitleFontSize: 9,
                  paddingVertical: 10,
                  paddingHorizontal: 24,
                ),
              ),
              const SizedBox(height: 14),

              if (auth.isAuthenticated && user != null) ...[
                // Authenticated Operator Badge Card
                SkeuoPanel(
                  material: PanelMaterial.walnut,
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: const Color(0xFFDFB660), width: 2),
                              boxShadow: const [
                                BoxShadow(color: Color(0x99000000), offset: Offset(0, 3), blurRadius: 6),
                              ],
                              image: user.avatar != null
                                  ? DecorationImage(image: NetworkImage(user.avatar!), fit: BoxFit.cover)
                                  : null,
                            ),
                            child: user.avatar == null
                                ? const Icon(Icons.person, color: Color(0xFFDFB660), size: 28)
                                : null,
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user.name.toUpperCase(),
                                  style: const TextStyle(
                                    fontFamily: 'serif',
                                    fontSize: 13,
                                    fontWeight: FontWeight.w900,
                                    color: Color(0xFFE2B450),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  user.email,
                                  style: const TextStyle(fontSize: 10, color: Color(0xFF94A3B8)),
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: user.isAdmin ? const Color(0xFF7C2D12) : const Color(0xFF1E293B),
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(
                                      color: user.isAdmin ? const Color(0xFFF97316) : const Color(0xFF38BDF8),
                                    ),
                                  ),
                                  child: Text(
                                    'CLEARANCE LEVEL: ${user.role}',
                                    style: TextStyle(
                                      fontFamily: 'monospace',
                                      fontSize: 8.5,
                                      fontWeight: FontWeight.bold,
                                      color: user.isAdmin ? const Color(0xFFFED7AA) : const Color(0xFFBAE6FD),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Divider(color: Color(0xFF4A3423), height: 28),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStatColumn('INTERACTIONS', '${user.interactions}'),
                          _buildStatColumn('SAVED PARTS', '${user.savedComponents}'),
                          _buildStatColumn('DRAWERS', '${user.collectionsCount}'),
                        ],
                      ),
                      const SizedBox(height: 18),
                      SkeuoButton(
                        label: 'LOCK MACHINE / LOGOUT',
                        size: SkeuoButtonSize.medium,
                        onPressed: () => auth.logout(),
                      ),
                    ],
                  ),
                ),
              ] else ...[
                // Passkey Tumbler Panel
                SkeuoPanel(
                  material: PanelMaterial.walnut,
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _isRegisterMode ? 'COMMISSION OPERATOR' : 'UNLOCK CONSOLE',
                            style: const TextStyle(
                              fontFamily: 'serif',
                              fontSize: 11,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.2,
                              color: Color(0xFFDFB660),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              SoundHelper.playToggleSwitch();
                              setState(() => _isRegisterMode = !_isRegisterMode);
                            },
                            child: Text(
                              _isRegisterMode ? 'SWITCH TO LOGIN' : 'NEW OPERATOR?',
                              style: const TextStyle(
                                fontFamily: 'serif',
                                fontSize: 9.5,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF38BDF8),
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      if (_isRegisterMode) ...[
                        TextField(
                          controller: _nameController,
                          style: const TextStyle(color: Colors.white, fontSize: 13),
                          decoration: InputDecoration(
                            labelText: 'OPERATOR CALLSIGN / NAME',
                            labelStyle: const TextStyle(color: Color(0xFFDFB660), fontSize: 10, fontFamily: 'serif'),
                            filled: true,
                            fillColor: const Color(0xFF0F0B08),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: Color(0xFF4A3423))),
                            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: Color(0xFFDFB660))),
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],

                      TextField(
                        controller: _emailController,
                        style: const TextStyle(color: Colors.white, fontSize: 13),
                        decoration: InputDecoration(
                          labelText: 'OPERATOR IDENTIFIER (EMAIL)',
                          labelStyle: const TextStyle(color: Color(0xFFDFB660), fontSize: 10, fontFamily: 'serif'),
                          filled: true,
                          fillColor: const Color(0xFF0F0B08),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: Color(0xFF4A3423))),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: Color(0xFFDFB660))),
                        ),
                      ),
                      const SizedBox(height: 12),

                      TextField(
                        controller: _passwordController,
                        obscureText: true,
                        style: const TextStyle(color: Colors.white, fontSize: 13),
                        decoration: InputDecoration(
                          labelText: 'SECURITY PASSKEY',
                          labelStyle: const TextStyle(color: Color(0xFFDFB660), fontSize: 10, fontFamily: 'serif'),
                          filled: true,
                          fillColor: const Color(0xFF0F0B08),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: Color(0xFF4A3423))),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: Color(0xFFDFB660))),
                        ),
                      ),
                      const SizedBox(height: 14),

                      if (auth.errorMessage != null) ...[
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF450A0A),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: const Color(0xFFEF4444)),
                          ),
                          child: Text(
                            auth.errorMessage!,
                            style: const TextStyle(color: Color(0xFFFCA5A5), fontSize: 10),
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],

                      SkeuoButton(
                        label: auth.isLoading
                            ? 'AUTHENTICATING...'
                            : (_isRegisterMode ? 'COMMISSION ACCOUNT' : 'ENGAGE CONSOLE PASSKEY'),
                        size: SkeuoButtonSize.large,
                        onPressed: () {
                          if (_isRegisterMode) {
                            auth.register(
                              _nameController.text.trim(),
                              _emailController.text.trim(),
                              _passwordController.text.trim(),
                            );
                          } else {
                            auth.login(
                              _emailController.text.trim(),
                              _passwordController.text.trim(),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // Quick Calibration Keys
                SkeuoPanel(
                  material: PanelMaterial.darkMetal,
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'FACTORY CALIBRATION ACCESS KEYS',
                        style: TextStyle(
                          fontFamily: 'serif',
                          fontSize: 9.0,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.1,
                          color: Color(0xFFE2B450),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: SkeuoButton(
                              label: 'ADMIN KEY',
                              size: SkeuoButtonSize.small,
                              onPressed: () => _loadPreset('admin@skeuolab.com', 'AdminPass123!'),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: SkeuoButton(
                              label: 'OPERATOR KEY',
                              size: SkeuoButtonSize.small,
                              onPressed: () => _loadPreset('user@skeuolab.com', 'UserPass123!'),
                            ),
                          ),
                        ],
                      ),
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

  Widget _buildStatColumn(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontFamily: 'monospace', fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFFE2B450)),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(fontFamily: 'serif', fontSize: 8, color: Color(0xFF94A3B8)),
        ),
      ],
    );
  }
}
