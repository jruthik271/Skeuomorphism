import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../models/material_palette.dart';
import '../../providers/analytics_provider.dart';
import '../../providers/materials_provider.dart';
import '../../styles/skeuo_colors.dart';
import '../../utils/sound_helper.dart';
import '../../widgets/common/engraved_plate.dart';
import '../../widgets/common/skeuo_panel.dart';
import '../../widgets/controls/skeuo_button.dart';
import '../../widgets/controls/skeuo_slider.dart';

class LaboratoryScreen extends StatefulWidget {
  const LaboratoryScreen({super.key});

  @override
  State<LaboratoryScreen> createState() => _LaboratoryScreenState();
}

class _LaboratoryScreenState extends State<LaboratoryScreen> {
  double _roughness = 0.28;
  double _metallic = 0.88;
  bool _copied = false;

  @override
  Widget build(BuildContext context) {
    final matProvider = context.watch<MaterialsProvider>();
    final analytics = context.watch<AnalyticsProvider>();
    final material = matProvider.selectedMaterial;

    return Scaffold(
      backgroundColor: const Color(0xFF140D08),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header Plate
              const Center(
                child: EngravedPlate(
                  title: 'OPTICAL TESTING BAY',
                  subtitle: 'Photometric Material & Specular Calibrator',
                  material: PlateMaterial.brass,
                  titleFontSize: 20,
                  subtitleFontSize: 9,
                  paddingVertical: 10,
                  paddingHorizontal: 24,
                ),
              ),
              const SizedBox(height: 14),

              // Material Specimen Selector Ribbon
              SkeuoPanel(
                material: PanelMaterial.darkMetal,
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'ACTIVE SPECIMEN FORMULA',
                      style: TextStyle(
                        fontFamily: 'serif',
                        fontSize: 9.5,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.2,
                        color: Color(0xFFE2B450),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 42,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: MaterialPalettes.all.length,
                        itemBuilder: (context, index) {
                          final m = MaterialPalettes.all[index];
                          final isSelected = m.id == material.id;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: GestureDetector(
                              onTap: () => matProvider.selectMaterial(m),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 150),
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  gradient: isSelected
                                      ? const LinearGradient(
                                          colors: [Color(0xFFDFB660), Color(0xFF8A6218)],
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                        )
                                      : const LinearGradient(
                                          colors: [Color(0xFF2A2E35), Color(0xFF1A1C20)],
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                        ),
                                  border: Border.all(
                                    color: isSelected ? const Color(0xFFFFD573) : const Color(0xFF3E444F),
                                    width: 1.2,
                                  ),
                                  boxShadow: const [
                                    BoxShadow(color: Color(0x88000000), offset: Offset(0, 2), blurRadius: 4),
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    m.name.toUpperCase(),
                                    style: TextStyle(
                                      fontFamily: 'serif',
                                      fontSize: 9,
                                      fontWeight: FontWeight.w900,
                                      color: isSelected ? const Color(0xFF1F1202) : const Color(0xFFD1D5DB),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Interactive 3D Optical Testing Crucible (Sphere & Cylinder with dynamic light angle)
              SkeuoPanel(
                material: PanelMaterial.walnut,
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Flexible(
                          child: Text(
                            'INCIDENT LIGHT CHAMBER',
                            style: TextStyle(
                              fontFamily: 'serif',
                              fontSize: 9.5,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.1,
                              color: Color(0xFFD4AF37),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0F172A),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: const Color(0xFF334155)),
                          ),
                          child: Text(
                            'AZIMUTH: ${analytics.keyLightAngleDegrees.toStringAsFixed(0)}°',
                            style: const TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 9.5,
                              color: Color(0xFF4ADE80),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // 3D Optical Canvas Representation
                    Container(
                      height: 180,
                      decoration: BoxDecoration(
                        color: const Color(0xFF080B10),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFF2E3440), width: 2),
                        boxShadow: const [
                          BoxShadow(color: Color(0xDD000000), offset: Offset(0, 4), blurRadius: 10, spreadRadius: 2),
                        ],
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Background Grid Lines
                          CustomPaint(
                            size: const Size(double.infinity, 180),
                            painter: _ChamberGridPainter(),
                          ),

                          // Interactive Specimen Sphere
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildSpecularSphere(analytics.keyLightAngleDegrees, material),
                              _buildSpecularCylinder(analytics.keyLightAngleDegrees, material),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Key Light Angle Slider
                    Row(
                      children: [
                        const Text('LIGHT AZIMUTH:', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFFA1A1AA))),
                        Expanded(
                          child: SkeuoSlider(
                            value: analytics.keyLightAngleDegrees,
                            min: 0,
                            max: 360,
                            label: '',
                            onChanged: (v) => analytics.setKeyLightAngle(v),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Material Optical Tweaks
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('SURFACE ROUGHNESS: ${(_roughness * 100).toInt()}%', style: const TextStyle(fontSize: 8.5, color: Color(0xFFA1A1AA))),
                              SkeuoSlider(
                                value: _roughness,
                                min: 0.05,
                                max: 1.0,
                                label: '',
                                onChanged: (v) => setState(() => _roughness = v),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('METALLIC LUSTER: ${(_metallic * 100).toInt()}%', style: const TextStyle(fontSize: 8.5, color: Color(0xFFA1A1AA))),
                              SkeuoSlider(
                                value: _metallic,
                                min: 0.0,
                                max: 1.0,
                                label: '',
                                onChanged: (v) => setState(() => _metallic = v),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Exportable Formula Snippet Console
              SkeuoPanel(
                material: PanelMaterial.darkMetal,
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Flexible(
                          child: Text(
                            'SYNTHESIZED CODE ARTIFACT',
                            style: TextStyle(
                              fontFamily: 'serif',
                              fontSize: 9.5,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.1,
                              color: Color(0xFFE2B450),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        SkeuoButton(
                          label: _copied ? 'COPIED!' : 'COPY CSS',
                          size: SkeuoButtonSize.small,
                          onPressed: () {
                            SoundHelper.playMechanicalClick();
                            Clipboard.setData(ClipboardData(text: material.cssSnippet));
                            setState(() => _copied = true);
                            Future.delayed(const Duration(seconds: 2), () {
                              if (mounted) setState(() => _copied = false);
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF070B0E),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: const Color(0xFF1E293B)),
                      ),
                      child: Text(
                        material.cssSnippet,
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 9.5,
                          height: 1.45,
                          color: Color(0xFF38BDF8),
                        ),
                      ),
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

  Widget _buildSpecularSphere(double angleDegrees, MaterialPalette material) {
    final rad = angleDegrees * pi / 180.0;
    final alignX = cos(rad) * 0.6;
    final alignY = sin(rad) * 0.6;

    final primaryColor = material.swatches.isNotEmpty ? material.swatches[0].color : SkeuoColors.brassCore;
    final secondaryColor = material.swatches.length > 1 ? material.swatches[1].color : SkeuoColors.brassShadow;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              center: Alignment(alignX, alignY),
              radius: 0.85,
              colors: [
                Colors.white.withValues(alpha: (1.0 - _roughness).clamp(0.4, 0.95)),
                primaryColor,
                secondaryColor,
                const Color(0xFF090A0C),
              ],
              stops: const [0.0, 0.35, 0.75, 1.0],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.8),
                offset: Offset(-alignX * 12, -alignY * 12),
                blurRadius: 18,
                spreadRadius: 2,
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'SPECIMEN SPHERE',
          style: TextStyle(fontFamily: 'serif', fontSize: 8.5, color: Color(0xFF94A3B8), letterSpacing: 1.0),
        ),
      ],
    );
  }

  Widget _buildSpecularCylinder(double angleDegrees, MaterialPalette material) {
    final primaryColor = material.swatches.isNotEmpty ? material.swatches[0].color : SkeuoColors.aluminumCore;
    final secondaryColor = material.swatches.length > 1 ? material.swatches[1].color : SkeuoColors.aluminumShadow;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 70,
          height: 90,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withValues(alpha: 0.8),
                primaryColor,
                secondaryColor,
                const Color(0xFF0A0C10),
              ],
              stops: const [0.0, 0.3, 0.7, 1.0],
            ),
            border: Border.all(color: Colors.white.withValues(alpha: 0.4), width: 1.2),
            boxShadow: const [
              BoxShadow(color: Color(0xBB000000), offset: Offset(3, 8), blurRadius: 14),
            ],
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'LATHE CYLINDER',
          style: TextStyle(fontFamily: 'serif', fontSize: 8.5, color: Color(0xFF94A3B8), letterSpacing: 1.0),
        ),
      ],
    );
  }
}

class _ChamberGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0x1A64748B)
      ..strokeWidth = 1.0;

    for (double x = 0; x < size.width; x += 20) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += 20) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
