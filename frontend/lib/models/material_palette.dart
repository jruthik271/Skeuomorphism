import 'package:flutter/material.dart';
import '../styles/skeuo_colors.dart';
import '../styles/skeuo_gradients.dart';

enum MaterialCategory {
  metals,
  organics,
  displays,
  papers,
}

class ColorSwatchToken {
  final String name;
  final String hex;
  final Color color;
  final String role;
  final String description;

  const ColorSwatchToken({
    required this.name,
    required this.hex,
    required this.color,
    required this.role,
    required this.description,
  });

  String get flutterCode => 'Color(0x${color.toARGB32().toRadixString(16).toUpperCase()})';
  String get cssRgba => 'rgba(${color.r.round()}, ${color.g.round()}, ${color.b.round()}, ${(color.a / 255).toStringAsFixed(2)})';
}

class MaterialPalette {
  final String id;
  final String name;
  final MaterialCategory category;
  final String tag;
  final String description;
  final String reflectivity;
  final String textureType;
  final String keyLightAngle;
  final Gradient gradient;
  final Border border;
  final List<BoxShadow> shadows;
  final List<ColorSwatchToken> swatches;
  final String flutterSnippet;
  final String cssSnippet;

  const MaterialPalette({
    required this.id,
    required this.name,
    required this.category,
    required this.tag,
    required this.description,
    required this.reflectivity,
    required this.textureType,
    required this.keyLightAngle,
    required this.gradient,
    required this.border,
    required this.shadows,
    required this.swatches,
    required this.flutterSnippet,
    required this.cssSnippet,
  });

  static final List<MaterialPalette> all = [
    // 1. Machined Aluminum
    MaterialPalette(
      id: 'aluminum',
      name: 'Machined Aluminum',
      category: MaterialCategory.metals,
      tag: 'AERO 6061-T6',
      description: 'Anodized brushed aluminum featuring anisotropic specular bands, lathe bevels, and micro-groove optical sheen.',
      reflectivity: '74% Specular Spec',
      textureType: 'Brushed Lathe Grain',
      keyLightAngle: '315° Key Light',
      gradient: SkeuoGradients.brushedAluminum,
      border: Border.all(color: const Color(0xFFFFFFFF), width: 1.2),
      shadows: const [
        BoxShadow(color: Color(0x66000000), offset: Offset(1, 3), blurRadius: 6),
      ],
      swatches: const [
        ColorSwatchToken(
          name: 'Specular Highlight',
          hex: '#FFFFFF',
          color: SkeuoColors.metalSheen,
          role: '315° Rim Specular',
          description: 'Top-left bevel specular reflection',
        ),
        ColorSwatchToken(
          name: 'Metal Light Sheen',
          hex: '#E2E6EA',
          color: SkeuoColors.metalLight,
          role: 'Face Highlight',
          description: 'High reflectance lathe band',
        ),
        ColorSwatchToken(
          name: 'Metal Midtone',
          hex: '#A8B0B8',
          color: SkeuoColors.metalMid,
          role: 'Body Surface',
          description: 'Neutral brushed body tone',
        ),
        ColorSwatchToken(
          name: 'Metal Shadow Core',
          hex: '#6B737D',
          color: SkeuoColors.metalDark,
          role: 'Bottom Occlusion',
          description: 'Opposite diffuse shadow core',
        ),
        ColorSwatchToken(
          name: 'Bevel Shadow',
          hex: '#22252A',
          color: SkeuoColors.metalBevel,
          role: 'Contact Lip',
          description: 'Dark perimeter chamfer cut',
        ),
      ],
      flutterSnippet: '''BoxDecoration(
  gradient: LinearGradient(
    begin: Alignment(-0.8, -1.0),
    end: Alignment(0.8, 1.0),
    colors: [
      Color(0xFFE6EAEF),
      Color(0xFFBFC6CE),
      Color(0xFFDFE4EB),
      Color(0xFFA6AFB8),
      Color(0xFFCDD4DC),
      Color(0xFF8E97A2),
      Color(0xFFB8C0CA),
    ],
    stops: [0.0, 0.18, 0.38, 0.55, 0.72, 0.88, 1.0],
  ),
  border: Border.all(color: Colors.white, width: 1.2),
  boxShadow: [
    BoxShadow(color: Color(0x66000000), offset: Offset(1, 3), blurRadius: 6),
  ],
)''',
      cssSnippet: '''background: linear-gradient(135deg, 
  #E6EAEF 0%, #BFC6CE 18%, #DFE4EB 38%, 
  #A6AFB8 55%, #CDD4DC 72%, #8E97A2 88%, #B8C0CA 100%);
border: 1.2px solid rgba(255, 255, 255, 0.9);
box-shadow: 1px 3px 6px rgba(0, 0, 0, 0.4);''',
    ),

    // 2. Dark Walnut Wood
    MaterialPalette(
      id: 'walnut',
      name: 'Dark Walnut Timber',
      category: MaterialCategory.organics,
      tag: 'SOLID TIMBER',
      description: 'Substantial furniture-grade dark American walnut with hand-rubbed oil finish, visible fibrous grain lines, and warm amber undertones.',
      reflectivity: '18% Satin Luster',
      textureType: 'Longitudinal Hardwood Grain',
      keyLightAngle: '315° Ambient Diffuse',
      gradient: SkeuoGradients.walnutChassis,
      border: Border.all(color: const Color(0xFF452C1E), width: 1.5),
      shadows: const [
        BoxShadow(color: Color(0xDD000000), offset: Offset(2, 6), blurRadius: 14),
      ],
      swatches: const [
        ColorSwatchToken(
          name: 'Walnut Highlight',
          hex: '#5E3D2A',
          color: SkeuoColors.walnutHighlight,
          role: 'Bevel Highlight',
          description: 'Top edge oiled wood reflection',
        ),
        ColorSwatchToken(
          name: 'Walnut Light',
          hex: '#452C1E',
          color: SkeuoColors.walnutLight,
          role: 'Upper Surface',
          description: 'Sunlit timber surface tone',
        ),
        ColorSwatchToken(
          name: 'Walnut Medium',
          hex: '#2E1E14',
          color: SkeuoColors.walnutMedium,
          role: 'Body Grain',
          description: 'Core seasoned walnut wood',
        ),
        ColorSwatchToken(
          name: 'Walnut Dark',
          hex: '#1F140D',
          color: SkeuoColors.walnutDark,
          role: 'Grain Groove',
          description: 'Fibrous dark heartwood ring',
        ),
        ColorSwatchToken(
          name: 'Walnut Deep Core',
          hex: '#140D08',
          color: SkeuoColors.walnutDeep,
          role: 'Base Chassis',
          description: 'Heavy shadow boundary of timber',
        ),
      ],
      flutterSnippet: '''BoxDecoration(
  gradient: LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF452C1E),
      Color(0xFF2E1E14),
      Color(0xFF1F140D),
      Color(0xFF140D08),
    ],
    stops: [0.0, 0.15, 0.7, 1.0],
  ),
  border: Border.all(color: Color(0xFF452C1E), width: 1.5),
  boxShadow: [
    BoxShadow(color: Color(0xDD000000), offset: Offset(2, 6), blurRadius: 14),
  ],
)''',
      cssSnippet: '''background: linear-gradient(180deg, 
  #452C1E 0%, #2E1E14 15%, #1F140D 70%, #140D08 100%);
border: 1.5px solid #452C1E;
box-shadow: 2px 6px 14px rgba(0, 0, 0, 0.86);''',
    ),

    // 3. Antique Turned Brass
    MaterialPalette(
      id: 'brass',
      name: 'Antique Turned Brass',
      category: MaterialCategory.metals,
      tag: 'C360 BRASS',
      description: 'Solid machined maritime brass with warm golden luminescence, hand-polished high points, and aged oxide shadows.',
      reflectivity: '82% Metallic Specular',
      textureType: 'Concentric Lathe Tooling',
      keyLightAngle: '315° Radial Specular',
      gradient: SkeuoGradients.antiqueBrass,
      border: Border.all(color: SkeuoColors.brassHighlight, width: 1.2),
      shadows: const [
        BoxShadow(color: Color(0x99000000), offset: Offset(2, 4), blurRadius: 8),
      ],
      swatches: const [
        ColorSwatchToken(
          name: 'Brass Highlight',
          hex: '#FBE6A2',
          color: SkeuoColors.brassHighlight,
          role: 'Specular Glint',
          description: 'Pure polished brass reflection',
        ),
        ColorSwatchToken(
          name: 'Brass Light Gold',
          hex: '#DFB660',
          color: SkeuoColors.brassLight,
          role: 'Upper Bevel',
          description: 'Warm reflective yellow gold',
        ),
        ColorSwatchToken(
          name: 'Brass Core Midtone',
          hex: '#B58832',
          color: SkeuoColors.brassMid,
          role: 'Body Surface',
          description: 'Aged golden bronze alloy body',
        ),
        ColorSwatchToken(
          name: 'Brass Dark Patina',
          hex: '#735016',
          color: SkeuoColors.brassDark,
          role: 'Shadow Trough',
          description: 'Oxidized dark bronze groove',
        ),
        ColorSwatchToken(
          name: 'Brass Deep Shadow',
          hex: '#3B2707',
          color: SkeuoColors.brassShadow,
          role: 'Contact Rim',
          description: 'Cavity ambient shadow',
        ),
      ],
      flutterSnippet: '''BoxDecoration(
  gradient: LinearGradient(
    begin: Alignment(-0.9, -1.0),
    end: Alignment(0.9, 1.0),
    colors: [
      Color(0xFFFBE6A2),
      Color(0xFFDFB660),
      Color(0xFFB58832),
      Color(0xFFFBE6A2),
      Color(0xFF735016),
      Color(0xFFB58832),
    ],
    stops: [0.0, 0.22, 0.48, 0.65, 0.85, 1.0],
  ),
  border: Border.all(color: Color(0xFFFBE6A2), width: 1.2),
)''',
      cssSnippet: '''background: linear-gradient(145deg, 
  #FBE6A2 0%, #DFB660 22%, #B58832 48%, 
  #FBE6A2 65%, #735016 85%, #B58832 100%);
border: 1.2px solid #FBE6A2;
box-shadow: 2px 4px 8px rgba(0, 0, 0, 0.6);''',
    ),

    // 4. Industrial Copper
    MaterialPalette(
      id: 'copper',
      name: 'Industrial Copper',
      category: MaterialCategory.metals,
      tag: 'C110 COPPER',
      description: 'High-purity industrial copper paneling with intense fiery red-orange specular highlights and burnished bronze depth.',
      reflectivity: '78% Metallic Flare',
      textureType: 'Cross-Hatch Tooling',
      keyLightAngle: '315° Warm Glint',
      gradient: SkeuoGradients.copper,
      border: Border.all(color: SkeuoColors.copperHighlight, width: 1.2),
      shadows: const [
        BoxShadow(color: Color(0x99000000), offset: Offset(2, 4), blurRadius: 8),
      ],
      swatches: const [
        ColorSwatchToken(
          name: 'Copper Highlight',
          hex: '#FFBFA3',
          color: SkeuoColors.copperHighlight,
          role: 'Peak Specular',
          description: 'Radiant pink-gold copper sheen',
        ),
        ColorSwatchToken(
          name: 'Copper Light',
          hex: '#E08B63',
          color: SkeuoColors.copperLight,
          role: 'Body Sheen',
          description: 'Vibrant salmon-copper reflection',
        ),
        ColorSwatchToken(
          name: 'Copper Midtone',
          hex: '#B35933',
          color: SkeuoColors.copperMid,
          role: 'Core Metal',
          description: 'Rich burnished copper metal',
        ),
        ColorSwatchToken(
          name: 'Copper Dark',
          hex: '#6E3117',
          color: SkeuoColors.copperDark,
          role: 'Contact Shadow',
          description: 'Deep fire-treated patina shadow',
        ),
      ],
      flutterSnippet: '''BoxDecoration(
  gradient: LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFFBFA3),
      Color(0xFFE08B63),
      Color(0xFFB35933),
      Color(0xFFFFBFA3),
      Color(0xFF6E3117),
    ],
    stops: [0.0, 0.25, 0.55, 0.75, 1.0],
  ),
  border: Border.all(color: Color(0xFFFFBFA3), width: 1.2),
)''',
      cssSnippet: '''background: linear-gradient(135deg, 
  #FFBFA3 0%, #E08B63 25%, #B35933 55%, #FFBFA3 75%, #6E3117 100%);
border: 1.2px solid #FFBFA3;''',
    ),

    // 5. Cast Iron & Gunmetal Titanium
    MaterialPalette(
      id: 'gunmetal',
      name: 'Cast Iron & Gunmetal',
      category: MaterialCategory.metals,
      tag: 'TITANIUM BLACK',
      description: 'Heavy tactical military instrumentation metal: low-gloss matte powder coat, charcoal depth, and machined dark chamfers.',
      reflectivity: '12% Low-Sheen Diffuse',
      textureType: 'Fine Sandblast Texture',
      keyLightAngle: '315° Low-Contrast Glint',
      gradient: SkeuoGradients.darkGunmetal,
      border: Border.all(color: SkeuoColors.charcoalBevel, width: 1.2),
      shadows: const [
        BoxShadow(color: Color(0xDD000000), offset: Offset(2, 5), blurRadius: 10),
      ],
      swatches: const [
        ColorSwatchToken(
          name: 'Gunmetal Rim',
          hex: '#50565E',
          color: SkeuoColors.charcoalBevel,
          role: 'Rim Highlight',
          description: 'Subtle titanium edge highlight',
        ),
        ColorSwatchToken(
          name: 'Charcoal Face',
          hex: '#383D42',
          color: SkeuoColors.charcoalBorder,
          role: 'Face Gradient',
          description: 'Dark matte sandblast surface',
        ),
        ColorSwatchToken(
          name: 'Cast Iron Mid',
          hex: '#24272B',
          color: SkeuoColors.charcoalSurface,
          role: 'Chassis Body',
          description: 'Dense structural cast iron',
        ),
        ColorSwatchToken(
          name: 'Chassis Deep',
          hex: '#181B1E',
          color: SkeuoColors.charcoalDeep,
          role: 'Recessed Groove',
          description: 'Cavity shadow depth',
        ),
        ColorSwatchToken(
          name: 'Obsidian Black',
          hex: '#0F1113',
          color: SkeuoColors.charcoalBlack,
          role: 'Contact Occlusion',
          description: 'Zero-reflection inner lip',
        ),
      ],
      flutterSnippet: '''BoxDecoration(
  gradient: LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF42474E),
      Color(0xFF2B2F34),
      Color(0xFF383D43),
      Color(0xFF1E2124),
      Color(0xFF31363C),
    ],
    stops: [0.0, 0.25, 0.5, 0.75, 1.0],
  ),
  border: Border.all(color: Color(0xFF50565E), width: 1.2),
  boxShadow: [
    BoxShadow(color: Color(0xDD000000), offset: Offset(2, 5), blurRadius: 10),
  ],
)''',
      cssSnippet: '''background: linear-gradient(135deg, 
  #42474E 0%, #2B2F34 25%, #383D43 50%, #1E2124 75%, #31363C 100%);
border: 1.2px solid #50565E;
box-shadow: 2px 5px 10px rgba(0, 0, 0, 0.86);''',
    ),

    // 6. Saddle Stitched Leather
    MaterialPalette(
      id: 'leather',
      name: 'Saddle Stitched Leather',
      category: MaterialCategory.organics,
      tag: 'TUSCAN LEATHER',
      description: 'Vegetable-tanned full grain saddle leather with warm amber wax edge burnishing, micro-crease depth, and golden saddle-stitch accents.',
      reflectivity: '22% Waxy Sheen',
      textureType: 'Pebbled Grain Hide',
      keyLightAngle: '315° Organic Specular',
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          SkeuoColors.leatherHighlight,
          SkeuoColors.leatherMid,
          SkeuoColors.leatherDark,
          SkeuoColors.leatherDeep,
        ],
        stops: [0.0, 0.3, 0.7, 1.0],
      ),
      border: Border.all(color: SkeuoColors.leatherHighlight, width: 1.2),
      shadows: const [
        BoxShadow(color: Color(0xBB000000), offset: Offset(2, 5), blurRadius: 10),
      ],
      swatches: const [
        ColorSwatchToken(
          name: 'Leather Wax Highlight',
          hex: '#523B2B',
          color: SkeuoColors.leatherHighlight,
          role: 'Crown Highlight',
          description: 'Oiled surface crest reflection',
        ),
        ColorSwatchToken(
          name: 'Saddle Midtone',
          hex: '#3B2A1E',
          color: SkeuoColors.leatherMid,
          role: 'Hide Surface',
          description: 'Rich chestnut tan leather body',
        ),
        ColorSwatchToken(
          name: 'Leather Deep Crease',
          hex: '#281C14',
          color: SkeuoColors.leatherDark,
          role: 'Grain Groove',
          description: 'Natural dermal grain crease',
        ),
        ColorSwatchToken(
          name: 'Burnished Edge',
          hex: '#1A120D',
          color: SkeuoColors.leatherDeep,
          role: 'Edge Lip',
          description: 'Dark heat-burnished rim',
        ),
        ColorSwatchToken(
          name: 'Waxed Thread Stitch',
          hex: '#D8AA56',
          color: SkeuoColors.leatherStitch,
          role: 'Contrast Stitch',
          description: 'Braided flax saddle stitch',
        ),
      ],
      flutterSnippet: '''BoxDecoration(
  gradient: LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF523B2B),
      Color(0xFF3B2A1E),
      Color(0xFF281C14),
      Color(0xFF1A120D),
    ],
    stops: [0.0, 0.3, 0.7, 1.0],
  ),
  border: Border.all(color: Color(0xFF523B2B), width: 1.2),
)''',
      cssSnippet: '''background: linear-gradient(135deg, 
  #523B2B 0%, #3B2A1E 30%, #281C14 70%, #1A120D 100%);
border: 1.2px solid #523B2B;''',
    ),

    // 7. Aged Ledger Paper & Parchment
    MaterialPalette(
      id: 'paper',
      name: 'Aged Ledger Parchment',
      category: MaterialCategory.papers,
      tag: 'COTTON RAG',
      description: 'Heavyweight cream archival ledger paper with tactile pulp texture, faint cyan ruled guide lines, and debossed letterpress printing.',
      reflectivity: '8% Diffuse Matte',
      textureType: 'Cotton Fiber Deckle',
      keyLightAngle: '315° Ambient Soft',
      gradient: const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          SkeuoColors.paperIvory,
          SkeuoColors.paperAged,
          SkeuoColors.paperShadow,
        ],
        stops: [0.0, 0.7, 1.0],
      ),
      border: Border.all(color: SkeuoColors.paperShadow, width: 1.0),
      shadows: const [
        BoxShadow(color: Color(0x33000000), offset: Offset(2, 4), blurRadius: 8),
      ],
      swatches: const [
        ColorSwatchToken(
          name: 'Ivory Cream Pulp',
          hex: '#FAF7EE',
          color: SkeuoColors.paperIvory,
          role: 'Primary Sheet',
          description: 'Aged cotton paper face',
        ),
        ColorSwatchToken(
          name: 'Warm Patina Tint',
          hex: '#EBE3D0',
          color: SkeuoColors.paperAged,
          role: 'Lower Gradient',
          description: 'Sunlight oxidized paper edge',
        ),
        ColorSwatchToken(
          name: 'Deckle Edge Shadow',
          hex: '#D4CABA',
          color: SkeuoColors.paperShadow,
          role: 'Bevel Rim',
          description: 'Torn fiber contact shadow',
        ),
        ColorSwatchToken(
          name: 'Ruled Cyan Guide',
          hex: '#446688',
          color: SkeuoColors.paperRuledLine,
          role: 'Ruling Line',
          description: 'Faint accountant grid ruling',
        ),
        ColorSwatchToken(
          name: 'Letterpress Ink',
          hex: '#2B2620',
          color: SkeuoColors.paperInk,
          role: 'Debossed Ink',
          description: 'Deep carbon stamp ink',
        ),
      ],
      flutterSnippet: '''BoxDecoration(
  color: Color(0xFFFAF7EE),
  borderRadius: BorderRadius.circular(4),
  border: Border.all(color: Color(0xFFD4CABA), width: 1.0),
  boxShadow: [
    BoxShadow(color: Color(0x33000000), offset: Offset(2, 4), blurRadius: 8),
  ],
)''',
      cssSnippet: '''background-color: #FAF7EE;
border: 1px solid #D4CABA;
box-shadow: 2px 4px 8px rgba(0, 0, 0, 0.2);''',
    ),

    // 8. Cathode Green Phosphor LCD
    MaterialPalette(
      id: 'phosphor',
      name: 'Cathode Green Phosphor',
      category: MaterialCategory.displays,
      tag: 'P31 PHOSPHOR',
      description: 'Monochrome cathode ray tube / backlit matrix LCD display with P31 zinc sulfide green persistent glow and scanlines.',
      reflectivity: '5% Absorptive Matrix',
      textureType: 'CRT Scanline Matrix',
      keyLightAngle: 'Internal Luminescence',
      gradient: const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF0E1A11),
          Color(0xFF070E08),
        ],
      ),
      border: Border.all(color: const Color(0xFF040805), width: 1.5),
      shadows: const [
        BoxShadow(color: Color(0x6639FF14), blurRadius: 10, spreadRadius: -2),
      ],
      swatches: const [
        ColorSwatchToken(
          name: 'Phosphor Peak Beam',
          hex: '#39FF14',
          color: SkeuoColors.lcdPixelOn,
          role: 'Active Pixel',
          description: 'Direct cathode electron impact',
        ),
        ColorSwatchToken(
          name: 'Optical Bloom Glow',
          hex: '#6639FF14',
          color: SkeuoColors.lcdPixelGlow,
          role: 'Halo Radiance',
          description: 'Photonic glass bloom halo',
        ),
        ColorSwatchToken(
          name: 'Latent Matrix Ghost',
          hex: '#18381C',
          color: SkeuoColors.lcdPixelDim,
          role: 'Inactive Segment',
          description: 'Unenergized LCD liquid crystals',
        ),
        ColorSwatchToken(
          name: 'Cathode Cavity Well',
          hex: '#0E1A11',
          color: SkeuoColors.lcdScreenBg,
          role: 'Screen Substrate',
          description: 'Absorptive polarization layer',
        ),
      ],
      flutterSnippet: '''BoxDecoration(
  color: Color(0xFF0E1A11),
  borderRadius: BorderRadius.circular(4),
  border: Border.all(color: Color(0xFF040805), width: 1.5),
  boxShadow: [
    BoxShadow(color: Color(0x4439FF14), blurRadius: 8),
  ],
)''',
      cssSnippet: '''background-color: #0E1A11;
color: #39FF14;
text-shadow: 0 0 8px rgba(57, 255, 20, 0.6);
border: 1.5px solid #040805;''',
    ),

    // 9. Amber VFD Vacuum Tube
    MaterialPalette(
      id: 'amberVfd',
      name: 'Amber VFD Vacuum Tube',
      category: MaterialCategory.displays,
      tag: 'INCANDESCENT',
      description: 'Warm incandescent neon amber vacuum fluorescent filament glow with deep umber cavity backing and glass lens reflection.',
      reflectivity: '8% Recessed Chamber',
      textureType: 'Incandescent Filament',
      keyLightAngle: 'Internal Filament Bloom',
      gradient: const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF2E1906),
          Color(0xFF140B03),
        ],
      ),
      border: Border.all(color: const Color(0xFF1F1004), width: 1.5),
      shadows: const [
        BoxShadow(color: Color(0x66FFB703), blurRadius: 10, spreadRadius: -2),
      ],
      swatches: const [
        ColorSwatchToken(
          name: 'Neon Amber Beam',
          hex: '#FFB703',
          color: SkeuoColors.amberPixelOn,
          role: 'Filament Discharge',
          description: 'Ionized gas discharge glow',
        ),
        ColorSwatchToken(
          name: 'Amber Bloom Aura',
          hex: '#66FFB703',
          color: SkeuoColors.amberPixelGlow,
          role: 'Optical Dispersion',
          description: 'Warm radial amber illumination',
        ),
        ColorSwatchToken(
          name: 'Latent Amber Dim',
          hex: '#4A3008',
          color: SkeuoColors.amberPixelDim,
          role: 'Dim Segment',
          description: 'Idle filament grid wire',
        ),
        ColorSwatchToken(
          name: 'Vacuum Chamber',
          hex: '#1F1306',
          color: SkeuoColors.amberLcdBg,
          role: 'Anode Backing',
          description: 'Anti-reflective backing well',
        ),
      ],
      flutterSnippet: '''BoxDecoration(
  color: Color(0xFF1F1306),
  borderRadius: BorderRadius.circular(4),
  border: Border.all(color: Color(0xFF1F1004), width: 1.5),
  boxShadow: [
    BoxShadow(color: Color(0x44FFB703), blurRadius: 8),
  ],
)''',
      cssSnippet: '''background-color: #1F1306;
color: #FFB703;
text-shadow: 0 0 8px rgba(255, 183, 3, 0.6);
border: 1.5px solid #1F1004;''',
    ),

    // 10. Jewel LED Optical Indicators
    MaterialPalette(
      id: 'jewelLed',
      name: 'Faceted Jewel LEDs',
      category: MaterialCategory.displays,
      tag: 'GALLIUM ARSENIDE',
      description: 'Cut jewel dome glass lenses with concentric internal reflectors, directional optical refraction, and radiating spherical bloom.',
      reflectivity: '90% Optical Glass',
      textureType: 'Faceted Glass Crown',
      keyLightAngle: '315° Lens Apex Specular',
      gradient: const RadialGradient(
        center: Alignment(-0.3, -0.3),
        radius: 0.85,
        colors: [
          Colors.white,
          SkeuoColors.ledRedOn,
          SkeuoColors.ledRedOff,
        ],
      ),
      border: Border.all(color: const Color(0xFF2B2F34), width: 1.0),
      shadows: const [
        BoxShadow(color: Color(0x99FF2A2A), blurRadius: 10, spreadRadius: 2),
      ],
      swatches: const [
        ColorSwatchToken(
          name: 'Signal Red Active',
          hex: '#FF2A2A',
          color: SkeuoColors.ledRedOn,
          role: 'Alarm / Power',
          description: 'Gallium phosphide ruby emission',
        ),
        ColorSwatchToken(
          name: 'Status Green Active',
          hex: '#00FF66',
          color: SkeuoColors.ledGreenOn,
          role: 'System Ready',
          description: 'Emerald green optical emission',
        ),
        ColorSwatchToken(
          name: 'Telemetry Amber Active',
          hex: '#FF9E00',
          color: SkeuoColors.ledAmberOn,
          role: 'Caution Alert',
          description: 'High-intensity amber warning',
        ),
        ColorSwatchToken(
          name: 'Carrier Blue Active',
          hex: '#00C8FF',
          color: SkeuoColors.ledBlueOn,
          role: 'RF Link / Data',
          description: 'Indium gallium nitride blue',
        ),
      ],
      flutterSnippet: '''BoxDecoration(
  shape: BoxShape.circle,
  gradient: RadialGradient(
    center: Alignment(-0.3, -0.3),
    radius: 0.85,
    colors: [Colors.white, Color(0xFFFF2A2A), Color(0xFF4D0D0D)],
  ),
  boxShadow: [
    BoxShadow(color: Color(0x99FF2A2A), blurRadius: 10, spreadRadius: 2),
  ],
)''',
      cssSnippet: '''background: radial-gradient(circle at 35% 35%, 
  #FFFFFF 0%, #FF2A2A 60%, #4D0D0D 100%);
border-radius: 50%;
box-shadow: 0 0 10px rgba(255, 42, 42, 0.7);''',
    ),
  ];
}

typedef MaterialPalettes = MaterialPalette;
