import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'app/app.dart';
import 'providers/analytics_provider.dart';
import 'providers/auth_provider.dart';
import 'providers/collections_provider.dart';
import 'providers/components_provider.dart';
import 'providers/materials_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Set system UI overlay style for dark skeuomorphic aesthetic
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
      systemNavigationBarColor: Color(0xFF14171A),
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => MaterialsProvider()),
        ChangeNotifierProvider(create: (_) => ComponentsProvider()),
        ChangeNotifierProvider(create: (_) => CollectionsProvider()),
        ChangeNotifierProvider(create: (_) => AnalyticsProvider()),
      ],
      child: const SkeuoLabApp(),
    ),
  );
}

