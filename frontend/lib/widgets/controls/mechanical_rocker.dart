import 'package:flutter/material.dart';
import '../../styles/skeuo_shadows.dart';
import '../../utils/haptics_helper.dart';

/// An industrial mechanical rocker switch that pivots about a central axis,
/// showing an illuminated red/white state indicator when active.
class MechanicalRocker extends StatefulWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final String label;

  const MechanicalRocker({
    super.key,
    required this.value,
    this.onChanged,
    this.label = 'MAIN POWER',
  });

  @override
  State<MechanicalRocker> createState() => _MechanicalRockerState();
}

class _MechanicalRockerState extends State<MechanicalRocker> {
  void _toggle() {
    HapticsHelper.mediumImpact();
    widget.onChanged?.call(!widget.value);
  }

  @override
  Widget build(BuildContext context) {
    final isOn = widget.value;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: _toggle,
          behavior: HitTestBehavior.opaque,
          child: Container(
            width: 52,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              // Beveled chassis housing
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF282C32),
                  Color(0xFF16181B),
                  Color(0xFF121416),
                ],
              ),
              border: Border.all(color: const Color(0xFF14171A), width: 1.5),
              boxShadow: const [
                BoxShadow(
                  color: Color(0xBB000000),
                  offset: Offset(1.5, 3),
                  blurRadius: 5,
                ),
              ],
            ),
            padding: const EdgeInsets.all(5.0),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 140),
              curve: Curves.easeInOut,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                // Rocker paddle gradient changes based on tilt
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: isOn
                      ? [
                          const Color(0xFF22252A),
                          const Color(0xFF32373F),
                          const Color(0xFF4C535E),
                          const Color(0xFF67707E),
                        ]
                      : [
                          const Color(0xFF67707E),
                          const Color(0xFF4C535E),
                          const Color(0xFF32373F),
                          const Color(0xFF22252A),
                        ],
                  stops: const [0.0, 0.3, 0.7, 1.0],
                ),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.2),
                  width: 0.8,
                ),
              ),
              child: Column(
                children: [
                  // Top half of rocker
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: isOn ? const Color(0xFF15171A) : Colors.white.withValues(alpha: 0.3),
                            width: 1.2,
                          ),
                        ),
                      ),
                      child: Center(
                        child: Container(
                          width: 14,
                          height: 4,
                          decoration: BoxDecoration(
                            color: isOn ? const Color(0xFFFF2E2E) : const Color(0xFF3E434B),
                            borderRadius: BorderRadius.circular(2),
                            boxShadow: isOn
                                ? [
                                    const BoxShadow(
                                      color: Color(0xAAFF2E2E),
                                      blurRadius: 6,
                                      spreadRadius: 1,
                                    ),
                                  ]
                                : null,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Bottom half of rocker
                  Expanded(
                    child: Center(
                      child: Text(
                        'O',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          color: !isOn ? const Color(0xFFFFFFFF) : const Color(0xFF3A3E45),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          widget.label.toUpperCase(),
          style: TextStyle(
            fontSize: 9.5,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.5,
            color: const Color(0xFF2C3036),
            shadows: SkeuoShadows.engravedText(
              darkShadow: const Color(0x99000000),
              highlight: Colors.white.withValues(alpha: 0.5),
            ),
          ),
        ),
      ],
    );
  }
}
