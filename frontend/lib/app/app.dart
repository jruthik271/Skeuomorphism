import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/analytics_provider.dart';
import '../providers/auth_provider.dart';
import '../providers/collections_provider.dart';
import '../providers/components_provider.dart';
import '../providers/materials_provider.dart';
import '../screens/about_screen.dart';
import '../screens/admin/admin_screen.dart';
import '../screens/analytics/analytics_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/collections/collections_screen.dart';
import '../screens/controls_screen.dart';
import '../screens/home_screen.dart';
import '../screens/laboratory/laboratory_screen.dart';
import '../screens/objects_screen.dart';
import '../screens/palettes_screen.dart';
import '../screens/playground/playground_screen.dart';
import '../services/theme_controller.dart';
import '../styles/skeuo_colors.dart';
import '../utils/constants.dart';
import '../utils/sound_helper.dart';
import '../widgets/common/engraved_plate.dart';
import '../widgets/common/led_indicator.dart';
import '../widgets/common/metal_screw.dart';
import '../widgets/navigation/skeuo_bottom_nav.dart';
import 'theme.dart';

class SkeuoLabApp extends StatelessWidget {
  const SkeuoLabApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => MaterialsProvider()),
        ChangeNotifierProvider(create: (_) => ComponentsProvider()),
        ChangeNotifierProvider(create: (_) => CollectionsProvider()),
        ChangeNotifierProvider(create: (_) => AnalyticsProvider()),
      ],
      child: AnimatedBuilder(
        animation: ThemeController.instance,
        builder: (context, _) {
          return MaterialApp(
            title: AppConstants.appName,
            debugShowCheckedModeBanner: false,
            theme: SkeuoTheme.darkTheme,
            home: const SkeuoMainShell(),
          );
        },
      ),
    );
  }
}

class SkeuoMainShell extends StatefulWidget {
  const SkeuoMainShell({super.key});

  @override
  State<SkeuoMainShell> createState() => _SkeuoMainShellState();
}

class _SkeuoMainShellState extends State<SkeuoMainShell> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(), // 0
    ControlsScreen(), // 1
    LaboratoryScreen(), // 2
    PlaygroundScreen(), // 3
    PalettesScreen(), // 4
    ObjectsScreen(), // 5
    CollectionsScreen(), // 6
    AnalyticsScreen(), // 7
    LoginScreen(), // 8
    AdminScreen(), // 9
    AboutScreen(), // 10
  ];

  void _onSelectTab(int index) {
    SoundHelper.click();
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeController = ThemeController.instance;
    final currentTheme = themeController.themeMode;
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFF0A0705),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 960;
          final double maxConsoleWidth = (isWide && themeController.viewMode == DesktopViewMode.responsiveStudio)
              ? 760.0
              : 520.0;

          return Column(
            children: [
              // Desktop Workbench Header Bar
              if (isWide)
                _buildDesktopHeader(themeController, auth),

              // Main Skeuomorphic Console
              Expanded(
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: maxConsoleWidth),
                    child: Container(
                      decoration: BoxDecoration(
                        color: currentTheme.backgroundColor,
                        border: Border.symmetric(
                          vertical: BorderSide(
                            color: currentTheme == AppThemeMode.aluminum
                                ? const Color(0xFF4C5460)
                                : const Color(0xFF3B271B).withValues(alpha: 0.8),
                            width: 2.0,
                          ),
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0xFF000000),
                            offset: Offset(0, 0),
                            blurRadius: 28,
                            spreadRadius: 6,
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          // Rack mount screws along left & right edges on wide screens
                          if (isWide) ...[
                            Positioned(
                              top: 12,
                              left: 6,
                              child: MetalScrew(size: 10, material: currentTheme.screwMaterial, angle: 0.7),
                            ),
                            Positioned(
                              top: 12,
                              right: 6,
                              child: MetalScrew(size: 10, material: currentTheme.screwMaterial, angle: 2.1),
                            ),
                            Positioned(
                              bottom: 60,
                              left: 6,
                              child: MetalScrew(size: 10, material: currentTheme.screwMaterial, angle: 1.4),
                            ),
                            Positioned(
                              bottom: 60,
                              right: 6,
                              child: MetalScrew(size: 10, material: currentTheme.screwMaterial, angle: 3.2),
                            ),
                          ],

                          // Screen Stack and Physical Bottom Nav
                          Scaffold(
                            backgroundColor: Colors.transparent,
                            body: IndexedStack(
                              index: _currentIndex,
                              children: _screens,
                            ),
                            bottomNavigationBar: SkeuoBottomNav(
                              currentIndex: _currentIndex,
                              onTabSelected: _onSelectTab,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDesktopHeader(ThemeController themeController, AuthProvider auth) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF282D34),
            Color(0xFF1B1E22),
            Color(0xFF14171A),
          ],
        ),
        border: const Border(
          bottom: BorderSide(color: Color(0xFF383E46), width: 1.5),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0xBB000000),
            offset: Offset(0, 2),
            blurRadius: 6,
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left: Brand Plate
          Row(
            children: [
              const MetalScrew(size: 8, material: ScrewMaterial.brass, angle: 0.4),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => _onSelectTab(0),
                child: const EngravedPlate(
                  title: 'SKEUOLAB // WORKBENCH',
                  material: PlateMaterial.brass,
                  showScrews: false,
                  titleFontSize: 11,
                  letterSpacing: 1.5,
                  paddingVertical: 4,
                  paddingHorizontal: 10,
                ),
              ),
            ],
          ),

          // Center: Quick Module Actuators
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildHeaderModuleBtn('LAB BAY', 2),
                _buildHeaderModuleBtn('PLAYGROUND', 3),
                _buildHeaderModuleBtn('DRAWERS', 6),
                _buildHeaderModuleBtn('TELEMETRY', 7),
                _buildHeaderModuleBtn(auth.isAuthenticated ? (auth.user?.name.split(' ').first.toUpperCase() ?? 'OPERATOR') : 'LOGIN', 8),
                if (auth.isAdmin) _buildHeaderModuleBtn('ADMIN', 9),
              ],
            ),
          ),

          // Right: Theme, Sound & View Mode Toggles
          Row(
            children: [
              // Audio Toggle
              GestureDetector(
                onTap: () {
                  themeController.toggleSound();
                  SoundHelper.click();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFF14171A),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: const Color(0xFF383E46)),
                  ),
                  child: Row(
                    children: [
                      LedIndicator(
                        isOn: themeController.soundEnabled,
                        color: LedColor.green,
                        size: 6,
                        labelBelow: false,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        themeController.soundEnabled ? 'SOUND: ON' : 'SOUND: OFF',
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 8.5,
                          fontWeight: FontWeight.w800,
                          color: themeController.soundEnabled ? SkeuoColors.ledGreenOn : const Color(0xFF757D88),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 6),

              // View Mode Toggle
              GestureDetector(
                onTap: () {
                  SoundHelper.click();
                  themeController.toggleViewMode();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFF14171A),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: const Color(0xFF383E46)),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        themeController.viewMode == DesktopViewMode.responsiveStudio
                            ? Icons.fit_screen_rounded
                            : Icons.smartphone_rounded,
                        size: 11,
                        color: const Color(0xFFDFB660),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        themeController.viewMode == DesktopViewMode.responsiveStudio ? 'STUDIO' : 'CONSOLE',
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 8.5,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFFDFB660),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const MetalScrew(size: 8, material: ScrewMaterial.brass, angle: 1.8),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderModuleBtn(String label, int targetIndex) {
    final isSelected = _currentIndex == targetIndex;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.5),
      child: GestureDetector(
        onTap: () => _onSelectTab(targetIndex),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            gradient: isSelected
                ? const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFFDFB660), Color(0xFF9E7728)],
                  )
                : const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF2E343E), Color(0xFF1E2228)],
                  ),
            border: Border.all(
              color: isSelected ? SkeuoColors.brassHighlight : const Color(0xFF3D4552),
              width: 1.0,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'serif',
              fontSize: 8.5,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.9,
              color: isSelected ? const Color(0xFF221503) : const Color(0xFFC0C7CE),
            ),
          ),
        ),
      ),
    );
  }
}
