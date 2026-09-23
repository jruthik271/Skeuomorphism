import 'package:flutter/material.dart';
import '../../styles/skeuo_colors.dart';
import '../../styles/skeuo_shadows.dart';
import '../../utils/haptics_helper.dart';
import '../../utils/sound_helper.dart';
import '../common/engraved_plate.dart';
import '../common/metal_screw.dart';

/// A realistic skeuomorphic bottom navigation console with physical
/// raised and recessed metal push keys, jewel indicator lamps, and corner bolts.
class SkeuoBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTabSelected;

  const SkeuoBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTabSelected,
  });

  static const List<_NavItem> _items = [
    _NavItem(icon: Icons.dashboard_rounded, label: 'HOME', targetIndex: 0),
    _NavItem(icon: Icons.tune_rounded, label: 'CONTROLS', targetIndex: 1),
    _NavItem(icon: Icons.science_rounded, label: 'LAB', targetIndex: 2),
    _NavItem(icon: Icons.precision_manufacturing_rounded, label: 'PLAYGROUND', targetIndex: 3),
    _NavItem(icon: Icons.palette_rounded, label: 'PALETTES', targetIndex: 4),
    _NavItem(icon: Icons.apps_rounded, label: 'MORE', targetIndex: -1),
  ];

  void _showMoreMenu(BuildContext context) {
    SoundHelper.playMechanicalClick();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: BoxDecoration(
          color: const Color(0xFF19130E),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          border: Border.all(color: const Color(0xFFDFB660), width: 1.5),
          boxShadow: const [
            BoxShadow(color: Color(0xFF000000), offset: Offset(0, -6), blurRadius: 20),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Center(
              child: EngravedPlate(
                title: 'AUXILIARY INSTRUMENT MODULES',
                material: PlateMaterial.brass,
                showScrews: false,
                titleFontSize: 11,
                letterSpacing: 1.2,
                paddingVertical: 5,
                paddingHorizontal: 14,
              ),
            ),
            const SizedBox(height: 14),
            _buildAuxRow(ctx, Icons.widgets_rounded, 'PHYSICAL OBJECTS', 'Camera, Tape Deck, Notebook', 5),
            const Divider(color: Color(0xFF3B2A1E), height: 10),
            _buildAuxRow(ctx, Icons.inventory_2_rounded, 'PARTS DRAWERS', 'Machinist Assemblies & Storage', 6),
            const Divider(color: Color(0xFF3B2A1E), height: 10),
            _buildAuxRow(ctx, Icons.analytics_rounded, 'CRT & TELEMETRY', 'P31 Phosphor Scanlines & Ballistics', 7),
            const Divider(color: Color(0xFF3B2A1E), height: 10),
            _buildAuxRow(ctx, Icons.lock_person_rounded, 'OPERATOR CLEARANCE', 'Machine Passkey & Profile Card', 8),
            const Divider(color: Color(0xFF3B2A1E), height: 10),
            _buildAuxRow(ctx, Icons.admin_panel_settings_rounded, 'ADMIN CONSOLE', 'Factory Recalibration & Diagnostics', 9),
            const Divider(color: Color(0xFF3B2A1E), height: 10),
            _buildAuxRow(ctx, Icons.military_tech_rounded, 'ABOUT SKEUOLAB', 'Design Philosophy & Specifications', 10),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildAuxRow(BuildContext context, IconData icon, String title, String subtitle, int targetIndex) {
    final isSelected = currentIndex == targetIndex;
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        SoundHelper.click();
        onTabSelected(targetIndex);
      },
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2E2014) : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
          border: isSelected ? Border.all(color: const Color(0xFFDFB660), width: 1.0) : null,
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: isSelected ? const Color(0xFFDFB660) : const Color(0xFF94A3B8)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: 'serif',
                      fontSize: 10.5,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.0,
                      color: isSelected ? const Color(0xFFDFB660) : Colors.white,
                    ),
                  ),
                  Text(subtitle, style: const TextStyle(fontSize: 8.5, color: Color(0xFF94A3B8))),
                ],
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle_rounded, size: 14, color: Color(0xFFDFB660)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        // Heavy brushed dark metal console panel
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF32373E),
            Color(0xFF22262B),
            Color(0xFF181B1E),
          ],
          stops: [0.0, 0.4, 1.0],
        ),
        border: Border(
          top: const BorderSide(color: Color(0xFF555D68), width: 1.8),
          bottom: const BorderSide(color: Color(0xFF0D0F11), width: 2.0),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0xEE000000),
            offset: Offset(0, -4),
            blurRadius: 10,
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
      child: SafeArea(
        top: false,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Screws at extreme left and right of nav bar
            const Positioned(
              left: 0,
              child: MetalScrew(size: 8, material: ScrewMaterial.chrome, angle: 0.5),
            ),
            const Positioned(
              right: 0,
              child: MetalScrew(size: 8, material: ScrewMaterial.chrome, angle: 2.2),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(_items.length, (index) {
                  final item = _items[index];
                  final isSelected = item.targetIndex == -1
                      ? currentIndex >= 5
                      : currentIndex == item.targetIndex;

                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: _NavTabButton(
                        item: item,
                        isSelected: isSelected,
                        onTap: () {
                          HapticsHelper.mediumImpact();
                          if (item.targetIndex == -1) {
                            _showMoreMenu(context);
                          } else {
                            onTabSelected(item.targetIndex);
                          }
                        },
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  final int targetIndex;
  const _NavItem({required this.icon, required this.label, required this.targetIndex});
}

class _NavTabButton extends StatelessWidget {
  final _NavItem item;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavTabButton({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 140),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(vertical: 5),
        transform: Matrix4.identity()..translate(0.0, isSelected ? 1.5 : 0.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          gradient: isSelected
              ? const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF14171A),
                    Color(0xFF1F2328),
                    Color(0xFF282D33),
                  ],
                  stops: [0.0, 0.4, 1.0],
                )
              : const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFE2E7ED),
                    Color(0xFFB0B8C2),
                    Color(0xFF7A828E),
                  ],
                  stops: [0.0, 0.35, 1.0],
                ),
          border: isSelected
              ? Border.all(color: const Color(0xFF101215), width: 1.2)
              : Border.all(color: Colors.white.withValues(alpha: 0.6), width: 1.2),
          boxShadow: isSelected
              ? const [
                  BoxShadow(color: Color(0x88000000), offset: Offset(0, 1), blurRadius: 2),
                ]
              : const [
                  BoxShadow(color: Color(0x99000000), offset: Offset(0, 2), blurRadius: 4),
                ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Micro Jewel Lamp indicator (glows amber when tab is active)
            Container(
              width: 5,
              height: 5,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? SkeuoColors.amberPixelOn : const Color(0xFF42474E),
                boxShadow: isSelected
                    ? [
                        const BoxShadow(
                          color: SkeuoColors.amberPixelGlow,
                          blurRadius: 6,
                          spreadRadius: 1,
                        ),
                      ]
                    : null,
              ),
            ),
            const SizedBox(height: 2),

            Icon(
              item.icon,
              size: 16,
              color: isSelected ? const Color(0xFFFFB300) : const Color(0xFF24282D),
              shadows: isSelected
                  ? [
                      const Shadow(color: Color(0x99FFB300), blurRadius: 6),
                    ]
                  : [
                      Shadow(
                        color: Colors.white.withValues(alpha: 0.7),
                        offset: const Offset(0, -0.8),
                        blurRadius: 0.5,
                      ),
                    ],
            ),
            const SizedBox(height: 2),

            Text(
              item.label,
              style: TextStyle(
                fontSize: 7.5,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.9,
                color: isSelected ? const Color(0xFFFFB300) : const Color(0xFF2E3339),
                shadows: isSelected
                    ? [
                        const Shadow(color: Color(0x66FFB300), blurRadius: 4),
                      ]
                    : SkeuoShadows.engravedText(
                        darkShadow: const Color(0xAA000000),
                        highlight: Colors.white.withValues(alpha: 0.6),
                      ),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
