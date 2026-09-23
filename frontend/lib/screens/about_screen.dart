import 'package:flutter/material.dart';
import '../styles/skeuo_colors.dart';
import '../styles/skeuo_shadows.dart';
import '../utils/haptics_helper.dart';
import '../widgets/common/engraved_plate.dart';
import '../widgets/common/metal_screw.dart';
import '../widgets/common/skeuo_panel.dart';

/// AboutScreen presents a commemorative plaque mounted on mahogany timber,
/// honoring the philosophy and visual science of Skeuomorphic UI.
class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  int? _selectedPrinciple;

  static const List<_Principle> _principles = [
    _Principle(
      name: 'DEPTH',
      icon: Icons.layers_rounded,
      description: 'Physical objects exist in Z-space. Elevated bezels, recessed grooves, and layered cavities inform the finger of what can be manipulated.',
    ),
    _Principle(
      name: 'TEXTURE',
      icon: Icons.grain_rounded,
      description: 'Tactile realism through brushed aluminum grains, leather stitching, fine knurling, and paper pulp lines grounds abstract screens.',
    ),
    _Principle(
      name: 'LIGHT',
      icon: Icons.lightbulb_outline_rounded,
      description: 'A disciplined 315° directional key light casts razor-sharp top-left rim highlights and soft specular flares across turned metals and glass.',
    ),
    _Principle(
      name: 'SHADOW',
      icon: Icons.wb_shade_rounded,
      description: 'Dual-layer shadows: intense contact occlusion immediately beneath surfaces paired with diffuse ambient penumbra communicate physical weight.',
    ),
    _Principle(
      name: 'MATERIAL',
      icon: Icons.handyman_rounded,
      description: 'Walnut wood, antique brass, tempered glass, stamped steel, and cream ledger paper obey their real-world optical and mechanical properties.',
    ),
    _Principle(
      name: 'MOTION',
      icon: Icons.touch_app_rounded,
      description: 'Spring recoil, needle inertia, bat-switch snapping, and magnetic knob ratchets provide instant kinetic confirmation of physical work done.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF160E08), // Dark mahogany
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Main Commemorative Plaque mounted on dark walnut
              SkeuoPanel(
                material: PanelMaterial.walnut,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Large Engraved Brass Plaque
                    const EngravedPlate(
                      title: 'ABOUT SKEUOMORPHISM',
                      material: PlateMaterial.brass,
                      titleFontSize: 18,
                      paddingVertical: 14,
                      paddingHorizontal: 16,
                    ),
                    const SizedBox(height: 18),

                    // Philosophical Manifesto Text
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFAF6EB),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: const Color(0xFFDCD2C0), width: 1.0),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x99000000),
                            offset: Offset(1, 3),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            '“Skeuomorphism is a design approach that uses visual and interaction patterns inspired by real-world objects.”',
                            style: TextStyle(
                              fontFamily: 'serif',
                              fontSize: 14.5,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w800,
                              height: 1.45,
                              color: Color(0xFF2E1C0C),
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Rather than treating software as flat mathematical pixels, skeuomorphism honors human sensory intuition. By recreating the familiar physical cues of mechanical controls, users experience digital actions as tactile, tangible events.',
                            style: TextStyle(
                              fontFamily: 'serif',
                              fontSize: 11.5,
                              height: 1.5,
                              color: Color(0xFF4A3828),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Section Heading: The Six Pillars
                    Center(
                      child: Text(
                        'THE SIX PHYSICAL PILLARS',
                        style: TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2.5,
                          color: const Color(0xFFDFB660),
                          shadows: SkeuoShadows.engravedText(
                            darkShadow: const Color(0xAA000000),
                            highlight: SkeuoColors.brassHighlight.withValues(alpha: 0.5),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // 6 Stamped Physical Metal Plates (2 columns x 3 rows)
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 2.2,
                      ),
                      itemCount: _principles.length,
                      itemBuilder: (context, index) {
                        final principle = _principles[index];
                        final isSelected = _selectedPrinciple == index;

                        return GestureDetector(
                          onTap: () {
                            HapticsHelper.mediumImpact();
                            setState(() {
                              _selectedPrinciple = isSelected ? null : index;
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 100),
                            transform: Matrix4.identity()
                              ..translate(0.0, isSelected ? 2.5 : 0.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              gradient: isSelected
                                  ? const LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Color(0xFF8C661D),
                                        Color(0xFFDFB660),
                                      ],
                                    )
                                  : const LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Color(0xFFE2E7ED),
                                        Color(0xFFB0B8C2),
                                        Color(0xFF757E8B),
                                      ],
                                      stops: [0.0, 0.4, 1.0],
                                    ),
                              border: Border.all(
                                color: isSelected ? SkeuoColors.brassHighlight : Colors.white.withValues(alpha: 0.8),
                                width: 1.2,
                              ),
                              boxShadow: isSelected
                                  ? const [
                                      BoxShadow(color: Color(0x66000000), offset: Offset(0, 1), blurRadius: 2),
                                    ]
                                  : const [
                                      BoxShadow(color: Color(0x99000000), offset: Offset(1, 3), blurRadius: 4),
                                    ],
                            ),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    principle.icon,
                                    size: 16,
                                    color: isSelected ? const Color(0xFF2B1802) : const Color(0xFF262A30),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    principle.name,
                                    style: TextStyle(
                                      fontFamily: 'serif',
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 2.0,
                                      color: isSelected ? const Color(0xFF2B1802) : const Color(0xFF22262C),
                                      shadows: isSelected
                                          ? null
                                          : [
                                              Shadow(
                                                color: Colors.white.withValues(alpha: 0.7),
                                                offset: const Offset(0, -0.8),
                                                blurRadius: 0.5,
                                              ),
                                            ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    // Principle Detailed Explanation Drawer (shown when one is tapped)
                    if (_selectedPrinciple != null) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF121518),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: SkeuoColors.brassMid, width: 1.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'PRINCIPLE // ${_principles[_selectedPrinciple!].name}',
                              style: const TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 10.0,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1.5,
                                color: SkeuoColors.brassHighlight,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              _principles[_selectedPrinciple!].description,
                              style: const TextStyle(
                                fontFamily: 'serif',
                                fontSize: 11.5,
                                height: 1.45,
                                color: Color(0xFFDCE2EB),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    const SizedBox(height: 18),

                    // Bottom Plaque
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF282D33),
                            Color(0xFF1B1E22),
                            Color(0xFF14171A),
                          ],
                        ),
                        border: Border.all(color: const Color(0xFF404752), width: 1.0),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              MetalScrew(size: 8, material: ScrewMaterial.brass, angle: 0.4),
                              SizedBox(width: 8),
                              Text(
                                'BUILT WITH FLUTTER',
                                style: TextStyle(
                                  fontFamily: 'serif',
                                  fontSize: 11.0,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 2.5,
                                  color: Color(0xFFE2E7ED),
                                ),
                              ),
                              SizedBox(width: 8),
                              MetalScrew(size: 8, material: ScrewMaterial.brass, angle: 1.7),
                            ],
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Designed to demonstrate the art of physical interfaces.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'serif',
                              fontSize: 10.0,
                              fontStyle: FontStyle.italic,
                              color: Color(0xFF98A2AF),
                            ),
                          ),
                        ],
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

class _Principle {
  final String name;
  final IconData icon;
  final String description;
  const _Principle({
    required this.name,
    required this.icon,
    required this.description,
  });
}
