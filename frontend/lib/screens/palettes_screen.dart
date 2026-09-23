import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/material_palette.dart';
import '../services/theme_controller.dart';
import '../styles/skeuo_colors.dart';
import '../styles/skeuo_shadows.dart';
import '../utils/sound_helper.dart';
import '../widgets/common/engraved_plate.dart';
import '../widgets/common/led_indicator.dart';
import '../widgets/common/metal_screw.dart';
import '../widgets/common/skeuo_panel.dart';
import '../widgets/controls/skeuo_button.dart';

class PalettesScreen extends StatefulWidget {
  const PalettesScreen({super.key});

  @override
  State<PalettesScreen> createState() => _PalettesScreenState();
}

class _PalettesScreenState extends State<PalettesScreen> {
  MaterialCategory? _selectedCategory;
  int _selectedPaletteIndex = 0;
  String? _lastCopiedText;

  void _copyToClipboard(String text, String label) {
    SoundHelper.click();
    Clipboard.setData(ClipboardData(text: text));
    setState(() {
      _lastCopiedText = '$label COPIED: $text';
    });
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF101215),
        duration: const Duration(milliseconds: 1400),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
          side: const BorderSide(color: Color(0xFF383D43), width: 1.0),
        ),
        content: Row(
          children: [
            const LedIndicator(isOn: true, color: LedColor.green, size: 8, labelBelow: false),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                '$label COPIED: $text',
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: SkeuoColors.lcdPixelOn,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredPalettes = _selectedCategory == null
        ? MaterialPalette.all
        : MaterialPalette.all.where((p) => p.category == _selectedCategory).toList();

    if (_selectedPaletteIndex >= filteredPalettes.length) {
      _selectedPaletteIndex = 0;
    }

    final activePalette = filteredPalettes.isNotEmpty
        ? filteredPalettes[_selectedPaletteIndex]
        : MaterialPalette.all.first;

    final themeController = ThemeController.instance;

    return Scaffold(
      backgroundColor: const Color(0xFF140E0A),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Commemorative Header Plaque
              const Center(
                child: EngravedPlate(
                  title: 'PALETTE & MATERIAL STUDIO',
                  subtitle: 'Tactile Skeuomorphic Tokens & Gradient Recipes',
                  material: PlateMaterial.brass,
                  titleFontSize: 19,
                  subtitleFontSize: 10,
                  paddingVertical: 12,
                  paddingHorizontal: 18,
                ),
              ),
              const SizedBox(height: 14),

              // 2. Global Chassis Theme Switcher
              SkeuoPanel(
                material: PanelMaterial.walnut,
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Flexible(
                          child: Text(
                            'GLOBAL CHASSIS THEME',
                            style: TextStyle(
                              fontSize: 9.5,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.4,
                              color: Color(0xFF3B271B),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFF140D08),
                            borderRadius: BorderRadius.circular(3),
                            border: Border.all(color: const Color(0xFF382314), width: 0.8),
                          ),
                          child: Text(
                            themeController.themeMode.label.toUpperCase(),
                            style: const TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 9.0,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFFFFB300),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        return Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: AppThemeMode.values.map((mode) {
                            final isCurrent = themeController.themeMode == mode;
                            return GestureDetector(
                              onTap: () {
                                SoundHelper.switchClack();
                                themeController.setThemeMode(mode);
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 140),
                                width: (constraints.maxWidth - 24) / 2 > 130
                                    ? (constraints.maxWidth - 24) / 2
                                    : constraints.maxWidth,
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  gradient: isCurrent
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
                                            Color(0xFF2C3138),
                                            Color(0xFF1B1E22),
                                          ],
                                        ),
                                  border: Border.all(
                                    color: isCurrent ? SkeuoColors.brassHighlight : const Color(0xFF3E454E),
                                    width: 1.2,
                                  ),
                                  boxShadow: isCurrent
                                      ? const [
                                          BoxShadow(color: Color(0x66DFB660), blurRadius: 6),
                                        ]
                                      : const [
                                          BoxShadow(color: Color(0x88000000), offset: Offset(1, 2), blurRadius: 4),
                                        ],
                                ),
                                child: Row(
                                  children: [
                                    LedIndicator(
                                      isOn: isCurrent,
                                      color: isCurrent ? LedColor.amber : LedColor.red,
                                      size: 8,
                                      labelBelow: false,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            mode.label.toUpperCase(),
                                            style: TextStyle(
                                              fontFamily: 'serif',
                                              fontSize: 10.5,
                                              fontWeight: FontWeight.w900,
                                              letterSpacing: 1.2,
                                              color: isCurrent ? const Color(0xFF2B1802) : Colors.white,
                                            ),
                                          ),
                                          Text(
                                            mode.description,
                                            style: TextStyle(
                                              fontSize: 8.5,
                                              color: isCurrent ? const Color(0xFF4A320A) : const Color(0xFF8B949E),
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // 3. Category Filter Tabs
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFF16191D),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFF2A2F36), width: 1.2),
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterTab(label: 'ALL (10)', category: null),
                      const SizedBox(width: 6),
                      _buildFilterTab(label: 'METALS (4)', category: MaterialCategory.metals),
                      const SizedBox(width: 6),
                      _buildFilterTab(label: 'ORGANICS (2)', category: MaterialCategory.organics),
                      const SizedBox(width: 6),
                      _buildFilterTab(label: 'DISPLAYS (3)', category: MaterialCategory.displays),
                      const SizedBox(width: 6),
                      _buildFilterTab(label: 'PAPERS (1)', category: MaterialCategory.papers),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // 4. Material Palette Selector Strip
              SizedBox(
                height: 48,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: filteredPalettes.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final palette = filteredPalettes[index];
                    final isSelected = _selectedPaletteIndex == index;
                    return GestureDetector(
                      onTap: () {
                        SoundHelper.click();
                        setState(() {
                          _selectedPaletteIndex = index;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 140),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          gradient: isSelected
                              ? const LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Color(0xFFE2E7ED),
                                    Color(0xFFB0B8C2),
                                    Color(0xFF757E8B),
                                  ],
                                  stops: [0.0, 0.4, 1.0],
                                )
                              : const LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Color(0xFF24282E),
                                    Color(0xFF181B1F),
                                  ],
                                ),
                          border: Border.all(
                            color: isSelected ? Colors.white : const Color(0xFF353C46),
                            width: 1.2,
                          ),
                          boxShadow: isSelected
                              ? const [
                                  BoxShadow(color: Color(0x99000000), offset: Offset(0, 3), blurRadius: 6),
                                ]
                              : null,
                        ),
                        child: Center(
                          child: Text(
                            palette.name.toUpperCase(),
                            style: TextStyle(
                              fontFamily: 'serif',
                              fontSize: 10.5,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.2,
                              color: isSelected ? const Color(0xFF16191D) : const Color(0xFF8B949E),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 14),

              // 5. Active Palette Showcase Card
              SkeuoPanel(
                material: PanelMaterial.aluminum,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Material Title Header & Badge
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                activePalette.name.toUpperCase(),
                                style: const TextStyle(
                                  fontFamily: 'serif',
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 2.2,
                                  color: Color(0xFF1E2227),
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                activePalette.description,
                                style: const TextStyle(
                                  fontSize: 10.5,
                                  color: Color(0xFF4C5460),
                                  height: 1.35,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF14171A),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: const Color(0xFF353B44)),
                          ),
                          child: Text(
                            activePalette.tag,
                            style: const TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 9.0,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.5,
                              color: SkeuoColors.brassHighlight,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Material Optical Texture Simulator Box
                    Container(
                      height: 85,
                      decoration: BoxDecoration(
                        gradient: activePalette.gradient,
                        borderRadius: BorderRadius.circular(8),
                        border: activePalette.border,
                        boxShadow: activePalette.shadows,
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Stack(
                        children: [
                          const Positioned(
                            top: 0,
                            left: 0,
                            child: MetalScrew(size: 8, material: ScrewMaterial.chrome, angle: 0.5),
                          ),
                          const Positioned(
                            top: 0,
                            right: 0,
                            child: MetalScrew(size: 8, material: ScrewMaterial.chrome, angle: 2.4),
                          ),
                          Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: const Color(0x66000000),
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                              ),
                              child: Text(
                                '${activePalette.name.toUpperCase()} // LIVE TEXTURE',
                                style: TextStyle(
                                  fontSize: 10.0,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 2.0,
                                  color: Colors.white,
                                  shadows: SkeuoShadows.engravedText(),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Material Physical Specs Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildSpecTag(Icons.auto_awesome_rounded, activePalette.reflectivity),
                        _buildSpecTag(Icons.grain_rounded, activePalette.textureType),
                        _buildSpecTag(Icons.light_mode_rounded, activePalette.keyLightAngle),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Swatches Grid & Color Tokens
                    const Text(
                      'COLOR TOKENS & SWATCHES (TAP TO COPY HEX)',
                      style: TextStyle(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.8,
                        color: Color(0xFF2E343E),
                      ),
                    ),
                    const SizedBox(height: 8),

                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: activePalette.swatches.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 6),
                      itemBuilder: (context, sIndex) {
                        final swatch = activePalette.swatches[sIndex];
                        return GestureDetector(
                          onTap: () => _copyToClipboard(swatch.hex, swatch.name),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF2F4F7),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: const Color(0xFFCDD4DC)),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x18000000),
                                  offset: Offset(0, 1),
                                  blurRadius: 2,
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    color: swatch.color,
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(color: const Color(0x33000000), width: 1.0),
                                    boxShadow: const [
                                      BoxShadow(color: Color(0x33000000), offset: Offset(1, 1), blurRadius: 2),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        swatch.name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w800,
                                          fontSize: 11,
                                          color: Color(0xFF1E2227),
                                        ),
                                      ),
                                      Text(
                                        swatch.role,
                                        style: const TextStyle(
                                          fontSize: 9.0,
                                          color: Color(0xFF6B7380),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF14171A),
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(color: const Color(0xFF383E46), width: 0.8),
                                  ),
                                  child: Text(
                                    swatch.hex,
                                    style: const TextStyle(
                                      fontFamily: 'monospace',
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.w800,
                                      color: SkeuoColors.lcdPixelOn,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),

                    // Code Snippet Export Buttons
                    Row(
                      children: [
                        Expanded(
                          child: SkeuoButton(
                            label: 'FLUTTER',
                            type: ButtonType.machinedMetal,
                            height: 42,
                            icon: Icons.code_rounded,
                            textStyle: const TextStyle(
                              fontSize: 10.0,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.0,
                              color: Color(0xFF1E2125),
                            ),
                            onPressed: () => _copyToClipboard(
                              activePalette.flutterSnippet,
                              '${activePalette.name} FLUTTER DECORATION',
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: SkeuoButton(
                            label: 'CSS CODE',
                            type: ButtonType.brass,
                            height: 42,
                            icon: Icons.css_rounded,
                            textStyle: const TextStyle(
                              fontSize: 10.0,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.0,
                              color: Color(0xFF382305),
                            ),
                            onPressed: () => _copyToClipboard(
                              activePalette.cssSnippet,
                              '${activePalette.name} CSS',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // 6. Real-time Status Readout
              if (_lastCopiedText != null) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F1411),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: SkeuoColors.lcdPixelDim),
                  ),
                  child: Row(
                    children: [
                      const LedIndicator(isOn: true, color: LedColor.green, size: 8, labelBelow: false),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _lastCopiedText!,
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 10.0,
                            fontWeight: FontWeight.w800,
                            color: SkeuoColors.lcdPixelOn,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterTab({required String label, required MaterialCategory? category}) {
    final isSelected = _selectedCategory == category;
    return GestureDetector(
      onTap: () {
        SoundHelper.click();
        setState(() {
          _selectedCategory = category;
          _selectedPaletteIndex = 0;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          gradient: isSelected
              ? const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFE2E7ED), Color(0xFFB0B8C2)],
                )
              : const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF282D34), Color(0xFF1B1E22)],
                ),
          border: Border.all(
            color: isSelected ? Colors.white : const Color(0xFF383E48),
            width: 1.0,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 9.5,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
            color: isSelected ? const Color(0xFF1B1E22) : const Color(0xFF8B949E),
          ),
        ),
      ),
    );
  }

  Widget _buildSpecTag(IconData icon, String text) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 2),
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
        decoration: BoxDecoration(
          color: const Color(0xFFE6EAEE),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: const Color(0xFFCDD4DC)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 10, color: const Color(0xFF4C5460)),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 8.5,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF2C323B),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
