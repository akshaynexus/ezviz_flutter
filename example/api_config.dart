/// Configuration for API examples.
///
/// IMPORTANT: Replace placeholder values with your actual EZVIZ API credentials
/// and device serial numbers before running the examples.
class ApiConfig {
  // Authentication Option 1: Use appKey and appSecret (API will get access token)
  static const String appKey = 'YOUR_APP_KEY';
  static const String appSecret = 'YOUR_APP_SECRET';

  // Authentication Option 2: Use access token directly (recommended if you have it)
  static const String accessToken = 'YOUR_ACCESS_TOKEN';
  static const String areaDomain =
      'YOUR_AREA_DOMAIN'; // Optional, for access token auth

  // Replace with a real device serial for general device tests
  static const String exampleDeviceSerial = 'YOUR_DEVICE_SERIAL';
  // Replace with a real PTZ-capable device serial for PTZ tests
  static const String examplePtzDeviceSerial = 'YOUR_PTZ_DEVICE_SERIAL';
  // Replace with the serial number of your EZVIZ A1 Hub (or similar detector hub)
  static const String exampleA1HubSerial = 'YOUR_A1_HUB_DEVICE_SERIAL';
  // Replace with a serial of a detector linked to the A1 hub for some tests
  static const String exampleLinkedDetectorSerial =
      'YOUR_LINKED_DETECTOR_SERIAL';
  // If needed for operations like add/disable encryption
  static const String exampleValidateCode = 'YOUR_VALIDATE_CODE';
  // If testing enableCloudStorage
  static const String exampleCloudCardPassword = 'YOUR_CLOUD_CARD_PASSWORD';

  // For RAM Account examples - these might be the same as appKey/appSecret if using main account token for RAM ops
  static const String mainAccountAppKey = 'YOUR_MAIN_ACCOUNT_APP_KEY';
  static const String mainAccountAppSecret = 'YOUR_MAIN_ACCOUNT_APP_SECRET';
}
