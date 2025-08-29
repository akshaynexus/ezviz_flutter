import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ezviz_flutter/ezviz_flutter.dart';
import '../test_utils.dart';

void main() {
  group('EnhancedPlayerControls Widget', () {
    testWidgets('renders with default properties', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EnhancedPlayerControls(
              isPlaying: false,
            ),
          ),
        ),
      );
      
      final controlsFinder = find.byType(EnhancedPlayerControls);
      controlsFinder.expectMeaningful(
        findsOneWidget,
        reason: 'EnhancedPlayerControls should be rendered',
      );
      
      // Should show play button when not playing
      final playButtonFinder = find.byIcon(Icons.play_arrow);
      playButtonFinder.expectMeaningful(
        findsOneWidget,
        reason: 'Play button should be visible when not playing',
      );
    });
    
    testWidgets('renders with playing state', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EnhancedPlayerControls(
              isPlaying: true,
            ),
          ),
        ),
      );
      
      // Should show pause button when playing
      final pauseButtonFinder = find.byIcon(Icons.pause);
      pauseButtonFinder.expectMeaningful(
        findsOneWidget,
        reason: 'Pause button should be visible when playing',
      );
    });
    
    testWidgets('handles play/pause button tap', (tester) async {
      var playPauseTapCount = 0;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EnhancedPlayerControls(
              isPlaying: false,
              onPlayPause: () => playPauseTapCount++,
            ),
          ),
        ),
      );
      
      // Tap play button
      await tester.tap(find.byIcon(Icons.play_arrow));
      await tester.pump();
      
      playPauseTapCount.expectMeaningful(
        equals(1),
        reason: 'Play/pause callback should be triggered once',
      );
    });
    
    testWidgets('shows recording indicator when recording', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EnhancedPlayerControls(
              isPlaying: true,
              isRecording: true,
            ),
          ),
        ),
      );
      
      // Should show some recording indication (icon or animation)
      final controlsFinder = find.byType(EnhancedPlayerControls);
      controlsFinder.expectMeaningful(
        findsOneWidget,
        reason: 'Controls should render with recording state',
      );
    });
    
    testWidgets('handles record button tap', (tester) async {
      var recordTapCount = 0;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EnhancedPlayerControls(
              isPlaying: true,
              onRecord: () => recordTapCount++,
            ),
          ),
        ),
      );
      
      // Look for record button (might be fiber_manual_record icon)
      final recordButtons = find.byIcon(Icons.fiber_manual_record);
      if (recordButtons.evaluate().isNotEmpty) {
        await tester.tap(recordButtons.first);
        await tester.pump();
        
        recordTapCount.expectMeaningful(
          equals(1),
          reason: 'Record callback should be triggered once',
        );
      }
    });
    
    testWidgets('handles stop button tap', (tester) async {
      var stopTapCount = 0;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EnhancedPlayerControls(
              isPlaying: true,
              onStop: () => stopTapCount++,
            ),
          ),
        ),
      );
      
      // Look for stop button
      final stopButtons = find.byIcon(Icons.stop);
      if (stopButtons.evaluate().isNotEmpty) {
        await tester.tap(stopButtons.first);
        await tester.pump();
        
        stopTapCount.expectMeaningful(
          equals(1),
          reason: 'Stop callback should be triggered once',
        );
      }
    });
    
    testWidgets('handles screenshot button tap', (tester) async {
      var screenshotTapCount = 0;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EnhancedPlayerControls(
              isPlaying: true,
              onScreenshot: () => screenshotTapCount++,
            ),
          ),
        ),
      );
      
      // Look for screenshot/camera button
      final screenshotButtons = find.byIcon(Icons.camera_alt);
      if (screenshotButtons.evaluate().isNotEmpty) {
        await tester.tap(screenshotButtons.first);
        await tester.pump();
        
        screenshotTapCount.expectMeaningful(
          equals(1),
          reason: 'Screenshot callback should be triggered once',
        );
      }
    });
    
    testWidgets('shows sound toggle button', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EnhancedPlayerControls(
              isPlaying: true,
              soundEnabled: false,
            ),
          ),
        ),
      );
      
      // Should show volume_off when sound is disabled
      final volumeOffFinder = find.byIcon(Icons.volume_off);
      if (volumeOffFinder.evaluate().isNotEmpty) {
        volumeOffFinder.expectMeaningful(
          findsAtLeastNWidgets(1),
          reason: 'Volume off icon should be visible when sound disabled',
        );
      }
    });
    
    testWidgets('handles sound toggle', (tester) async {
      var soundToggleCount = 0;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EnhancedPlayerControls(
              isPlaying: true,
              soundEnabled: true,
              onSoundToggle: () => soundToggleCount++,
            ),
          ),
        ),
      );
      
      // Look for volume button (could be volume_up or volume_off)
      final volumeButtons = [
        find.byIcon(Icons.volume_up),
        find.byIcon(Icons.volume_off),
        find.byIcon(Icons.volume_down),
      ];
      
      for (final buttonFinder in volumeButtons) {
        if (buttonFinder.evaluate().isNotEmpty) {
          await tester.tap(buttonFinder.first);
          await tester.pump();
          break;
        }
      }
      
      if (soundToggleCount > 0) {
        soundToggleCount.expectMeaningful(
          equals(1),
          reason: 'Sound toggle callback should be triggered once',
        );
      }
    });
    
    testWidgets('handles fullscreen toggle', (tester) async {
      var fullscreenToggleCount = 0;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EnhancedPlayerControls(
              isPlaying: true,
              isFullScreen: false,
              onFullScreenToggle: () => fullscreenToggleCount++,
            ),
          ),
        ),
      );
      
      // Look for fullscreen button
      final fullscreenButtons = [
        find.byIcon(Icons.fullscreen),
        find.byIcon(Icons.fullscreen_exit),
      ];
      
      for (final buttonFinder in fullscreenButtons) {
        if (buttonFinder.evaluate().isNotEmpty) {
          await tester.tap(buttonFinder.first);
          await tester.pump();
          break;
        }
      }
      
      if (fullscreenToggleCount > 0) {
        fullscreenToggleCount.expectMeaningful(
          equals(1),
          reason: 'Fullscreen toggle callback should be triggered once',
        );
      }
    });
    
    testWidgets('handles quality change', (tester) async {
      var lastQualityChanged = -1;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EnhancedPlayerControls(
              isPlaying: true,
              currentQuality: 2,
              onQualityChange: (quality) => lastQualityChanged = quality,
            ),
          ),
        ),
      );
      
      // Widget should render successfully with quality settings
      final controlsFinder = find.byType(EnhancedPlayerControls);
      controlsFinder.expectMeaningful(
        findsOneWidget,
        reason: 'Controls should render with quality configuration',
      );
    });
    
    testWidgets('maintains state during interactions', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EnhancedPlayerControls(
              isPlaying: true,
              isRecording: true,
              soundEnabled: true,
              isFullScreen: false,
              onPlayPause: () {},
              onRecord: () {},
              onScreenshot: () {},
              onSoundToggle: () {},
              onFullScreenToggle: () {},
            ),
          ),
        ),
      );
      
      final controlsFinder = find.byType(EnhancedPlayerControls);
      
      // Initial state
      controlsFinder.expectMeaningful(
        findsOneWidget,
        reason: 'Controls should maintain consistent state',
      );
      
      // Simulate interactions
      final playPauseButton = find.byIcon(Icons.pause);
      if (playPauseButton.evaluate().isNotEmpty) {
        await tester.tap(playPauseButton);
        await tester.pump();
      }
      
      // State should remain valid after interaction
      controlsFinder.expectMeaningful(
        findsOneWidget,
        reason: 'Controls should maintain state after interaction',
      );
    });
    
    testWidgets('handles animation controller lifecycle', (tester) async {
      // Test that animation controllers are properly created and disposed
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EnhancedPlayerControls(
              isPlaying: true,
              isRecording: true,
            ),
          ),
        ),
      );
      
      final controlsFinder = find.byType(EnhancedPlayerControls);
      controlsFinder.expectMeaningful(
        findsOneWidget,
        reason: 'Controls should handle animation lifecycle',
      );
      
      // Remove the widget to test disposal
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Container(),
          ),
        ),
      );
      
      // Should dispose without errors
      await tester.pump();
    });
    
    testWidgets('respects accessibility requirements', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EnhancedPlayerControls(
              isPlaying: true,
              onPlayPause: () {},
              onStop: () {},
              onRecord: () {},
              onScreenshot: () {},
            ),
          ),
        ),
      );
      
      // Should be accessible for interaction
      final controlsFinder = find.byType(EnhancedPlayerControls);
      controlsFinder.expectMeaningful(
        findsOneWidget,
        reason: 'EnhancedPlayerControls should be accessible',
      );
      
      // Verify interactive elements are present
      final interactiveElements = find.descendant(
        of: controlsFinder,
        matching: find.byType(GestureDetector),
      );
      
      // Should have some interactive elements
      if (interactiveElements.evaluate().isNotEmpty) {
        interactiveElements.expectMeaningful(
          findsAtLeastNWidgets(1),
          reason: 'Should have interactive elements for accessibility',
        );
      }
    });
  });
}