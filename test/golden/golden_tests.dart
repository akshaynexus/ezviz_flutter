import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ezviz_flutter/ezviz_flutter.dart';
import '../test_utils.dart';

void main() {
  group('Golden Tests', () {
    testWidgets('PTZControlPanel default appearance', (tester) async {
      await GoldenTestHelper.expectGoldenVariants(
        tester,
        PTZControlPanel(
          key: Key('ptz_control_default'),
        ),
        'ptz_control_default',
      );
    });
    
    testWidgets('PTZControlPanel with custom styling', (tester) async {
      await GoldenTestHelper.expectGoldenVariants(
        tester,
        PTZControlPanel(
          key: Key('ptz_control_custom'),
          size: 250,
          backgroundColor: Colors.blue.withValues(alpha: 0.3),
          activeColor: Colors.orange,
          borderColor: Colors.white,
          centerIcon: Icon(
            Icons.center_focus_strong,
            color: Colors.white,
            size: 24,
          ),
        ),
        'ptz_control_custom',
      );
    });
    
    testWidgets('PTZControlPanel various sizes', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                PTZControlPanel(
                  key: Key('ptz_small'),
                  size: 100,
                ),
                PTZControlPanel(
                  key: Key('ptz_medium'),
                  size: 150,
                ),
                PTZControlPanel(
                  key: Key('ptz_large'), 
                  size: 200,
                ),
              ],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      
      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('goldens/ptz_control_sizes.png'),
      );
    });
    
    testWidgets('PTZControlPanel in different themes', (tester) async {
      final lightTheme = ThemeData.light();
      final darkTheme = ThemeData.dark();
      
      // Light theme
      await GoldenTestHelper.pumpWidgetWithMaterial(
        tester,
        PTZControlPanel(
          key: Key('ptz_themed'),
          size: 180,
        ),
        theme: lightTheme,
      );
      
      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('goldens/ptz_control_light_theme.png'),
      );
      
      // Dark theme
      await GoldenTestHelper.pumpWidgetWithMaterial(
        tester,
        PTZControlPanel(
          key: Key('ptz_themed'),
          size: 180,
        ),
        theme: darkTheme,
      );
      
      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('goldens/ptz_control_dark_theme.png'),
      );
    });
    
    testWidgets('PTZControlPanel with text scale factors', (tester) async {
      final testScales = [0.8, 1.0, 1.3, 1.8];
      
      for (final scale in testScales) {
        await GoldenTestHelper.pumpWidgetWithMaterial(
          tester,
          PTZControlPanel(
            key: Key('ptz_scale_$scale'),
            size: 160,
            centerIcon: Icon(Icons.my_location),
          ),
          textScaleFactor: scale,
        );
        
        await expectLater(
          find.byType(Scaffold),
          matchesGoldenFile('goldens/ptz_control_scale_${scale}x.png'),
        );
      }
    });
  });
}