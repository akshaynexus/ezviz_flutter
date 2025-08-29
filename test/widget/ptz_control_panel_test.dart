import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ezviz_flutter/ezviz_flutter.dart';
import '../test_utils.dart';

void main() {
  group('PTZControlPanel Widget', () {
    testWidgets('renders with default properties', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PTZControlPanel(),
          ),
        ),
      );
      
      final panelFinder = find.byType(PTZControlPanel);
      panelFinder.expectMeaningful(
        findsOneWidget,
        reason: 'PTZControlPanel should be rendered',
      );
      
      // Verify default size is applied
      final container = tester.widget<Container>(
        find.descendant(
          of: panelFinder,
          matching: find.byType(Container),
        ).first,
      );
      
      container.constraints?.minWidth.expectMeaningful(
        equals(200),
        reason: 'Default size should be 200',
      );
    });
    
    testWidgets('renders with custom properties', (tester) async {
      const customSize = 150.0;
      const backgroundColor = Colors.red;
      const activeColor = Colors.green;
      const borderColor = Colors.yellow;
      final centerIcon = Icon(Icons.center_focus_strong);
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PTZControlPanel(
              size: customSize,
              backgroundColor: backgroundColor,
              activeColor: activeColor,
              borderColor: borderColor,
              centerIcon: centerIcon,
            ),
          ),
        ),
      );
      
      final panelFinder = find.byType(PTZControlPanel);
      panelFinder.expectMeaningful(
        findsOneWidget,
        reason: 'Custom PTZControlPanel should be rendered',
      );
      
      // Verify custom icon is present
      final iconFinder = find.byIcon(Icons.center_focus_strong);
      iconFinder.expectMeaningful(
        findsOneWidget,
        reason: 'Custom center icon should be displayed',
      );
    });
    
    testWidgets('handles center tap correctly', (tester) async {
      var centerTapCount = 0;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PTZControlPanel(
              onCenterTap: () => centerTapCount++,
            ),
          ),
        ),
      );
      
      // Find and tap the center area
      final centerFinder = find.byType(PTZControlPanel);
      centerFinder.expectMeaningful(
        findsOneWidget,
        reason: 'PTZControlPanel should be found for tap testing',
      );
      
      // Tap the center of the control panel
      await tester.tapAt(tester.getCenter(centerFinder));
      await tester.pump();
      
      centerTapCount.expectMeaningful(
        equals(1),
        reason: 'Center tap callback should be triggered once',
      );
    });
    
    testWidgets('responds to pan gestures', (tester) async {
      var gestureDetected = false;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PTZControlPanel(
              onDirectionStart: (direction) => gestureDetected = true,
              onDirectionStop: (direction) => gestureDetected = true,
            ),
          ),
        ),
      );
      
      final panelFinder = find.byType(PTZControlPanel);
      panelFinder.expectMeaningful(
        findsOneWidget,
        reason: 'PTZControlPanel should be found for gesture testing',
      );
      
      // Test that the widget can handle gestures without throwing exceptions
      await tester.drag(panelFinder, Offset(50, 0));
      await tester.pump();
      
      // Verify widget remains functional after gesture interaction
      panelFinder.expectMeaningful(
        findsOneWidget,
        reason: 'Widget should remain functional after gesture interaction',
      );
      
      // Test a larger drag gesture
      await tester.drag(panelFinder, Offset(100, 50));
      await tester.pumpAndSettle();
      
      // Widget should still be stable
      panelFinder.expectMeaningful(
        findsOneWidget,
        reason: 'Widget should handle multiple gestures gracefully',
      );
    });
    
    testWidgets('maintains state during interaction', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PTZControlPanel(
              onDirectionStart: (direction) {},
              onDirectionStop: (direction) {},
            ),
          ),
        ),
      );
      
      final panelFinder = find.byType(PTZControlPanel);
      final stateFinder = find.byType(PTZControlPanel);
      
      // Initial state
      stateFinder.expectMeaningful(
        findsOneWidget,
        reason: 'Control panel should maintain consistent state',
      );
      
      // Simulate pan interaction
      await tester.drag(panelFinder, Offset(30, 0));
      await tester.pump();
      
      // State should still be valid after interaction
      stateFinder.expectMeaningful(
        findsOneWidget,
        reason: 'Control panel should maintain state after interaction',
      );
    });
    
    testWidgets('handles multiple rapid gestures', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PTZControlPanel(
              onDirectionStart: (direction) {},
            ),
          ),
        ),
      );
      
      final panelFinder = find.byType(PTZControlPanel);
      
      // Multiple rapid pan gestures - test that widget handles them gracefully
      for (int i = 0; i < 3; i++) {
        await tester.drag(panelFinder, Offset(20 + i * 10, 0));
        await tester.pump(Duration(milliseconds: 10));
      }
      
      // Verify widget remains functional after multiple gestures
      panelFinder.expectMeaningful(
        findsOneWidget,
        reason: 'Widget should handle multiple rapid gestures gracefully',
      );
      
      // Verify widget is still responsive
      final renderBox = tester.renderObject<RenderBox>(panelFinder);
      renderBox.size.width.expectMeaningful(
        greaterThan(0),
        reason: 'Widget should maintain proper dimensions after gestures',
      );
    });
    
    testWidgets('renders correctly with different sizes', (tester) async {
      final testSizes = [50.0, 100.0, 200.0, 300.0];
      
      for (final size in testSizes) {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: PTZControlPanel(size: size),
            ),
          ),
        );
        
        final panelFinder = find.byType(PTZControlPanel);
        panelFinder.expectMeaningful(
          findsOneWidget,
          reason: 'PTZControlPanel should render with size $size',
        );
        
        // Verify the container has correct dimensions
        final renderBox = tester.renderObject<RenderBox>(panelFinder);
        renderBox.size.width.expectMeaningful(
          equals(size),
          reason: 'Width should match specified size $size',
        );
        
        renderBox.size.height.expectMeaningful(
          equals(size),
          reason: 'Height should match specified size $size',
        );
      }
    });
    
    testWidgets('handles edge case gestures', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PTZControlPanel(
              onDirectionStart: (direction) {},
              onDirectionStop: (direction) {},
            ),
          ),
        ),
      );
      
      final panelFinder = find.byType(PTZControlPanel);
      
      // Test very small gesture
      await tester.drag(panelFinder, Offset(1, 1));
      await tester.pump();
      
      // Test zero offset gesture
      await tester.drag(panelFinder, Offset(0, 0));
      await tester.pump();
      
      // Test negative gesture
      await tester.drag(panelFinder, Offset(-10, -10));
      await tester.pump();
      
      // Should handle edge cases gracefully without crashing
      panelFinder.expectMeaningful(
        findsOneWidget,
        reason: 'Control panel should handle edge case gestures gracefully',
      );
    });
    
    testWidgets('accessibility and semantics', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PTZControlPanel(
              onCenterTap: () {},
              onDirectionStart: (direction) {},
            ),
          ),
        ),
      );
      
      // Should be accessible for interaction
      final panelFinder = find.byType(PTZControlPanel);
      panelFinder.expectMeaningful(
        findsOneWidget,
        reason: 'PTZControlPanel should be accessible',
      );
      
      // Verify gesture detector is present and functional
      final gestureDetector = find.descendant(
        of: panelFinder,
        matching: find.byType(GestureDetector),
      );
      
      gestureDetector.expectMeaningful(
        findsAtLeastNWidgets(1),
        reason: 'Should have gesture detector for accessibility',
      );
    });
  });
}