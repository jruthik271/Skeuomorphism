import dotenv from 'dotenv';
dotenv.config();

import { connectDB } from '../config/db';
import { User } from '../models/User';
import { Material } from '../models/Material';
import { Component } from '../models/Component';
import { Collection } from '../models/Collection';
import { Activity, AnalyticsStat } from '../models/Analytics';

export const seedDatabase = async (): Promise<void> => {
  console.log('[Seed] Calibrating SkeuoLab laboratory instruments & database...');

  // Ensure DB connection
  await connectDB();

  // 1. Clear existing seed records to ensure clean factory calibration
  try {
    await Promise.all([
      User.deleteMany({}),
      Material.deleteMany({}),
      Component.deleteMany({}),
      Collection.deleteMany({}),
      Activity.deleteMany({}),
      AnalyticsStat.deleteMany({}),
    ]);
    console.log('[Seed] Laboratory benches cleared for factory calibration.');
  } catch (err: any) {
    console.warn('[Seed] Warning clearing collections:', err.message);
  }

  // 2. Create Default Users
  const adminUser = await User.create({
    name: 'Chief Instrument Engineer',
    email: 'admin@skeuolab.com',
    password: 'AdminPass123!',
    role: 'ADMIN',
    avatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=256&q=80',
    stats: {
      interactions: 124,
      savedMaterials: 14,
      savedComponents: 15,
      collectionsCount: 3,
    },
  });

  const standardUser = await User.create({
    name: 'Apprentice Operator',
    email: 'user@skeuolab.com',
    password: 'UserPass123!',
    role: 'USER',
    avatar: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=256&q=80',
    stats: {
      interactions: 42,
      savedMaterials: 6,
      savedComponents: 8,
      collectionsCount: 1,
    },
  });

  console.log(`[Seed] Commissioned operators: ${adminUser.email} (ADMIN), ${standardUser.email} (USER)`);

  // 3. Create 14 Core Skeuomorphic Materials
  const materialsData = [
    {
      name: 'Brushed Brass',
      category: 'metals',
      description: 'Warm, hand-lathed metallurgical brass with anisotropic specular reflection highlights and deep beveled chamfers.',
      tag: 'METALLURGY',
      reflectivity: '68% Specular Anisotropic',
      textureType: 'Hairline Lathe Machined',
      keyLightAngle: '315° Key Light (Specular Highlight)',
      roughness: 0.28,
      metallic: 0.88,
      swatches: [
        { name: 'Specular Rim', hex: '#FFE8A3', role: 'Top Rim Highlight', description: 'Beveled top rim capturing directional sunlight' },
        { name: 'Warm Body', hex: '#D4AF37', role: 'Main Face Metal', description: 'Golden brass alloy core tone' },
        { name: 'Deep Shadow', hex: '#7A5E12', role: 'Bottom Drop Shadow', description: 'Heavy ambient occlusion undercut' },
      ],
      gradientCSS: 'linear-gradient(135deg, #FFE8A3 0%, #D4AF37 50%, #7A5E12 100%)',
      flutterSnippet: 'LinearGradient(colors: [Color(0xFFFFE8A3), Color(0xFFD4AF37), Color(0xFF7A5E12)], begin: Alignment.topLeft, end: Alignment.bottomRight)',
      cssSnippet: 'background: linear-gradient(135deg, #FFE8A3 0%, #D4AF37 50%, #7A5E12 100%);\nbox-shadow: inset 1px 1px 2px rgba(255,255,255,0.7), inset -2px -2px 3px rgba(0,0,0,0.5), 0 8px 16px rgba(0,0,0,0.4);',
      isDefault: true,
      createdBy: adminUser._id,
    },
    {
      name: 'Anodized Aluminum',
      category: 'metals',
      description: 'Precision CNC-machined aerospace alloy with continuous horizontal brush marks and crisp diamond-turned edges.',
      tag: 'AEROSPACE',
      reflectivity: '82% Specular Metallic',
      textureType: 'Horizontal Hairline Brushed',
      keyLightAngle: '0° Anisotropic Highlight',
      roughness: 0.22,
      metallic: 0.95,
      swatches: [
        { name: 'Silver Peak', hex: '#FFFFFF', role: 'Edge Sheen', description: 'Diamond cut mirror border' },
        { name: 'Brushed Core', hex: '#D1D5DB', role: 'Plate Body', description: 'Cool gray anodized surface' },
        { name: 'Dark Mill', hex: '#4B5563', role: 'Groove Undercut', description: 'Milled mounting recess' },
      ],
      gradientCSS: 'linear-gradient(180deg, #FFFFFF 0%, #E5E7EB 25%, #9CA3AF 75%, #4B5563 100%)',
      flutterSnippet: 'LinearGradient(colors: [Color(0xFFFFFFFF), Color(0xFFE5E7EB), Color(0xFF9CA3AF), Color(0xFF4B5563)], begin: Alignment.topCenter, end: Alignment.bottomCenter)',
      cssSnippet: 'background: linear-gradient(180deg, #FFFFFF 0%, #E5E7EB 25%, #9CA3AF 75%, #4B5563 100%);\nbox-shadow: inset 0 1px 0 rgba(255,255,255,0.9), inset 0 -1px 2px rgba(0,0,0,0.4);',
      isDefault: true,
      createdBy: adminUser._id,
    },
    {
      name: 'Vintage Bakelite',
      category: 'organics',
      description: 'Deep glossy amber-black thermoset phenol formaldehyde resin with authentic 1930s compression mold swirl.',
      tag: 'VINTAGE',
      reflectivity: '75% High Gloss Polymeric',
      textureType: 'Compression Molded Resin',
      keyLightAngle: '270° Ambient Soft Glow',
      roughness: 0.15,
      metallic: 0.05,
      swatches: [
        { name: 'Surface Gloss', hex: '#3E2723', role: 'Curved Reflection', description: 'Smooth polished resin crest' },
        { name: 'Resin Body', hex: '#1C120C', role: 'Phenolic Substrate', description: 'Ultra-dense dark vintage core' },
        { name: 'Occ Shadow', hex: '#0B0704', role: 'Chassis Inset', description: 'Subsurface phenolic depth' },
      ],
      gradientCSS: 'radial-gradient(circle at 35% 30%, #4E342E 0%, #1C120C 70%, #0B0704 100%)',
      flutterSnippet: 'RadialGradient(center: Alignment(-0.3, -0.4), colors: [Color(0xFF4E342E), Color(0xFF1C120C), Color(0xFF0B0704)])',
      cssSnippet: 'background: radial-gradient(circle at 35% 30%, #4E342E 0%, #1C120C 70%, #0B0704 100%);\nbox-shadow: 0 12px 24px rgba(0,0,0,0.8), inset 0 2px 4px rgba(255,255,255,0.15);',
      isDefault: true,
      createdBy: adminUser._id,
    },
    {
      name: 'American Walnut',
      category: 'organics',
      description: 'Hand-rubbed oiled timber with pronounced organic cathedral grain and tactile satin polyurethane sheen.',
      tag: 'CABINETRY',
      reflectivity: '24% Semi-Gloss Satin',
      textureType: 'Cathedral Hardwood Grain',
      keyLightAngle: '315° Warm Studio Light',
      roughness: 0.65,
      metallic: 0.0,
      swatches: [
        { name: 'Sapwood Light', hex: '#8D5B34', role: 'Pore Highlight', description: 'Oiled grain crown' },
        { name: 'Heartwood', hex: '#54361C', role: 'Timber Meat', description: 'Solid walnut core mass' },
        { name: 'Grain Ring', hex: '#2A180B', role: 'Annual Ring Pore', description: 'Deep dark cellular growth line' },
      ],
      gradientCSS: 'linear-gradient(90deg, #54361C 0%, #8D5B34 30%, #54361C 60%, #3D2310 100%)',
      flutterSnippet: 'LinearGradient(colors: [Color(0xFF54361C), Color(0xFF8D5B34), Color(0xFF54361C), Color(0xFF3D2310)], begin: Alignment.centerLeft, end: Alignment.centerRight)',
      cssSnippet: 'background: linear-gradient(90deg, #54361C 0%, #8D5B34 30%, #54361C 60%, #3D2310 100%);\nbox-shadow: inset 0 2px 3px rgba(255,255,255,0.1), 0 10px 20px rgba(0,0,0,0.6);',
      isDefault: true,
      createdBy: adminUser._id,
    },
    {
      name: 'Electrolytic Copper',
      category: 'metals',
      description: 'Refined conductive copper foil with bright salmon-pink specular sheen and slight thermal patina.',
      tag: 'ELECTRICAL',
      reflectivity: '85% Warm Specular',
      textureType: 'Rolled Busbar Sheen',
      keyLightAngle: '315° Directional Sunlight',
      roughness: 0.20,
      metallic: 0.96,
      swatches: [
        { name: 'Copper Gleam', hex: '#FFBE98', role: 'Faceted Ridge', description: 'Pure reflective conductor' },
        { name: 'Raw Metal', hex: '#C86432', role: 'Busbar Surface', description: 'Industrial red copper' },
        { name: 'Oxide Shadow', hex: '#63230E', role: 'Contact Groove', description: 'Thermal aged crease' },
      ],
      gradientCSS: 'linear-gradient(135deg, #FFBE98 0%, #C86432 50%, #63230E 100%)',
      flutterSnippet: 'LinearGradient(colors: [Color(0xFFFFBE98), Color(0xFFC86432), Color(0xFF63230E)], begin: Alignment.topLeft, end: Alignment.bottomRight)',
      cssSnippet: 'background: linear-gradient(135deg, #FFBE98 0%, #C86432 50%, #63230E 100%);\nbox-shadow: inset 1px 1px 3px rgba(255,255,255,0.8), 0 6px 14px rgba(99,35,14,0.4);',
      isDefault: true,
      createdBy: adminUser._id,
    },
    {
      name: 'Amber Borosilicate Glass',
      category: 'glass',
      description: 'Optical filter glass with high refraction index, internal chromatic dispersion, and warm 590nm glow absorption.',
      tag: 'OPTICAL',
      reflectivity: '94% Fresnel Dielectric',
      textureType: 'Blown Glass Envelope',
      keyLightAngle: 'Fresnel Peripheral Rim',
      roughness: 0.05,
      metallic: 0.0,
      swatches: [
        { name: 'Fresnel Crest', hex: '#FFF3D6', role: 'Specular Glint', description: 'Curved glass reflection highlight' },
        { name: 'Amber Core', hex: '#D97706', role: 'Refractive Filter', description: 'Warm tube illumination filter' },
        { name: 'Absorption Rim', hex: '#451A03', role: 'Perimeter Meniscus', description: 'Total internal reflection boundary' },
      ],
      gradientCSS: 'radial-gradient(circle at 40% 30%, rgba(255,243,214,0.7) 0%, rgba(217,119,6,0.5) 60%, rgba(69,26,3,0.9) 100%)',
      flutterSnippet: 'RadialGradient(center: Alignment(-0.2, -0.4), colors: [Color(0xB3FFF3D6), Color(0x80D97706), Color(0xE6451A03)])',
      cssSnippet: 'background: radial-gradient(circle at 40% 30%, rgba(255,243,214,0.7) 0%, rgba(217,119,6,0.5) 60%, rgba(69,26,3,0.9) 100%);\nbackdrop-filter: blur(8px);\nborder: 1px solid rgba(255,255,255,0.3);',
      isDefault: true,
      createdBy: adminUser._id,
    },
    {
      name: 'Galvanized Steel Rivet',
      category: 'metals',
      description: 'Cold-formed structural fastener with zinc spangle crystal texture and heavy hemispherical dome profile.',
      tag: 'FASTENERS',
      reflectivity: '45% Diffuse Metallic',
      textureType: 'Zinc Spangle Crystal',
      keyLightAngle: '315° Hard Sun',
      roughness: 0.40,
      metallic: 0.85,
      swatches: [
        { name: 'Rivet Peak', hex: '#E2E8F0', role: 'Dome Crest', description: 'Hemispherical high point' },
        { name: 'Zinc Flake', hex: '#94A3B8', role: 'Fastener Body', description: 'Cold galvanized steel' },
        { name: 'Hole Shadow', hex: '#1E293B', role: 'Counterbore Sink', description: 'Sheet metal hole occlusion' },
      ],
      gradientCSS: 'radial-gradient(circle at 35% 35%, #FFFFFF 0%, #94A3B8 50%, #334155 90%, #0F172A 100%)',
      flutterSnippet: 'RadialGradient(center: Alignment(-0.3, -0.3), colors: [Color(0xFFFFFFFF), Color(0xFF94A3B8), Color(0xFF334155), Color(0xFF0F172A)])',
      cssSnippet: 'background: radial-gradient(circle at 35% 35%, #FFFFFF 0%, #94A3B8 50%, #334155 90%, #0F172A 100%);\nbox-shadow: 2px 3px 5px rgba(0,0,0,0.6), inset -1px -1px 2px rgba(0,0,0,0.5);',
      isDefault: true,
      createdBy: adminUser._id,
    },
    {
      name: 'Slate Concrete Panel',
      category: 'metals',
      description: 'Heavy mineral substrate with aggregate micro-pitting, high acoustic damping, and matte low-specular finish.',
      tag: 'SUBSTRATE',
      reflectivity: '12% Diffuse Mineral',
      textureType: 'Porous Cast Mineral',
      keyLightAngle: 'Diffuse Ambient',
      roughness: 0.90,
      metallic: 0.05,
      swatches: [
        { name: 'Mineral Dust', hex: '#64748B', role: 'Surface Grain', description: 'Exposed fine aggregate' },
        { name: 'Base Slate', hex: '#334155', role: 'Panel Mass', description: 'Vibration absorbing chassis' },
        { name: 'Deep Pit', hex: '#0F172A', role: 'Pore Cavity', description: 'Micropore shadow trap' },
      ],
      gradientCSS: 'linear-gradient(145deg, #334155 0%, #1E293B 100%)',
      flutterSnippet: 'LinearGradient(colors: [Color(0xFF334155), Color(0xFF1E293B)], begin: Alignment.topLeft, end: Alignment.bottomRight)',
      cssSnippet: 'background: #242D3D;\nbox-shadow: inset 2px 2px 5px rgba(0,0,0,0.6), inset -2px -2px 5px rgba(255,255,255,0.05);',
      isDefault: true,
      createdBy: adminUser._id,
    },
    {
      name: 'Hexagonal Speaker Mesh',
      category: 'metals',
      description: 'Stamped metal grille with deep dark acoustic apertures and subtle metallic rim bevels.',
      tag: 'ACOUSTICS',
      reflectivity: '38% Micro-faceted',
      textureType: 'Stamped Perforated Grille',
      keyLightAngle: 'Top-down Downward Wash',
      roughness: 0.50,
      metallic: 0.70,
      swatches: [
        { name: 'Rim Chamfer', hex: '#94A3B8', role: 'Perforation Lip', description: 'Stamped edge glint' },
        { name: 'Grille Face', hex: '#475569', role: 'Plate Web', description: 'Inter-hole metal web' },
        { name: 'Acoustic Void', hex: '#020617', role: 'Chamber Ingress', description: 'Sound absorbing baffle interior' },
      ],
      gradientCSS: 'repeating-radial-gradient(circle at 50% 50%, #475569 0, #475569 3px, #020617 4px, #020617 6px)',
      flutterSnippet: 'LinearGradient(colors: [Color(0xFF475569), Color(0xFF0F172A)], begin: Alignment.topCenter, end: Alignment.bottomCenter)',
      cssSnippet: 'background: radial-gradient(#020617 35%, transparent 36%), #334155;\nbackground-size: 8px 8px;\nbox-shadow: inset 0 2px 6px rgba(0,0,0,0.8);',
      isDefault: true,
      createdBy: adminUser._id,
    },
    {
      name: 'Knurled Mil-Spec Rubber',
      category: 'organics',
      description: 'Diamond-tread vulcanized elastomer providing high friction grip with non-reflective tactical matte surface.',
      tag: 'ERGONOMICS',
      reflectivity: '8% Specular Matte',
      textureType: 'Diamond Knurled Tread',
      keyLightAngle: 'Multi-directional Micro Creases',
      roughness: 0.95,
      metallic: 0.0,
      swatches: [
        { name: 'Tread Apex', hex: '#374151', role: 'Diamond Crest', description: 'Grip pyramid apex' },
        { name: 'Tread Body', hex: '#1F2937', role: 'Elastomer Core', description: 'Vulcanized rubber body' },
        { name: 'Valley Root', hex: '#111827', role: 'Tread Valley', description: 'Debris relief trough' },
      ],
      gradientCSS: 'linear-gradient(45deg, #111827 25%, #374151 50%, #111827 75%)',
      flutterSnippet: 'LinearGradient(colors: [Color(0xFF374151), Color(0xFF1F2937), Color(0xFF111827)], begin: Alignment.topLeft, end: Alignment.bottomRight)',
      cssSnippet: 'background: repeating-linear-gradient(45deg, #1F2937 0px, #1F2937 2px, #111827 2px, #111827 4px);\nbox-shadow: inset 0 1px 3px rgba(0,0,0,0.7);',
      isDefault: true,
      createdBy: adminUser._id,
    },
    {
      name: 'Verdigris Bronze Patina',
      category: 'metals',
      description: 'Centuries-old atmospheric weathered bronze exhibiting rich turquoise carbonate crust over warm antique base.',
      tag: 'ANTIQUE',
      reflectivity: '22% Matte Patinated',
      textureType: 'Mineral Crust Oxidation',
      keyLightAngle: '315° Diffuse Ambient',
      roughness: 0.78,
      metallic: 0.60,
      swatches: [
        { name: 'Turquoise Crust', hex: '#2DD4BF', role: 'Oxide Bloom', description: 'Copper carbonate crystal bloom' },
        { name: 'Deep Bronze', hex: '#78350F', role: 'Exposed Alloy', description: 'Subsurface antique bronze' },
        { name: 'Dark Pit', hex: '#1C1917', role: 'Weathering Crease', description: 'Decades of outdoor oxidation' },
      ],
      gradientCSS: 'linear-gradient(135deg, #2DD4BF 0%, #0F766E 40%, #78350F 80%, #292524 100%)',
      flutterSnippet: 'LinearGradient(colors: [Color(0xFF2DD4BF), Color(0xFF0F766E), Color(0xFF78350F), Color(0xFF292524)], begin: Alignment.topLeft, end: Alignment.bottomRight)',
      cssSnippet: 'background: linear-gradient(135deg, #2DD4BF 0%, #0F766E 40%, #78350F 80%, #292524 100%);\nbox-shadow: 0 4px 10px rgba(0,0,0,0.5);',
      isDefault: true,
      createdBy: adminUser._id,
    },
    {
      name: 'Porcelain High-Voltage Ceramic',
      category: 'glass',
      description: 'Vitrified electrical insulator porcelain with pristine high-gloss glaze and smooth toroidal sheds.',
      tag: 'INSULATOR',
      reflectivity: '90% Specular Glaze',
      textureType: 'Vitrified Toroidal Shed',
      keyLightAngle: 'Highlight Crescent 315°',
      roughness: 0.10,
      metallic: 0.0,
      swatches: [
        { name: 'Glaze Specular', hex: '#FFFFFF', role: 'Glint Reflection', description: 'Mirror glint on glass glaze' },
        { name: 'Clay Body', hex: '#F1F5F9', role: 'Porcelain Core', description: 'Pure white kaolin ceramic' },
        { name: 'Undershed Occlusion', hex: '#94A3B8', role: 'Toroid Undercut', description: 'Shadow under flashover shed' },
      ],
      gradientCSS: 'radial-gradient(circle at 35% 30%, #FFFFFF 0%, #F1F5F9 60%, #CBD5E1 100%)',
      flutterSnippet: 'RadialGradient(center: Alignment(-0.3, -0.4), colors: [Color(0xFFFFFFFF), Color(0xFFF1F5F9), Color(0xFFCBD5E1)])',
      cssSnippet: 'background: radial-gradient(circle at 35% 30%, #FFFFFF 0%, #F1F5F9 60%, #CBD5E1 100%);\nbox-shadow: 0 6px 16px rgba(0,0,0,0.25), inset 0 2px 4px rgba(255,255,255,0.9);',
      isDefault: true,
      createdBy: adminUser._id,
    },
    {
      name: 'Cast Iron Machine Bed',
      category: 'metals',
      description: 'Heavy gray cast iron with rough sand-mold texture and hand-scraped prismatic machine ways.',
      tag: 'HEAVY_FOUNDRY',
      reflectivity: '18% Micro-pebbled',
      textureType: 'Sand Cast Foundry Texture',
      keyLightAngle: '315° Low Grazing Angle',
      roughness: 0.82,
      metallic: 0.75,
      swatches: [
        { name: 'Scraped Ridge', hex: '#6B7280', role: 'Hand Flaked Way', description: 'Bearing contact point' },
        { name: 'Cast Mass', hex: '#374151', role: 'Iron Casting', description: 'Gray graphite flake iron' },
        { name: 'Foundry Skin', hex: '#111827', role: 'Mold Surface', description: 'Carbon rich casting boundary' },
      ],
      gradientCSS: 'linear-gradient(135deg, #4B5563 0%, #1F2937 60%, #111827 100%)',
      flutterSnippet: 'LinearGradient(colors: [Color(0xFF4B5563), Color(0xFF1F2937), Color(0xFF111827)], begin: Alignment.topLeft, end: Alignment.bottomRight)',
      cssSnippet: 'background: linear-gradient(135deg, #4B5563 0%, #1F2937 60%, #111827 100%);\nbox-shadow: inset 0 3px 6px rgba(0,0,0,0.8), 0 8px 20px rgba(0,0,0,0.7);',
      isDefault: true,
      createdBy: adminUser._id,
    },
    {
      name: 'Phosphor P31 CRT Screen',
      category: 'displays',
      description: 'Active curved glass vacuum faceplate emitting iconic 525nm green luminescence with scanline grid pattern.',
      tag: 'RADAR_OSCILLOSCOPE',
      reflectivity: '60% Internal Luminescence',
      textureType: 'Phosphor Triad Shadow Mask',
      keyLightAngle: 'Internal Cathode Ray Wash',
      roughness: 0.08,
      metallic: 0.0,
      swatches: [
        { name: 'Phosphor Beam', hex: '#4ADE80', role: 'Active Electron Trace', description: 'Excited phosphor luminescence' },
        { name: 'Curved Glass Face', hex: '#064E3B', role: 'Filter Substrate', description: 'Green neutral density glass' },
        { name: 'Off State Anode', hex: '#022C22', role: 'Extinguished Mask', description: 'Deep dark unexcited raster' },
      ],
      gradientCSS: 'radial-gradient(ellipse at center, #064E3B 0%, #022C22 75%, #01140E 100%)',
      flutterSnippet: 'RadialGradient(colors: [Color(0xFF064E3B), Color(0xFF022C22), Color(0xFF01140E)])',
      cssSnippet: 'background: radial-gradient(ellipse at center, #064E3B 0%, #022C22 75%, #01140E 100%);\nbox-shadow: inset 0 0 20px rgba(74,222,128,0.3), 0 0 15px rgba(74,222,128,0.2);\nborder: 2px solid #064E3B;',
      isDefault: true,
      createdBy: adminUser._id,
    },
  ];

  const createdMaterials = await Material.insertMany(materialsData);
  console.log(`[Seed] Calibrated ${createdMaterials.length} skeuomorphic physical materials.`);

  // 4. Create 15 Core Skeuomorphic Physical Components
  const componentsData = [
    {
      name: 'Heavy Rotary Dial',
      category: 'controls',
      description: 'Solid knurled aluminum knob with 30-degree tactile detents, machined pointer notch, and cast shadow rotation.',
      technique: 'Multi-layer Radial Conic Gradients & Transform Matrix',
      configuration: { min: 0, max: 100, step: 10, default: 40, unit: 'dB' },
      material: 'aluminum',
      animationCurve: 'easeOutBack',
      flutterCode: 'SkeuoKnob(value: currentGain, onChanged: (v) => setGain(v), min: 0, max: 100, label: "GAIN dB")',
      isDefault: true,
      viewsCount: 230,
      interactionsCount: 1450,
      createdBy: adminUser._id,
    },
    {
      name: 'Heavy Industrial Toggle Switch',
      category: 'controls',
      description: 'Solid bat-handle toggle with stamped ON/OFF legend plate, machined lock nut, and spring snap physics.',
      technique: 'Compound Drop Shadow & Transform 3D Pivot',
      configuration: { state: 'ON', voltageRating: '250V AC', travelDegrees: 45 },
      material: 'brass',
      animationCurve: 'elasticOut',
      flutterCode: 'SkeuoToggle(value: isPowered, onChanged: (v) => togglePower(v), label: "MAIN POWER")',
      isDefault: true,
      viewsCount: 380,
      interactionsCount: 2180,
      createdBy: adminUser._id,
    },
    {
      name: 'Analog Ballistic VU Meter',
      category: 'displays',
      description: 'Warm incandescent backlit galvanometer with parabolic decibel scale and damped ballistic needle inertia.',
      technique: 'CustomPainter Needle Canvas with Damped Oscillation',
      configuration: { minDb: -20, maxDb: 3, redlineThreshold: 0, peakHoldMs: 1500 },
      material: 'bakelite',
      animationCurve: 'easeOutQuad',
      flutterCode: 'SkeuoVuMeter(signalLevel: audioLevel, peakLevel: peakLevel, label: "AUDIO dB")',
      isDefault: true,
      viewsCount: 410,
      interactionsCount: 3100,
      createdBy: adminUser._id,
    },
    {
      name: 'IN-14 Neon Nixie Tube',
      category: 'displays',
      description: 'Real glass envelope with wire mesh anode and glowing neon orange cathode numerals with soft glass refraction.',
      technique: 'Layered Box-Shadow Neon Bloom & CRT Hue Filter',
      configuration: { activeDigit: 7, ionizationVoltage: '170V DC', gasMix: 'Neon-Argon' },
      material: 'glass',
      animationCurve: 'easeInOut',
      flutterCode: 'SkeuoNixieDisplay(value: telemetryCount, digits: 4, glowColor: Color(0xFFFF6B00))',
      isDefault: true,
      viewsCount: 520,
      interactionsCount: 2890,
      createdBy: adminUser._id,
    },
    {
      name: 'Mechanical Concave Push Button',
      category: 'controls',
      description: 'Tactile square pushbutton with concave finger dish, 3.5mm mechanical travel, and microswitch snap.',
      technique: 'Physical Bevel Inversion on PointerDown',
      configuration: { momentary: false, ledIndicator: true, clickSound: 'mechanical_click' },
      material: 'bakelite',
      animationCurve: 'easeOutExpo',
      flutterCode: 'SkeuoButton(label: "TEST RUN", onPressed: () => runDiagnostics(), isPressed: testing)',
      isDefault: true,
      viewsCount: 290,
      interactionsCount: 1840,
      createdBy: adminUser._id,
    },
    {
      name: 'Dual-State Illuminated Rocker',
      category: 'controls',
      description: 'Concave split rocker switch with internally illuminated red jewel lens and crisp rocking plane shift.',
      technique: 'Bi-planar Linear Gradient Flip & Bevel Shadow Shift',
      configuration: { illuminated: true, orientation: 'vertical', lampColor: 'Amber Red' },
      material: 'bakelite',
      animationCurve: 'easeInOutCubic',
      flutterCode: 'SkeuoRockerSwitch(active: isEngaged, onChanged: (v) => setEngaged(v), label: "STANDBY")',
      isDefault: true,
      viewsCount: 195,
      interactionsCount: 970,
      createdBy: adminUser._id,
    },
    {
      name: 'Linear Studio Slide Potentiometer',
      category: 'controls',
      description: 'Professional 100mm fader with machined grooved slider cap, engraved decibel markings, and felt dust strip.',
      technique: 'Compound Inset Groove Shadow & Milled Thumb Cap',
      configuration: { travelMm: 100, taper: 'Audio Logarithmic', detentCenter: true },
      material: 'aluminum',
      animationCurve: 'easeOut',
      flutterCode: 'SkeuoSlider(value: mixRatio, min: 0.0, max: 1.0, onChanged: (v) => setMix(v))',
      isDefault: true,
      viewsCount: 310,
      interactionsCount: 1620,
      createdBy: adminUser._id,
    },
    {
      name: 'Curved Phosphor CRT Monitor',
      category: 'displays',
      description: 'Spherical curved glass cathode ray tube with horizontal scanlines, phosphor persistence, and vignette bloom.',
      technique: 'Convex Radial Gradient & Horizontal Repeating Scanline Mesh',
      configuration: { screenCurve: 0.15, scanlineDensity: 2, bloomRadius: 12 },
      material: 'glass',
      animationCurve: 'linear',
      flutterCode: 'SkeuoCrtScreen(child: TerminalFeedWidget(), phosphorColor: PhosphorGreen)',
      isDefault: true,
      viewsCount: 460,
      interactionsCount: 2400,
      createdBy: adminUser._id,
    },
    {
      name: 'Numbered Stepper Knob',
      category: 'controls',
      description: 'Fluted rotary knob with engraved white 1-10 numbers, skirt bezel, and authoritative mechanical click stops.',
      technique: 'Concentric Fluted Ring Shadow Mapping',
      configuration: { steps: 10, startAngle: -135, endAngle: 135 },
      material: 'bakelite',
      animationCurve: 'easeOutBack',
      flutterCode: 'SkeuoStepKnob(currentStep: presetChannel, steps: 10, onStepChanged: (s) => setChannel(s))',
      isDefault: true,
      viewsCount: 180,
      interactionsCount: 880,
      createdBy: adminUser._id,
    },
    {
      name: 'Heavy Spring Mechanical Keycap',
      category: 'controls',
      description: 'Spherical molded keycap with authentic retro sculpted profile, deep bottom-out clack, and tactile bump.',
      technique: 'Trapezoidal 3D Perspective Projection with Inset Legend',
      configuration: { actuationForceGrams: 67, tactileType: 'Clicky Spring' },
      material: 'bakelite',
      animationCurve: 'easeOutExpo',
      flutterCode: 'SkeuoKeycap(legend: "EXECUTE", onKeyPress: () => executeCommand())',
      isDefault: true,
      viewsCount: 275,
      interactionsCount: 1310,
      createdBy: adminUser._id,
    },
    {
      name: 'Retro 7-Segment LED Readout',
      category: 'displays',
      description: 'Beveled red LED display module with unlit faint ghost segments, ruby optical filter, and diffused glare.',
      technique: 'Multi-layer SVG Paths with Ambient Occlusion & Glow Layer',
      configuration: { digitCount: 6, decimalPoints: [2], segmentColor: '#EF4444' },
      material: 'glass',
      animationCurve: 'linear',
      flutterCode: 'SkeuoSevenSegment(value: "142.85", color: Color(0xFFEF4444), backgroundColor: Color(0xFF1E0A0A))',
      isDefault: true,
      viewsCount: 340,
      interactionsCount: 1750,
      createdBy: adminUser._id,
    },
    {
      name: 'High-Voltage Dual Knife Switch',
      category: 'controls',
      description: 'Exposed heavy solid copper blades on glazed slate base with insulated handle and arc hazard warnings.',
      technique: 'Dual Layer Dynamic Projection Shadows with Angle Tilt',
      configuration: { openAngleDegrees: 75, ratedCurrentAmps: 100, sparkSound: true },
      material: 'copper',
      animationCurve: 'easeOutBounce',
      flutterCode: 'SkeuoKnifeSwitch(isOpen: isInterlockOpen, onToggle: (open) => setInterlock(open))',
      isDefault: true,
      viewsCount: 390,
      interactionsCount: 1980,
      createdBy: adminUser._id,
    },
    {
      name: '1/4" Heavy TRS Audio Socket',
      category: 'artifacts',
      description: 'Milled nickel panel-mount jack with hexagonal mounting nut and authentic insertion resistance feel.',
      technique: 'Concentric Bored Cylindrical Chamfer Gradient',
      configuration: { diameterMm: 6.35, isConnected: false },
      material: 'aluminum',
      animationCurve: 'easeOut',
      flutterCode: 'SkeuoAudioJack(isPlugged: hasPatchCable, onPlugChanged: (p) => setPatch(p))',
      isDefault: true,
      viewsCount: 160,
      interactionsCount: 640,
      createdBy: adminUser._id,
    },
    {
      name: 'Faceted Pilot Indicator Jewel',
      category: 'displays',
      description: 'Cut-glass faceted jewel lens over low-wattage incandescent filament bulb with ambient chassis glow.',
      technique: 'Multi-facet Radial Refraction & Pulse Glow Animation',
      configuration: { lensColor: 'Ruby Red', pulseHz: 1.2, isBlinking: false },
      material: 'glass',
      animationCurve: 'easeInOutSine',
      flutterCode: 'SkeuoPilotJewel(isOn: systemReady, color: Colors.amber, label: "SYS READY")',
      isDefault: true,
      viewsCount: 280,
      interactionsCount: 1120,
      createdBy: adminUser._id,
    },
    {
      name: 'Bourdon Tube Pressure Manometer',
      category: 'displays',
      description: 'Heavy brass casing with calibrated PSI dial face, curved bourdon linkage, and mechanical jitter needle.',
      technique: 'Precision Radial Angle Painter with Physical Damping Spring',
      configuration: { minPsi: 0, maxPsi: 150, redlinePsi: 120, unit: 'PSI' },
      material: 'brass',
      animationCurve: 'easeOutElastic',
      flutterCode: 'SkeuoPressureGauge(psi: chamberPressure, label: "STEAM PSI")',
      isDefault: true,
      viewsCount: 330,
      interactionsCount: 1540,
      createdBy: adminUser._id,
    },
  ];

  const createdComponents = await Component.insertMany(componentsData);
  console.log(`[Seed] Assembled ${createdComponents.length} skeuomorphic interactive components.`);

  // 5. Create Sample Collections for Operators
  const sampleCollections = [
    {
      userId: adminUser._id,
      name: 'Vacuum Tube Audio Rack',
      description: 'High-end analog audio master chain with backlit VU meters, rotary gain pots, and tube preamps.',
      components: [createdComponents[0]._id.toString(), createdComponents[2]._id.toString(), createdComponents[6]._id.toString()],
      materials: [createdMaterials[0]._id.toString(), createdMaterials[2]._id.toString(), createdMaterials[3]._id.toString()],
      isPublic: true,
    },
    {
      userId: adminUser._id,
      name: 'High-Voltage Control Console',
      description: 'Industrial safety cutoffs, heavy ceramic insulators, and knife switches for substation switching.',
      components: [createdComponents[1]._id.toString(), createdComponents[11]._id.toString(), createdComponents[13]._id.toString()],
      materials: [createdMaterials[4]._id.toString(), createdMaterials[7]._id.toString(), createdMaterials[11]._id.toString()],
      isPublic: true,
    },
    {
      userId: standardUser._id,
      name: 'Analog Metrology Workbench',
      description: 'Precision measurement instruments, Bourdon pressure gauges, and 7-segment digital readouts.',
      components: [createdComponents[3]._id.toString(), createdComponents[10]._id.toString(), createdComponents[14]._id.toString()],
      materials: [createdMaterials[1]._id.toString(), createdMaterials[6]._id.toString(), createdMaterials[13]._id.toString()],
      isPublic: false,
    },
  ];

  await Collection.insertMany(sampleCollections);
  console.log('[Seed] Built 3 initial operator parts drawers & consoles.');

  // 6. Seed Telemetry & Daily Analytics
  const now = new Date();
  const pastDays = [6, 5, 4, 3, 2, 1, 0];
  const analyticsData = pastDays.map((daysAgo) => {
    const d = new Date(now);
    d.setDate(d.getDate() - daysAgo);
    const dateStr = d.toISOString().split('T')[0];
    return {
      date: dateStr,
      totalInteractions: 140 + Math.floor(Math.random() * 80),
      activeUsers: 8 + Math.floor(Math.random() * 6),
      popularMaterial: 'Brushed Brass',
      popularComponent: 'Heavy Rotary Dial',
      themeSwitches: { brass: 45, aluminum: 32, bakelite: 28, darkLab: 64 },
      codeExports: 18 + Math.floor(Math.random() * 12),
    };
  });

  await AnalyticsStat.insertMany(analyticsData);

  // 7. Seed Sample Activities
  const sampleActivities = [
    { userId: adminUser._id, action: 'LAB_CALIBRATE', category: 'interaction', metadata: { unit: 'Main Console' }, timestamp: new Date(Date.now() - 3600000 * 5) },
    { userId: standardUser._id, action: 'ROTARY_DIAL_TURN', category: 'interaction', metadata: { value: 65, component: 'Heavy Rotary Dial' }, timestamp: new Date(Date.now() - 3600000 * 3) },
    { userId: standardUser._id, action: 'CODE_EXPORT_FLUTTER', category: 'code_generation', metadata: { material: 'Brushed Brass' }, timestamp: new Date(Date.now() - 3600000 * 2) },
    { userId: adminUser._id, action: 'THEME_SWITCH', category: 'theme', metadata: { theme: 'Vintage Bakelite' }, timestamp: new Date(Date.now() - 3600000 * 1) },
  ];

  await Activity.insertMany(sampleActivities);
  console.log('[Seed] Telemetry and activity log calibrated successfully.');
  console.log('[Seed] Database initialization complete!');
};

// Standalone execution script
if (require.main === module) {
  seedDatabase()
    .then(() => {
      console.log('[Seed] Calibration script finished cleanly.');
      process.exit(0);
    })
    .catch((err) => {
      console.error('[Seed] Calibration failure:', err);
      process.exit(1);
    });
}
