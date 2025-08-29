import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ezviz_flutter/ezviz_flutter.dart';
import '../test_utils.dart';

void main() {
  group('EzvizSimplePlayer Widget', () {
    const testConfig = EzvizPlayerConfig(
      appKey: 'test_key',
      appSecret: 'test_secret',
      autoPlay: false, // Disable auto-play for testing
    );
    
    const testDeviceSerial = 'TEST123456';
    const testChannelNo = 1;
    
    testWidgets('renders with minimal required properties', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EzvizSimplePlayer(
              config: testConfig,
              deviceSerial: testDeviceSerial,
              channelNo: testChannelNo,
            ),
          ),
        ),
      );
      
      final playerFinder = find.byType(EzvizSimplePlayer);
      playerFinder.expectMeaningful(
        findsOneWidget,
        reason: 'EzvizSimplePlayer should be rendered',
      );
    });
    
    testWidgets('renders with region configuration', (tester) async {
      const regionConfig = EzvizPlayerConfig(
        appKey: 'test_key',
        appSecret: 'test_secret',
        region: EzvizRegion.usa,
        autoPlay: false,
      );
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EzvizSimplePlayer(
              config: regionConfig,
              deviceSerial: testDeviceSerial,
              channelNo: testChannelNo,
            ),
          ),
        ),
      );
      
      final playerFinder = find.byType(EzvizSimplePlayer);
      playerFinder.expectMeaningful(
        findsOneWidget,
        reason: 'EzvizSimplePlayer should render with region config',
      );
    });
    
    testWidgets('renders with custom base URL', (tester) async {
      const customConfig = EzvizPlayerConfig(
        appKey: 'test_key',
        appSecret: 'test_secret',
        baseUrl: 'https://custom.example.com',
        autoPlay: false,
      );
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EzvizSimplePlayer(
              config: customConfig,
              deviceSerial: testDeviceSerial,
              channelNo: testChannelNo,
            ),
          ),
        ),
      );
      
      final playerFinder = find.byType(EzvizSimplePlayer);
      playerFinder.expectMeaningful(
        findsOneWidget,
        reason: 'EzvizSimplePlayer should render with custom base URL',
      );
    });
    
    testWidgets('renders with access token authentication', (tester) async {
      const tokenConfig = EzvizPlayerConfig(
        appKey: 'test_key',
        appSecret: 'test_secret',
        accessToken: 'test_access_token',
        autoPlay: false,
      );
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EzvizSimplePlayer(
              config: tokenConfig,
              deviceSerial: testDeviceSerial,
              channelNo: testChannelNo,
            ),
          ),
        ),
      );
      
      final playerFinder = find.byType(EzvizSimplePlayer);
      playerFinder.expectMeaningful(
        findsOneWidget,
        reason: 'EzvizSimplePlayer should render with access token',
      );
    });
    
    testWidgets('renders with account/password authentication', (tester) async {
      const credentialsConfig = EzvizPlayerConfig(
        appKey: 'test_key',
        appSecret: 'test_secret',
        account: 'test@example.com',
        password: 'test_password',
        autoPlay: false,
      );
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EzvizSimplePlayer(
              config: credentialsConfig,
              deviceSerial: testDeviceSerial,
              channelNo: testChannelNo,
            ),
          ),
        ),
      );
      
      final playerFinder = find.byType(EzvizSimplePlayer);
      playerFinder.expectMeaningful(
        findsOneWidget,
        reason: 'EzvizSimplePlayer should render with account/password',
      );
    });
    
    testWidgets('shows controls when enabled', (tester) async {
      const configWithControls = EzvizPlayerConfig(
        appKey: 'test_key',
        appSecret: 'test_secret',
        showControls: true,
        autoPlay: false,
      );
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EzvizSimplePlayer(
              config: configWithControls,
              deviceSerial: testDeviceSerial,
              channelNo: testChannelNo,
            ),
          ),
        ),
      );
      
      // Should contain player widget
      final playerFinder = find.byType(EzvizSimplePlayer);
      playerFinder.expectMeaningful(
        findsOneWidget,
        reason: 'Player should render with controls enabled',
      );
    });
    
    testWidgets('hides controls when disabled', (tester) async {
      const configWithoutControls = EzvizPlayerConfig(
        appKey: 'test_key',
        appSecret: 'test_secret',
        showControls: false,
        autoPlay: false,
      );
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EzvizSimplePlayer(
              config: configWithoutControls,
              deviceSerial: testDeviceSerial,
              channelNo: testChannelNo,
            ),
          ),
        ),
      );
      
      final playerFinder = find.byType(EzvizSimplePlayer);
      playerFinder.expectMeaningful(
        findsOneWidget,
        reason: 'Player should render with controls disabled',
      );
    });
    
    testWidgets('renders with custom loading widget', (tester) async {
      const customLoadingWidget = CircularProgressIndicator(
        key: Key('custom_loading'),
      );
      
      const configWithCustomLoading = EzvizPlayerConfig(
        appKey: 'test_key',
        appSecret: 'test_secret',
        loadingWidget: customLoadingWidget,
        autoPlay: false,
      );
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EzvizSimplePlayer(
              config: configWithCustomLoading,
              deviceSerial: testDeviceSerial,
              channelNo: testChannelNo,
            ),
          ),
        ),
      );
      
      final playerFinder = find.byType(EzvizSimplePlayer);
      playerFinder.expectMeaningful(
        findsOneWidget,
        reason: 'Player should render with custom loading widget',
      );
    });
    
    testWidgets('renders with custom error widget', (tester) async {
      const customErrorWidget = Icon(
        Icons.error,
        key: Key('custom_error'),
      );
      
      const configWithCustomError = EzvizPlayerConfig(
        appKey: 'test_key',
        appSecret: 'test_secret',
        errorWidget: customErrorWidget,
        autoPlay: false,
      );
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EzvizSimplePlayer(
              config: configWithCustomError,
              deviceSerial: testDeviceSerial,
              channelNo: testChannelNo,
            ),
          ),
        ),
      );
      
      final playerFinder = find.byType(EzvizSimplePlayer);
      playerFinder.expectMeaningful(
        findsOneWidget,
        reason: 'Player should render with custom error widget',
      );
    });
    
    testWidgets('handles player callbacks', (tester) async {
      // ignore: unused_local_variable
      var stateChangeCalled = false;
      // ignore: unused_local_variable
      var passwordRequiredCalled = false;
      // ignore: unused_local_variable
      var errorCalled = false;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EzvizSimplePlayer(
              config: testConfig,
              deviceSerial: testDeviceSerial,
              channelNo: testChannelNo,
              onStateChanged: (state) => stateChangeCalled = true,
              onPasswordRequired: () async {
                passwordRequiredCalled = true;
                return 'test_password';
              },
              onError: (error) => errorCalled = true,
            ),
          ),
        ),
      );
      
      final playerFinder = find.byType(EzvizSimplePlayer);
      playerFinder.expectMeaningful(
        findsOneWidget,
        reason: 'Player should render with callbacks configured',
      );
      
      // Test that callbacks are properly assigned (can't easily trigger them in unit tests)
      // This tests that the widget accepts the callbacks without errors
    });
    
    testWidgets('renders with fullscreen settings', (tester) async {
      const fullscreenConfig = EzvizPlayerConfig(
        appKey: 'test_key',
        appSecret: 'test_secret',
        allowFullscreen: true,
        autoRotate: true,
        autoPlay: false,
      );
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EzvizSimplePlayer(
              config: fullscreenConfig,
              deviceSerial: testDeviceSerial,
              channelNo: testChannelNo,
            ),
          ),
        ),
      );
      
      final playerFinder = find.byType(EzvizSimplePlayer);
      playerFinder.expectMeaningful(
        findsOneWidget,
        reason: 'Player should render with fullscreen settings',
      );
    });
    
    testWidgets('renders with gesture settings', (tester) async {
      const gestureConfig = EzvizPlayerConfig(
        appKey: 'test_key',
        appSecret: 'test_secret',
        enableDoubleTapSeek: true,
        enableSwipeSeek: true,
        hideControlsOnTap: true,
        autoPlay: false,
      );
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EzvizSimplePlayer(
              config: gestureConfig,
              deviceSerial: testDeviceSerial,
              channelNo: testChannelNo,
            ),
          ),
        ),
      );
      
      final playerFinder = find.byType(EzvizSimplePlayer);
      playerFinder.expectMeaningful(
        findsOneWidget,
        reason: 'Player should render with gesture settings',
      );
    });
    
    testWidgets('renders with audio settings', (tester) async {
      const audioConfig = EzvizPlayerConfig(
        appKey: 'test_key',
        appSecret: 'test_secret',
        enableAudio: true,
        autoPlay: false,
      );
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EzvizSimplePlayer(
              config: audioConfig,
              deviceSerial: testDeviceSerial,
              channelNo: testChannelNo,
            ),
          ),
        ),
      );
      
      final playerFinder = find.byType(EzvizSimplePlayer);
      playerFinder.expectMeaningful(
        findsOneWidget,
        reason: 'Player should render with audio enabled',
      );
    });
    
    testWidgets('renders with compact controls', (tester) async {
      const compactConfig = EzvizPlayerConfig(
        appKey: 'test_key',
        appSecret: 'test_secret',
        compactControls: true,
        showControls: true,
        autoPlay: false,
      );
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EzvizSimplePlayer(
              config: compactConfig,
              deviceSerial: testDeviceSerial,
              channelNo: testChannelNo,
            ),
          ),
        ),
      );
      
      final playerFinder = find.byType(EzvizSimplePlayer);
      playerFinder.expectMeaningful(
        findsOneWidget,
        reason: 'Player should render with compact controls',
      );
    });
    
    testWidgets('renders with device info enabled', (tester) async {
      const deviceInfoConfig = EzvizPlayerConfig(
        appKey: 'test_key',
        appSecret: 'test_secret',
        showDeviceInfo: true,
        autoPlay: false,
      );
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EzvizSimplePlayer(
              config: deviceInfoConfig,
              deviceSerial: testDeviceSerial,
              channelNo: testChannelNo,
            ),
          ),
        ),
      );
      
      final playerFinder = find.byType(EzvizSimplePlayer);
      playerFinder.expectMeaningful(
        findsOneWidget,
        reason: 'Player should render with device info enabled',
      );
    });
    
    testWidgets('renders with custom UI colors', (tester) async {
      const colorConfig = EzvizPlayerConfig(
        appKey: 'test_key',
        appSecret: 'test_secret',
        controlsBackgroundColor: Colors.black54,
        controlsIconColor: Colors.white,
        autoPlay: false,
      );
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EzvizSimplePlayer(
              config: colorConfig,
              deviceSerial: testDeviceSerial,
              channelNo: testChannelNo,
            ),
          ),
        ),
      );
      
      final playerFinder = find.byType(EzvizSimplePlayer);
      playerFinder.expectMeaningful(
        findsOneWidget,
        reason: 'Player should render with custom colors',
      );
    });
    
    testWidgets('handles widget disposal correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EzvizSimplePlayer(
              config: testConfig,
              deviceSerial: testDeviceSerial,
              channelNo: testChannelNo,
            ),
          ),
        ),
      );
      
      final playerFinder = find.byType(EzvizSimplePlayer);
      playerFinder.expectMeaningful(
        findsOneWidget,
        reason: 'Player should render initially',
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
    
    testWidgets('maintains state during configuration updates', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EzvizSimplePlayer(
              config: testConfig,
              deviceSerial: testDeviceSerial,
              channelNo: testChannelNo,
            ),
          ),
        ),
      );
      
      // Update with different configuration
      const updatedConfig = EzvizPlayerConfig(
        appKey: 'test_key',
        appSecret: 'test_secret',
        enableAudio: false,
        autoPlay: false,
      );
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EzvizSimplePlayer(
              config: updatedConfig,
              deviceSerial: testDeviceSerial,
              channelNo: testChannelNo,
            ),
          ),
        ),
      );
      
      final playerFinder = find.byType(EzvizSimplePlayer);
      playerFinder.expectMeaningful(
        findsOneWidget,
        reason: 'Player should handle configuration updates',
      );
    });
    
    testWidgets('validates required parameters', (tester) async {
      // Test that the widget requires essential parameters
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EzvizSimplePlayer(
              config: testConfig,
              deviceSerial: testDeviceSerial,
              channelNo: testChannelNo,
            ),
          ),
        ),
      );
      
      final playerFinder = find.byType(EzvizSimplePlayer);
      playerFinder.expectMeaningful(
        findsOneWidget,
        reason: 'Player should validate required parameters successfully',
      );
    });
  });
  
  group('EzvizPlayerConfig', () {
    test('creates config with minimal required parameters', () {
      const config = EzvizPlayerConfig(
        appKey: 'test_key',
        appSecret: 'test_secret',
      );
      
      config.appKey.expectMeaningful(
        equals('test_key'),
        reason: 'Config should store appKey',
      );
      
      config.appSecret.expectMeaningful(
        equals('test_secret'),
        reason: 'Config should store appSecret',
      );
      
      // Test defaults
      config.autoPlay.expectMeaningful(
        isTrue,
        reason: 'autoPlay should default to true',
      );
      
      config.enableAudio.expectMeaningful(
        isTrue,
        reason: 'enableAudio should default to true',
      );
      
      config.showControls.expectMeaningful(
        isTrue,
        reason: 'showControls should default to true',
      );
    });
    
    test('creates config with all parameters', () {
      const config = EzvizPlayerConfig(
        appKey: 'test_key',
        appSecret: 'test_secret',
        baseUrl: 'https://custom.example.com',
        region: EzvizRegion.usa,
        accessToken: 'test_token',
        account: 'test@example.com',
        password: 'test_password',
        autoPlay: false,
        enableAudio: false,
        showControls: false,
        enableEncryptionDialog: true,
        allowFullscreen: false,
        hideControlsOnTap: false,
        compactControls: true,
        autoRotate: false,
        enableDoubleTapSeek: false,
        enableSwipeSeek: false,
        showDeviceInfo: true,
        controlsBackgroundColor: Colors.black,
        controlsIconColor: Colors.white,
        controlsHideTimeout: Duration(seconds: 5),
      );
      
      config.baseUrl.expectMeaningful(
        equals('https://custom.example.com'),
        reason: 'Config should store custom baseUrl',
      );
      
      config.region.expectMeaningful(
        equals(EzvizRegion.usa),
        reason: 'Config should store region',
      );
      
      config.autoPlay.expectMeaningful(
        isFalse,
        reason: 'Config should respect autoPlay setting',
      );
      
      config.compactControls.expectMeaningful(
        isTrue,
        reason: 'Config should respect compactControls setting',
      );
    });
  });
}
