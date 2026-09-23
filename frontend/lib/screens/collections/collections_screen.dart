import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/collections_provider.dart';
import '../../styles/skeuo_colors.dart';
import '../../utils/sound_helper.dart';
import '../../widgets/common/engraved_plate.dart';
import '../../widgets/common/skeuo_panel.dart';
import '../../widgets/controls/skeuo_button.dart';

class CollectionsScreen extends StatefulWidget {
  const CollectionsScreen({super.key});

  @override
  State<CollectionsScreen> createState() => _CollectionsScreenState();
}

class _CollectionsScreenState extends State<CollectionsScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _showNewDrawerDialog(BuildContext context) {
    SoundHelper.playMechanicalClick();
    _nameController.clear();
    _descController.clear();

    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        backgroundColor: const Color(0xFF1C130D),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: Color(0xFFDFB660), width: 1.5),
        ),
        title: const Center(
          child: EngravedPlate(
            title: 'NEW PARTS DRAWER',
            material: PlateMaterial.brass,
            showScrews: false,
            titleFontSize: 13,
            paddingVertical: 6,
            paddingHorizontal: 14,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              style: const TextStyle(color: Colors.white, fontSize: 13),
              decoration: InputDecoration(
                labelText: 'DRAWER DESIGNATION',
                labelStyle: const TextStyle(color: Color(0xFFDFB660), fontSize: 10, fontFamily: 'serif'),
                filled: true,
                fillColor: const Color(0xFF0F0B08),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: Color(0xFF4A3423))),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: Color(0xFFDFB660))),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _descController,
              style: const TextStyle(color: Colors.white, fontSize: 13),
              maxLines: 2,
              decoration: InputDecoration(
                labelText: 'INSTRUMENT SCHEMATIC / NOTES',
                labelStyle: const TextStyle(color: Color(0xFFDFB660), fontSize: 10, fontFamily: 'serif'),
                filled: true,
                fillColor: const Color(0xFF0F0B08),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: Color(0xFF4A3423))),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: Color(0xFFDFB660))),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: const Text('CANCEL', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 11)),
          ),
          SkeuoButton(
            label: 'COMMISSION DRAWER',
            size: SkeuoButtonSize.small,
            onPressed: () {
              if (_nameController.text.trim().isNotEmpty) {
                context.read<CollectionsProvider>().createCollection(
                      _nameController.text.trim(),
                      _descController.text.trim(),
                    );
                Navigator.pop(dialogCtx);
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final collectionsProv = context.watch<CollectionsProvider>();
    final collections = collectionsProv.collections;

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
                  title: 'PARTS DRAWERS & CONSOLES',
                  subtitle: 'Machinist Storage Bins & Custom Assemblies',
                  material: PlateMaterial.brass,
                  titleFontSize: 20,
                  subtitleFontSize: 9,
                  paddingVertical: 10,
                  paddingHorizontal: 24,
                ),
              ),
              const SizedBox(height: 14),

              // Action Bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'TOTAL ACTIVE DRAWERS: ${collections.length}',
                    style: const TextStyle(
                      fontFamily: 'serif',
                      fontSize: 9.5,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.1,
                      color: Color(0xFFD4AF37),
                    ),
                  ),
                  SkeuoButton(
                    label: '+ NEW DRAWER',
                    size: SkeuoButtonSize.small,
                    onPressed: () => _showNewDrawerDialog(context),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Drawers List
              if (collections.isEmpty)
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    child: const Text(
                      'No parts drawers currently commissioned. Pull the "+ NEW DRAWER" actuator to start filing specimens.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontFamily: 'serif', fontSize: 11, color: Color(0xFF94A3B8)),
                    ),
                  ),
                )
              else
                ...collections.map((drawer) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: SkeuoPanel(
                      material: PanelMaterial.walnut,
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Row(
                                  children: [
                                    Container(
                                      width: 10,
                                      height: 10,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: SkeuoColors.brassCore,
                                        boxShadow: [
                                          BoxShadow(color: SkeuoColors.brassGlow, blurRadius: 4),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Flexible(
                                      child: Text(
                                        drawer.name.toUpperCase(),
                                        style: const TextStyle(
                                          fontFamily: 'serif',
                                          fontSize: 12,
                                          fontWeight: FontWeight.w900,
                                          letterSpacing: 1.2,
                                          color: Color(0xFFE2B450),
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline, size: 18, color: Color(0xFFEF4444)),
                                onPressed: () => collectionsProv.deleteCollection(drawer.id),
                                tooltip: 'Decommission Drawer',
                              ),
                            ],
                          ),
                          if (drawer.description.isNotEmpty) ...[
                            const SizedBox(height: 6),
                            Text(
                              drawer.description,
                              style: const TextStyle(fontSize: 10, color: Color(0xFFCBD5E1), height: 1.3),
                            ),
                          ],
                          const SizedBox(height: 12),

                          // Badges for Components & Materials
                          Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            children: [
                              ...drawer.components.map(
                                (c) => Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF1E293B),
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(color: const Color(0xFF334155)),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.hardware, size: 10, color: Color(0xFF38BDF8)),
                                      const SizedBox(width: 4),
                                      Text(
                                        c.replaceAll('_', ' ').toUpperCase(),
                                        style: const TextStyle(fontSize: 8.5, fontWeight: FontWeight.bold, color: Color(0xFFE2E8F0)),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              ...drawer.materials.map(
                                (m) => Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF2E2211),
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(color: const Color(0xFF78561C)),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.palette, size: 10, color: Color(0xFFEAB308)),
                                      const SizedBox(width: 4),
                                      Text(
                                        m.replaceAll('_', ' ').toUpperCase(),
                                        style: const TextStyle(fontSize: 8.5, fontWeight: FontWeight.bold, color: Color(0xFFFEF08A)),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
