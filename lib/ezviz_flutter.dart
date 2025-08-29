// EZVIZ Flutter SDK - A comprehensive Flutter plugin for EZVIZ camera integration
//
// This library provides native Android and iOS SDK integration for EZVIZ cameras,
// including device management, live streaming, PTZ control, and video playback.
// Library directive removed as it is unnecessary in modern Dart

// Export all EZVIZ SDK components
export 'package:ezviz_flutter/ezviz_definition.dart';
export 'package:ezviz_flutter/ezviz_methods.dart';
export 'package:ezviz_flutter/ezviz_utils.dart';
export 'package:ezviz_flutter/ezviz.dart';
export 'package:ezviz_flutter/ezviz_errorcode.dart';
export 'package:ezviz_flutter/ezviz_player.dart';

// New enhanced features from ezviz_flutter_cam
export 'package:ezviz_flutter/ezviz_audio.dart';
export 'package:ezviz_flutter/ezviz_recording.dart';
export 'package:ezviz_flutter/ezviz_wifi_config.dart';

// New comprehensive native SDK integration
export 'package:ezviz_flutter/ezviz_device_manager.dart';
export 'package:ezviz_flutter/ezviz_auth_manager.dart';
export 'package:ezviz_flutter/ezviz_playback_controller.dart';

// Enhanced UI widgets
export 'package:ezviz_flutter/widgets/ptz_control_panel.dart';
export 'package:ezviz_flutter/widgets/enhanced_player_controls.dart';
export 'package:ezviz_flutter/widgets/ezviz_simple_player.dart';

// Legacy API compatibility - keep existing HTTP-based API
export 'src/ezviz_flutter_base.dart';
export 'src/ezviz_client.dart';
export 'src/models/models.dart';
export 'src/constants/ezviz_constants.dart';
export 'src/exceptions/ezviz_exceptions.dart';

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

// Detector Management
export 'src/detector/detector_service.dart';

// Cloud Storage
export 'src/cloud/cloud_storage_service.dart';

// RAM Account (Sub-Account) Management
export 'src/ram/ram_account_service.dart';
