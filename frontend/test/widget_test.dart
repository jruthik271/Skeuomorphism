import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:skeuolab/app/app.dart';
import 'package:skeuolab/widgets/common/led_indicator.dart';

void main() {
  testWidgets('LedIndicator test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: LedIndicator(isOn: false, color: LedColor.green, size: 9),
        ),
      ),
    );
  });

  testWidgets('SkeuoLab app renders with engraved plate and navigation', (WidgetTester tester) async {
    // Set standard mobile screen size
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.75;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(const SkeuoLabApp());
    await tester.pumpAndSettle();

    // Verify main title and subtitle engraved plates
    expect(find.text('SKEUOLAB'), findsWidgets);
    expect(find.text('FLUTTER SKEUOMORPHISM SHOWCASE'), findsOneWidget);

    // Verify presence of core controls
    expect(find.text('POWER'), findsWidgets);
    expect(find.text('PRESS'), findsOneWidget);
    expect(find.text('VOLUME'), findsWidgets);
    expect(find.text('INTENSITY'), findsWidgets);

    // Verify presence of physical navigation bar tabs
    expect(find.text('HOME'), findsWidgets);
    expect(find.text('CONTROLS'), findsWidgets);
    expect(find.text('LAB'), findsOneWidget);
    expect(find.text('PLAYGROUND'), findsOneWidget);
    expect(find.text('PALETTES'), findsWidgets);
    expect(find.text('MORE'), findsOneWidget);

    // Tap the 'PRESS' button and verify count increment
    expect(find.text('COUNT: 0'), findsOneWidget);
    await tester.tap(find.text('PRESS'));
    await tester.pumpAndSettle();
    expect(find.text('COUNT: 1'), findsOneWidget);

    // Tap CONTROLS tab and verify navigation
    await tester.tap(find.text('CONTROLS').first);
    await tester.pumpAndSettle();
    expect(find.text('LABORATORY BENCH'), findsOneWidget);
    expect(find.text('DUAL ANALOG TELEMETRY'), findsOneWidget);

    // Tap LAB tab and verify Optical Testing Bay
    await tester.tap(find.text('LAB').first);
    await tester.pumpAndSettle();
    expect(find.text('OPTICAL TESTING BAY'), findsOneWidget);

    // Tap PLAYGROUND tab and verify Component Playground
    await tester.tap(find.text('PLAYGROUND').first);
    await tester.pumpAndSettle();
    expect(find.text('COMPONENT PLAYGROUND'), findsOneWidget);

    // Tap PALETTES tab and verify navigation
    await tester.tap(find.text('PALETTES').first);
    await tester.pumpAndSettle();
    expect(find.text('PALETTE & MATERIAL STUDIO'), findsOneWidget);

    // Tap MORE tab to open auxiliary modules menu
    await tester.tap(find.text('MORE'));
    await tester.pumpAndSettle();
    expect(find.text('AUXILIARY INSTRUMENT MODULES'), findsOneWidget);
    expect(find.text('PHYSICAL OBJECTS'), findsOneWidget);
    expect(find.text('PARTS DRAWERS'), findsOneWidget);
    expect(find.text('CRT & TELEMETRY'), findsOneWidget);
    expect(find.text('OPERATOR CLEARANCE'), findsOneWidget);

    // Tap PHYSICAL OBJECTS and verify objects screen
    await tester.tap(find.text('PHYSICAL OBJECTS'));
    await tester.pumpAndSettle();
    expect(find.text('OBJECTS SHOWCASE'), findsOneWidget);

    // Navigate back to HOME
    await tester.tap(find.text('HOME').first);
    await tester.pumpAndSettle();
    expect(find.text('SKEUOLAB'), findsWidgets);
  });
}
