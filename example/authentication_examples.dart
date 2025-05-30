import 'package:ezviz_flutter/ezviz_flutter.dart';

void main() async {
  print('=== EZVIZ Flutter Authentication Examples ===\n');

  // Example 1: Direct Access Token Authentication (Recommended)
  await demonstrateAccessTokenAuth();

  // Example 2: App Key + Secret Authentication
  await demonstrateAppKeySecretAuth();

  // Example 3: Error Handling
  demonstrateErrorHandling();
}

/// Example 1: Direct Access Token Authentication
///
/// This is the recommended approach if you already have an access token.
/// It's faster since it skips the API authentication step.
Future<void> demonstrateAccessTokenAuth() async {
  print('🔑 Method 1: Direct Access Token Authentication');
  print('==============================================');

  try {
    // Replace with your actual access token
    const accessToken = 'your_actual_access_token_here';
    const areaDomain = 'your_area_domain_here'; // Optional

    final client = EzvizClient(
      accessToken: accessToken,
      areaDomain: areaDomain, // Optional - can be null
    );

    // Create a service (example with device service)
    // ignore: unused_local_variable
    final deviceService = DeviceService(client);

    print('✅ Client created with access token');
    print('📱 Ready to make API calls...');

    // Example API call - uncomment when you have a real access token
    // final devices = await deviceService.getDeviceList();
    // print('Devices: $devices');
  } catch (e) {
    if (e is EzvizAuthException) {
      print('❌ Authentication Error: ${e.message}');
      print('   Code: ${e.code}');
      print('   💡 Tip: Check if your access token is valid and not expired');
    } else {
      print('❌ Error: $e');
    }
  }

  print('');
}

/// Example 2: App Key + Secret Authentication
///
/// This method will automatically obtain an access token using your app credentials.
/// The access token will be cached and automatically refreshed when needed.
Future<void> demonstrateAppKeySecretAuth() async {
  print('🔐 Method 2: App Key + Secret Authentication');
  print('==========================================');

  try {
    // Replace with your actual app credentials
    const appKey = 'your_app_key_here';
    const appSecret = 'your_app_secret_here';

    final client = EzvizClient(appKey: appKey, appSecret: appSecret);

    // Create a service (example with alarm service)
    // ignore: unused_local_variable
    final alarmService = AlarmService(client);

    print('✅ Client created with app key + secret');
    print('🔄 Access token will be obtained automatically on first API call');

    // Example API call - uncomment when you have real credentials
    // final alarms = await alarmService.getAlarmList(pageSize: 5);
    // print('Alarms: $alarms');
  } catch (e) {
    if (e is EzvizAuthException) {
      print('❌ Authentication Error: ${e.message}');
      print('   Code: ${e.code}');
      print('   💡 Tip: Check if your app key and secret are correct');
    } else {
      print('❌ Error: $e');
    }
  }

  print('');
}

/// Example 3: Error Handling for Invalid Configuration
void demonstrateErrorHandling() {
  print('⚠️  Error Handling Examples');
  print('==========================');

  try {
    // This will throw an ArgumentError
    // ignore: unused_local_variable
    final client = EzvizClient(); // No parameters provided
    print('This should not print');
  } catch (e) {
    print('❌ Expected error: $e');
  }

  try {
    // This will also throw an ArgumentError
    // ignore: unused_local_variable
    final client = EzvizClient(appKey: 'only_app_key'); // Missing appSecret
    print('This should not print');
  } catch (e) {
    print('❌ Expected error: $e');
  }

  print('✅ Proper error handling demonstrated');
}
