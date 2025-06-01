# EZVIZ Flutter SDK

A comprehensive Flutter/Dart library for seamless integration with the EZVIZ Camera API. This SDK empowers developers to build applications that can interact with EZVIZ cameras, providing functionalities like authentication, device management, live streaming, PTZ control, alarm management, cloud storage interaction, and sub-account (RAM) management.

Looking for a example on how to use this,check out this repo which implements api auth,devvice list getting and display of camera stream 
https://github.com/akshaynexus/ezviz_flutter_example_app


## Features

*   **Modern Dart Implementation**: Null-safe, asynchronous, and follows Dart best practices.
*   **Flexible Authentication**: Support for both direct access token authentication and automatic token fetching via app credentials.
*   **Comprehensive Service Coverage**:
    *   `AuthService`: Handles authentication.
    *   `DeviceService`: Manage devices (add, delete, edit), fetch device/camera lists and information, control device functions (defence mode, encryption, timezone, audio, PIR, etc.), and utilize V3 APIs (fill light, working modes).
    *   `LiveService`: Get live video stream addresses (HLS, RTMP, FLV).
    *   `PtzService`: Control Pan-Tilt-Zoom functions (start, stop, presets, mirror).
    *   `AlarmService`: Fetch alarm lists and manage alarm read status.
    *   `DetectorService`: Manage detectors linked to A1 Hubs (list, status, linkage, naming).
    *   `CloudStorageService`: Get cloud storage information and enable cloud services.
    *   `RamAccountService`: Manage sub-accounts (create, list, info, token, policy).
*   **Typed Models**: Clear and easy-to-use Dart classes for API request and response data, leveraging `json_serializable`.
*   **Custom Exceptions**: Specific exceptions (`EzvizAuthException`, `EzvizApiException`) for better error handling.
*   **Example Applications**: Ready-to-run examples for each service to demonstrate usage.
*   **Integration Tests**: A suite of tests to ensure API methods function as expected (requires configuration).

## Getting Started

### Prerequisites

*   Flutter SDK: Ensure you have Flutter installed.
*   Dart SDK: Included with Flutter.
*   An EZVIZ Developer Account: You'll need either:
    *   An access token (recommended) OR
    *   An `appKey` and `appSecret` from the [EZVIZ Open Platform](https://open.ezviz.com/)

### Installation

1.  Add this to your package's `pubspec.yaml` file:

    ```yaml
    dependencies:
      ezviz_flutter: ^1.0.0 # Replace with the latest version
    ```

2.  Install the package from your terminal:

    ```bash
    flutter pub get
    ```

3.  Import the library in your Dart code:

    ```dart
    import 'package:ezviz_flutter/ezviz_flutter.dart';
    ```

## Authentication Options

The EZVIZ Flutter SDK supports two authentication methods:

### Method 1: Direct Access Token (Recommended)

If you already have an access token, this is the fastest and recommended approach:

```dart
import 'package:ezviz_flutter/ezviz_flutter.dart';

void main() async {
  // Initialize with access token
  final client = EzvizClient(
    accessToken: 'your_access_token_here',
    areaDomain: 'your_area_domain_here', // Optional
  );

  final deviceService = DeviceService(client);
  
  try {
    final deviceListResponse = await deviceService.getDeviceList(pageSize: 5);
    print('Device list: $deviceListResponse');
  } catch (e) {
    print('Error: $e');
  }
}
```

### Method 2: App Key + Secret Authentication

The library will automatically obtain and manage access tokens:

```dart
import 'package:ezviz_flutter/ezviz_flutter.dart';

void main() async {
  // Initialize with app credentials
  final client = EzvizClient(
    appKey: 'your_app_key_here',
    appSecret: 'your_app_secret_here',
  );

  final deviceService = DeviceService(client);
  
  try {
    // First API call will automatically authenticate
    final deviceListResponse = await deviceService.getDeviceList(pageSize: 5);
    print('Device list: $deviceListResponse');
  } catch (e) {
    print('Error: $e');
  }
}
```

## Basic Usage

```dart
import 'package:ezviz_flutter/ezviz_flutter.dart';

void main() async {
  // Choose your authentication method
  final client = EzvizClient(
    // Option 1: Direct access token (recommended)
    accessToken: 'your_access_token',
    areaDomain: 'your_area_domain', // Optional
    
    // Option 2: App credentials (alternative)
    // appKey: 'your_app_key',
    // appSecret: 'your_app_secret',
  );

  final deviceService = DeviceService(client);

  try {
    print('Fetching device list...');
    final deviceListResponse = await deviceService.getDeviceList(pageSize: 5);

    if (deviceListResponse['code'] == '200') {
      print('Successfully fetched devices:');
      if (deviceListResponse['data'] != null && (deviceListResponse['data'] as List).isNotEmpty) {
        (deviceListResponse['data'] as List).forEach((device) {
          print('  - Device Name: ${device['deviceName']}, Serial: ${device['deviceSerial']}');
        });
      } else {
        print('No devices found or data is null.');
      }
    } else {
      print('Error fetching devices: ${deviceListResponse['msg']} (Code: ${deviceListResponse['code']})');
    }

  } on EzvizAuthException catch (e) {
    print('Authentication failed: ${e.message} (Code: ${e.code})');
  } on EzvizApiException catch (e) {
    print('EZVIZ API Error: ${e.message} (Code: ${e.code})');
  } catch (e) {
    print('An unexpected error occurred: $e');
  }
}
```

## API Credentials and Configuration

### For Direct Library Usage

Choose one of these authentication methods:

```dart
// Method 1: Access Token (Recommended)
final client = EzvizClient(
  accessToken: 'your_access_token',
  areaDomain: 'your_area_domain', // Optional
);

// Method 2: App Credentials
final client = EzvizClient(
  appKey: 'your_app_key',
  appSecret: 'your_app_secret',
);
```

### For Running Examples and Tests

Modify the `example/api_config.dart` file with your credentials:

```dart
// example/api_config.dart
class ApiConfig {
  // Authentication Option 1: Use appKey and appSecret (API will get access token)
  static const String appKey = 'YOUR_APP_KEY';
  static const String appSecret = 'YOUR_APP_SECRET';

  // Authentication Option 2: Use access token directly (recommended if you have it)
  static const String accessToken = 'YOUR_ACCESS_TOKEN';
  static const String areaDomain = 'YOUR_AREA_DOMAIN'; // Optional

  // Device configuration for examples
  static const String exampleDeviceSerial = 'YOUR_TEST_DEVICE_SERIAL';
  static const String examplePtzDeviceSerial = 'YOUR_PTZ_DEVICE_SERIAL';
  static const String exampleA1HubSerial = 'YOUR_A1_HUB_SERIAL';
  static const String exampleLinkedDetectorSerial = 'YOUR_LINKED_DETECTOR_SERIAL';
  
  // For RAM account operations
  static const String mainAccountAppKey = 'YOUR_MAIN_ACCOUNT_APP_KEY_FOR_RAM_OPS';
  static const String mainAccountAppSecret = 'YOUR_MAIN_ACCOUNT_APP_SECRET_FOR_RAM_OPS';
}
```

**IMPORTANT**: Do not commit your actual keys, secrets, or tokens to public repositories. Use environment variables or a gitignored configuration file for production applications.

## Available Services

The library is organized into services, each corresponding to a set of related API functionalities:

*   `EzvizClient`: The core client that manages authentication and makes HTTP requests. All services require an `EzvizClient` instance.
*   `AuthService`: Provides an explicit `login()` method, though authentication is typically handled automatically by `EzvizClient`.
*   `DeviceService`: For all device-related operations.
*   `LiveService`: To obtain live stream URLs.
*   `PtzService`: For controlling PTZ cameras.
*   `AlarmService`: For fetching and managing alarm notifications.
*   `DetectorService`: Specifically for managing detectors connected to hubs like the A1.
*   `CloudStorageService`: For interacting with EZVIZ cloud storage services.
*   `RamAccountService`: For managing sub-accounts under your main EZVIZ account.

Each service method generally returns a `Future<Map<String, dynamic>>` representing the JSON response from the API. For paged results, the response often includes a `page` object with details like `total`, `page`, and `size`.

## Running the Examples

The `example/` directory contains sample Dart console applications for each service.

1.  **Configure Credentials**: Ensure `example/api_config.dart` is correctly configured with your `appKey`, `appSecret`, and any necessary device serials.
2.  **Run an Example**:
    Navigate to the root of the project and run the desired example file, for instance:

    ```bash
    dart example/device_service_example.dart
    ```

    Replace `device_service_example.dart` with the example you wish to run.

## Running Tests

The library includes a suite of integration tests in the `test/` directory. These tests make real API calls.

1.  **Configure Credentials**: Ensure `example/api_config.dart` is correctly configured as the tests use this file for API keys and device serials.
    **Warning**: Some tests (like PTZ tests or RAM account management) can modify device or account state. Run tests in a controlled environment, preferably with dedicated test devices/accounts.
2.  **Run Tests**:
    From the project root directory:

    ```bash
    flutter test
    ```
    This will execute all tests defined in `_test.dart` files within the `test` directory.

## Models

The library uses `json_serializable` to define Dart models for various API responses and data structures (found in `lib/src/models/`). This provides type safety and easier data handling. When new models are added or existing ones are modified, you may need to run the build runner:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

## Error Handling

The library defines custom exceptions:
*   `EzvizException`: Base exception.
*   `EzvizAuthException`: For authentication-specific errors (e.g., invalid appKey/appSecret, token errors).
*   `EzvizApiException`: For general API errors returned by EZVIZ (e.g., bad request, device offline, permission denied). The `code` and `message` from the API response are available, along with the full `response` map.

Always wrap API calls in `try-catch` blocks to handle these potential exceptions.

## Contributing

Contributions are welcome! If you'd like to contribute, please:
1.  Fork the repository.
2.  Create a new branch for your feature or bug fix.
3.  Write tests for your changes.
4.  Ensure all tests pass.
5.  Submit a pull request.

## License
`License: MIT`

---

*This README provides a general overview. For detailed API parameters and response structures, refer to the official EZVIZ Open Platform documentation and the Dartdoc comments within the library code.*
