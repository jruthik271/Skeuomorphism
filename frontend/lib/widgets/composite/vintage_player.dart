import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../styles/skeuo_shadows.dart';
import '../../utils/haptics_helper.dart';
import '../common/led_indicator.dart';
import '../common/metal_screw.dart';
import '../common/speaker_grille.dart';

/// A realistic vintage cassette tape audio player panel with spinning spools,
/// magnetic tape window, physical tactile transport buttons, and speaker grille.
class VintagePlayer extends StatefulWidget {
  const VintagePlayer({super.key});

  @override
  State<VintagePlayer> createState() => _VintagePlayerState();
}

class _VintagePlayerState extends State<VintagePlayer>
    with SingleTickerProviderStateMixin {
  bool _isPlaying = false;
  double _progress = 0.35;
  late AnimationController _spoolController;

  @override
  void initState() {
    super.initState();
    _spoolController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
  }

  @override
  void dispose() {
    _spoolController.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    HapticsHelper.mediumImpact();
    setState(() {
      _isPlaying = !_isPlaying;
      if (_isPlaying) {
        _spoolController.repeat();
      } else {
        _spoolController.stop();
      }
    });
  }

  void _skipForward() {
    HapticsHelper.lightImpact();
    setState(() {
      _progress = (_progress + 0.1).clamp(0.0, 1.0);
    });
  }

  void _skipBackward() {
    HapticsHelper.lightImpact();
    setState(() {
      _progress = (_progress - 0.1).clamp(0.0, 1.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        // Brushed dark metal / vintage deck chassis
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF424850),
            Color(0xFF2C3138),
            Color(0xFF1E2226),
            Color(0xFF2D323A),
          ],
          stops: [0.0, 0.3, 0.7, 1.0],
        ),
        border: Border.all(color: const Color(0xFF4C535C), width: 1.5),
        boxShadow: const [
          BoxShadow(
            color: Color(0xDD000000),
            offset: Offset(2, 6),
            blurRadius: 14,
          ),
        ],
      ),
      padding: const EdgeInsets.all(12.0),
      child: Stack(
        children: [
          // Corner screws on deck
          const Positioned(
            top: 0,
            left: 0,
            child: MetalScrew(size: 10, material: ScrewMaterial.chrome, angle: 0.8),
          ),
          const Positioned(
            top: 0,
            right: 0,
            child: MetalScrew(size: 10, material: ScrewMaterial.chrome, angle: 2.5),
          ),
          const Positioned(
            bottom: 0,
            left: 0,
            child: MetalScrew(size: 10, material: ScrewMaterial.chrome, angle: 1.3),
          ),
          const Positioned(
            bottom: 0,
            right: 0,
            child: MetalScrew(size: 10, material: ScrewMaterial.chrome, angle: 3.9),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header brand badge and Power/Play LED
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFF16181B),
                            borderRadius: BorderRadius.circular(3),
                            border: Border.all(color: const Color(0xFF383E46), width: 0.8),
                          ),
                          child: Text(
                            'STEREO CASSETTE DECK',
                            style: TextStyle(
                              fontSize: 9.0,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 2.0,
                              color: const Color(0xFFC2CBD4),
                              shadows: SkeuoShadows.engravedText(
                                darkShadow: const Color(0xAA000000),
                                highlight: Colors.white.withValues(alpha: 0.4),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'RUN',
                          style: TextStyle(
                            fontSize: 8.5,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.2,
                            color: const Color(0xFF8B94A0),
                            shadows: SkeuoShadows.engravedText(
                              darkShadow: const Color(0xAA000000),
                              highlight: Colors.white.withValues(alpha: 0.3),
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        LedIndicator(
                          isOn: _isPlaying,
                          color: LedColor.green,
                          size: 11,
                          labelBelow: false,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Cassette Well & Speaker Grille Row
                Row(
                  children: [
                    // Cassette Window Compartment
                    Expanded(
                      flex: 6,
                      child: Container(
                        height: 120,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          // Recessed cassette bay
                          color: const Color(0xFF101215),
                          border: Border.all(color: const Color(0xFF090B0D), width: 1.5),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0xDD000000),
                              offset: Offset(0, 2),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Amber/brown translucent cassette shell body
                              Container(
                                margin: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  gradient: const LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Color(0xFF2E1C12),
                                      Color(0xFF452B1C),
                                      Color(0xFF26170E),
                                    ],
                                  ),
                                  border: Border.all(color: const Color(0xFF5E3C27), width: 1.0),
                                ),
                              ),

                              // Clear Tape Window with Spools
                              Container(
                                width: 130,
                                height: 58,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF0D0F11),
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(color: const Color(0xFF282C31), width: 0.8),
                                ),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    // Magnetic tape ribbon between spools
                                    Positioned(
                                      top: 26,
                                      left: 28,
                                      right: 28,
                                      height: 6,
                                      child: Container(
                                        color: const Color(0xFF362015),
                                      ),
                                    ),

                                    // Left & Right Tape Spools
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        _buildSpool(true),
                                        _buildSpool(false),
                                      ],
                                    ),

                                    // Glass Reflection on Cassette Window
                                    Positioned.fill(
                                      child: IgnorePointer(
                                        child: Container(
                                          decoration: const BoxDecoration(
                                            gradient: LinearGradient(
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                              colors: [
                                                Color(0x30FFFFFF),
                                                Color(0x05FFFFFF),
                                                Color(0x00FFFFFF),
                                                Color(0x18FFFFFF),
                                              ],
                                              stops: [0.0, 0.35, 0.65, 1.0],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Tape Label Badge
                              Positioned(
                                top: 12,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 1.5),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFAF6EB),
                                    borderRadius: BorderRadius.circular(2),
                                    boxShadow: const [
                                      BoxShadow(color: Color(0x66000000), blurRadius: 2),
                                    ],
                                  ),
                                  child: const Text(
                                    'TYPE II • HIGH BIAS • 90 MIN',
                                    style: TextStyle(
                                      fontSize: 7.5,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 1.0,
                                      color: Color(0xFF382C1E),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 10),

                    // Acoustic Speaker Grille on Right
                    Expanded(
                      flex: 4,
                      child: SpeakerGrille(
                        width: double.infinity,
                        height: 120,
                        holeRadius: 2.2,
                        holeSpacing: 7.5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Tape Progress Track
                Container(
                  height: 12,
                  decoration: BoxDecoration(
                    color: const Color(0xFF101215),
                    borderRadius: BorderRadius.circular(3),
                    border: Border.all(color: const Color(0xFF08090B), width: 1.0),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: _progress,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2),
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF388E3C),
                            Color(0xFF66BB6A),
                            Color(0xFF81C784),
                          ],
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x6666BB6A),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Physical Mechanical Transport Buttons (PREV, PLAY/PAUSE, NEXT)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildTransportButton(
                      icon: Icons.fast_rewind_rounded,
                      label: 'REW',
                      onPressed: _skipBackward,
                    ),
                    _buildTransportButton(
                      icon: _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                      label: _isPlaying ? 'PAUSE' : 'PLAY',
                      isProminent: true,
                      isPressed: _isPlaying,
                      onPressed: _togglePlayPause,
                    ),
                    _buildTransportButton(
                      icon: Icons.fast_forward_rounded,
                      label: 'FFWD',
                      onPressed: _skipForward,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpool(bool isLeft) {
    return AnimatedBuilder(
      animation: _spoolController,
      builder: (context, child) {
        return Transform.rotate(
          angle: _spoolController.value * 2 * math.pi,
          child: Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFEDE8D8),
              border: Border.all(color: const Color(0xFF9E9585), width: 1.0),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x88000000),
                  offset: Offset(0, 1),
                  blurRadius: 2,
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // 3 Spool teeth
                for (int i = 0; i < 3; i++)
                  Transform.rotate(
                    angle: (i * 2 * math.pi / 3),
                    child: Container(
                      width: 4,
                      height: 36,
                      color: const Color(0xFF635D52),
                    ),
                  ),
                // Center hub
                Container(
                  width: 14,
                  height: 14,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF1E2125),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTransportButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    bool isProminent = false,
    bool isPressed = false,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 90),
            width: isProminent ? 64 : 54,
            height: 38,
            transform: Matrix4.identity()
              ..translate(0.0, isPressed ? 2.5 : 0.0)
              ..scale(isPressed ? 0.96 : 1.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              gradient: isPressed
                  ? const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFF555B63),
                        Color(0xFF7A828D),
                      ],
                    )
                  : LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: isProminent
                          ? const [
                              Color(0xFFFFFFFF),
                              Color(0xFFDCE2E8),
                              Color(0xFFA5ADB8),
                              Color(0xFF686F78),
                            ]
                          : const [
                              Color(0xFFE4E8ED),
                              Color(0xFFB4BCC6),
                              Color(0xFF7E8793),
                            ],
                    ),
              border: Border.all(
                color: isPressed ? const Color(0xFF383C42) : Colors.white.withValues(alpha: 0.8),
                width: 1.2,
              ),
              boxShadow: isPressed
                  ? const [
                      BoxShadow(color: Color(0x66000000), offset: Offset(0, 1), blurRadius: 1),
                    ]
                  : const [
                      BoxShadow(color: Color(0xAA000000), offset: Offset(1, 3), blurRadius: 4),
                    ],
            ),
            child: Icon(
              icon,
              size: 20,
              color: isPressed ? const Color(0xFF1B1E22) : const Color(0xFF2A2E33),
              shadows: isPressed
                  ? null
                  : [
                      Shadow(
                        color: Colors.white.withValues(alpha: 0.8),
                        offset: const Offset(0, -0.8),
                        blurRadius: 0.5,
                      ),
                    ],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 8.5,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
              color: const Color(0xFF98A1AC),
              shadows: SkeuoShadows.engravedText(
                darkShadow: const Color(0xAA000000),
                highlight: Colors.white.withValues(alpha: 0.3),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
