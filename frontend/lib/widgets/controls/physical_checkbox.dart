import 'package:flutter/material.dart';
import '../../styles/skeuo_colors.dart';
import '../../styles/skeuo_shadows.dart';
import '../../utils/haptics_helper.dart';

/// A heavy brass sliding latch checkbox with machined guide brackets
/// and satisfying mechanical sliding travel.
class PhysicalCheckbox extends StatefulWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final String label;

  const PhysicalCheckbox({
    super.key,
    required this.value,
    this.onChanged,
    this.label = 'ENGAGE',
  });

  @override
  State<PhysicalCheckbox> createState() => _PhysicalCheckboxState();
}

class _PhysicalCheckboxState extends State<PhysicalCheckbox> {
  void _toggle() {
    HapticsHelper.mediumImpact();
    widget.onChanged?.call(!widget.value);
  }

  @override
  Widget build(BuildContext context) {
    final isChecked = widget.value;

    return GestureDetector(
      onTap: _toggle,
      behavior: HitTestBehavior.opaque,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // The Brass Sliding Latch Mechanism
          Container(
            width: 72,
            height: 34,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              // Recessed dark housing track
              color: const Color(0xFF14171A),
              border: Border.all(color: const Color(0xFF090B0C), width: 1.5),
              boxShadow: const [
                BoxShadow(
                  color: Color(0xAA000000),
                  offset: Offset(0, 2),
                  blurRadius: 3,
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
            child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                // Inner status indicator hole (reveals green when locked)
                Positioned(
                  right: 8,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isChecked ? SkeuoColors.ledGreenOn : const Color(0xFF22272E),
                      boxShadow: isChecked
                          ? [
                              const BoxShadow(
                                color: SkeuoColors.ledGreenGlow,
                                blurRadius: 6,
                                spreadRadius: 1,
                              ),
                            ]
                          : null,
                    ),
                  ),
                ),

                // The Brass Sliding Bolt
                AnimatedAlign(
                  duration: const Duration(milliseconds: 160),
                  curve: Curves.easeOutBack,
                  alignment: isChecked ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    width: 38,
                    height: 24,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      // Machined Antique Brass Gradient
                      gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          SkeuoColors.brassHighlight,
                          SkeuoColors.brassLight,
                          SkeuoColors.brassMid,
                          SkeuoColors.brassDark,
                        ],
                        stops: [0.0, 0.2, 0.7, 1.0],
                      ),
                      border: Border.all(color: SkeuoColors.brassHighlight, width: 1.2),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0xAA000000),
                          offset: Offset(1, 2),
                          blurRadius: 3,
                        ),
                      ],
                    ),
                    child: Center(
                      // Grip knurls on the brass bolt
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          for (int i = 0; i < 4; i++)
                            Container(
                              width: 1.5,
                              height: 14,
                              margin: const EdgeInsets.symmetric(horizontal: 1.5),
                              color: SkeuoColors.brassShadow.withValues(alpha: 0.8),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              widget.label.toUpperCase(),
              style: TextStyle(
                fontSize: 10.0,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.2,
                color: const Color(0xFF2E3339),
                shadows: SkeuoShadows.engravedText(
                  darkShadow: const Color(0x99000000),
                  highlight: Colors.white.withValues(alpha: 0.5),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
