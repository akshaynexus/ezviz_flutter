/// A comprehensive Flutter/Dart library for EZVIZ camera API integration.
///
/// This library provides a complete SDK for integrating with EZVIZ cameras,
/// including authentication, device management, live streaming, PTZ control,
/// alarm management, and more.

// Core API client
export 'src/ezviz_client.dart';

// Authentication
export 'src/auth/auth_service.dart';

// Device Management
export 'src/device/device_service.dart';

// Live Streaming
export 'src/live/live_service.dart';

// PTZ Control
export 'src/ptz/ptz_service.dart';

// Alarm Management
export 'src/alarm/alarm_service.dart';

// Detector Management (for A1 series)
export 'src/detector/detector_service.dart';

// Cloud Storage
export 'src/cloud/cloud_storage_service.dart';

// RAM Account (Sub-Account) Management
export 'src/ram/ram_account_service.dart';

// Models
export 'src/models/models.dart';

// Exceptions
export 'src/exceptions/ezviz_exceptions.dart';

// Constants
export 'src/constants/ezviz_constants.dart';
