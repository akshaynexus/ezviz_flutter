import 'package:flutter/material.dart';
import 'package:ezviz_flutter/ezviz_flutter.dart';
import '../../models/camera.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../src/constants/ezviz_constants.dart';
import '../../src/auth/auth_service.dart';

class NativeSDKDemoPage extends StatefulWidget {
  const NativeSDKDemoPage({super.key});

  @override
  State<NativeSDKDemoPage> createState() => _NativeSDKDemoPageState();
}

class _NativeSDKDemoPageState extends State<NativeSDKDemoPage>
    with TickerProviderStateMixin {
  late TabController _tabController;

  // SDK State
  bool _isInitialized = false;
  bool _isInitializing = false;
  String _statusMessage = 'SDK not initialized';

  // HTTP API Client
  EzvizClient? _httpClient;
  bool _isHttpInitialized = false;

  // Device Management
  List<EzvizDeviceInfo> _nativeDevices = [];
  List<Camera> _httpCameras = [];
  bool _isLoadingDevices = false;
  EzvizDeviceInfo? _selectedNativeDevice;
  Camera? _selectedHttpCamera;
  String _selectedAPI = 'HTTP'; // 'HTTP' or 'Native'

  // Video Player
  EzvizPlayerController? _playerController;
  bool _isPlayerInitialized = false;
  String _playerStatus = 'Not initialized';
  int _playerId = 0;
  String? _currentStreamUrl;

  // Audio & Recording
  bool _isRecording = false;
  bool _isAudioEnabled = false;

  // Configuration Forms
  final _appKeyController = TextEditingController();
  final _appSecretController = TextEditingController();
  final _accessTokenController = TextEditingController();
  final _verifyCodeController = TextEditingController();
  final _deviceSerialController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 7, vsync: this);

    // IMPORTANT: Replace these with your actual EZVIZ developer credentials
    // Get them from: https://open.ezvizlife.com/
    _appKeyController.text = 'YOUR_APP_KEY_HERE';
    _appSecretController.text = 'YOUR_APP_SECRET_HERE';
  }

  @override
  void dispose() {
    _tabController.dispose();
    _playerController?.release();
    _appKeyController.dispose();
    _appSecretController.dispose();
    _accessTokenController.dispose();
    _verifyCodeController.dispose();
    _deviceSerialController.dispose();
    super.dispose();
  }

  // HTTP API Initialization Methods
  Future<void> _initializeHTTPAPI() async {
    if (_isHttpInitialized) {
      _showSnackBar('HTTP API already initialized');
      return;
    }

    String appKey = _appKeyController.text.trim();
    String appSecret = _appSecretController.text.trim();

    // BLOCK INITIALIZATION with placeholder credentials
    if (appKey.isEmpty ||
        appSecret.isEmpty ||
        appKey == 'YOUR_APP_KEY_HERE' ||
        appSecret == 'YOUR_APP_SECRET_HERE' ||
        appKey.length < 10 ||
        appSecret.length < 10) {
      setState(() {
        _statusMessage =
            'ERROR: Cannot initialize with placeholder credentials!';
      });
      _showErrorDialog(
        'Placeholder Credentials Detected',
        'CANNOT PROCEED: You are trying to initialize with placeholder credentials.\n\n'
            'Current App Key: "$appKey"\n'
            'Current App Secret: "${appSecret.substring(0, 10)}..."\n\n'
            'These are NOT real EZVIZ credentials!\n\n'
            'To fix this:\n'
            '1. Go to https://open.ezvizlife.com/\n'
            '2. Register for a developer account\n'
            '3. Create an application\n'
            '4. Get your REAL App Key and App Secret\n'
            '5. Replace the placeholder values above\n\n'
            'The app will NOT work until you do this!',
      );
      return; // STOP HERE - don't try to initialize
    }

    setState(() {
      _statusMessage = 'Getting access token from EZVIZ API...';
    });

    try {
      // Create EzvizClient - this will automatically get the access token
      _httpClient = EzvizClient(appKey: appKey, appSecret: appSecret);

      // Trigger authentication by calling the token endpoint
      final authService = AuthService(_httpClient!);
      await authService.login().timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          throw Exception(
            'Authentication timeout - check your credentials and network connection',
          );
        },
      );

      setState(() {
        _isHttpInitialized = true;
        _statusMessage =
            'SUCCESS: HTTP API authenticated with valid access token';
      });

      _showSnackBar('HTTP API authenticated successfully');

      // Load cameras via HTTP API
      _loadHTTPCameras();
    } catch (e) {
      setState(() {
        _isHttpInitialized = false;
        _statusMessage = 'AUTHENTICATION FAILED: ${e.toString()}';
      });

      String errorTitle = 'Authentication Error';
      String errorMessage = e.toString();

      // Parse specific EZVIZ error codes
      if (errorMessage.contains('10017') ||
          errorMessage.toLowerCase().contains("appkey doesn't exist") ||
          errorMessage.toLowerCase().contains("appkey doesn't exist")) {
        errorTitle = '❌ Invalid App Key';
        errorMessage =
            'EZVIZ SERVER RESPONSE: Your App Key does not exist.\n\n'
            'App Key: "$appKey"\n\n'
            'This means:\n'
            '• The App Key is not registered in EZVIZ system\n'
            '• You have a typo in your App Key\n'
            '• Your developer account may be suspended\n\n'
            'SOLUTION:\n'
            '1. Double-check your App Key in EZVIZ developer console\n'
            '2. Make sure you copied it correctly (no extra spaces)\n'
            '3. Verify your developer account is active';
      } else if (errorMessage.contains('10030') ||
          errorMessage.toLowerCase().contains(
            'appkey and appsecret mismatched',
          ) ||
          errorMessage.contains('10002') ||
          errorMessage.toLowerCase().contains('accesstoken expired')) {
        errorTitle = '❌ Invalid App Secret';
        errorMessage =
            'EZVIZ SERVER RESPONSE: App Key and App Secret do not match.\n\n'
            'App Key: "$appKey"\n'
            'App Secret: "${appSecret.substring(0, 10)}..."\n\n'
            'This means:\n'
            '• The App Secret does not match your App Key\n'
            '• You mixed up credentials from different apps\n'
            '• There is a typo in your App Secret\n\n'
            'SOLUTION:\n'
            '1. Verify both App Key and App Secret in EZVIZ console\n'
            '2. Make sure they belong to the same application\n'
            '3. Copy both values again carefully';
      } else if (errorMessage.toLowerCase().contains('timeout')) {
        errorTitle = '🌐 Connection Timeout';
        errorMessage =
            'NETWORK ERROR: Could not connect to EZVIZ servers.\n\n'
            'This could be caused by:\n'
            '• Poor internet connection\n'
            '• EZVIZ servers temporarily unavailable\n'
            '• Firewall blocking the connection\n\n'
            'SOLUTION:\n'
            '1. Check your internet connection\n'
            '2. Try again in a few moments\n'
            '3. Test if you can access https://open.ezvizlife.com/ in browser';
      } else if (errorMessage.contains('10005')) {
        errorTitle = '🚫 App Key Suspended';
        errorMessage =
            'EZVIZ SERVER RESPONSE: Your App Key has been suspended.\n\n'
            'App Key: "$appKey"\n\n'
            'Your EZVIZ developer account has been frozen.\n\n'
            'SOLUTION:\n'
            '1. Contact EZVIZ support immediately\n'
            '2. Check for any policy violations\n'
            '3. Create a new developer account if necessary';
      } else {
        errorTitle = '❌ Unknown Error';
        errorMessage =
            'UNEXPECTED ERROR:\n$errorMessage\n\n'
            'This may be a network issue or server problem.\n\n'
            'SOLUTION:\n'
            '1. Check your internet connection\n'
            '2. Verify your credentials are correct\n'
            '3. Try again in a few minutes';
      }

      _showErrorDialog(errorTitle, errorMessage);
      _showSnackBar('❌ Authentication failed - see error dialog');
    }
  }

  // Native SDK Initialization Methods
  Future<void> _initializeNativeSDK() async {
    if (_isInitializing || _isInitialized) {
      _showSnackBar(
        _isInitialized
            ? 'Native SDK already initialized'
            : 'Initialization in progress',
      );
      return;
    }

    String appKey = _appKeyController.text.trim();
    String appSecret = _appSecretController.text.trim();

    // BLOCK INITIALIZATION with placeholder credentials
    if (appKey.isEmpty ||
        appSecret.isEmpty ||
        appKey == 'YOUR_APP_KEY_HERE' ||
        appSecret == 'YOUR_APP_SECRET_HERE' ||
        appKey.length < 10 ||
        appSecret.length < 10) {
      setState(() {
        _statusMessage =
            'ERROR: Cannot initialize Native SDK with placeholder credentials!';
      });
      _showErrorDialog(
        'Placeholder Credentials Detected',
        'CANNOT PROCEED: You are trying to initialize Native SDK with placeholder credentials.\n\n'
            'Current App Key: "$appKey"\n'
            'Current App Secret: "${appSecret.substring(0, 10)}..."\n\n'
            'These are NOT real EZVIZ credentials!\n\n'
            'The Native SDK will NOT work until you provide real credentials from:\n'
            'https://open.ezvizlife.com/',
      );
      return; // STOP HERE - don't try to initialize
    }

    setState(() {
      _isInitializing = true;
      _statusMessage = 'Getting access token and area domain for Native SDK...';
    });

    try {
      // STEP 1: Get access token and area domain via HTTP API first
      String accessToken;
      String areaDomain;

      // Check if we already have them from HTTP API initialization
      if (_isHttpInitialized && _httpClient != null) {
        // Use existing HTTP API client to get token info
        setState(() {
          _statusMessage = 'Using existing HTTP API token for Native SDK...';
        });

        // We need to get the actual token and domain from the client
        // Since the EzvizClient doesn't expose these directly, we'll create a test call to trigger auth
        try {
          final authService = AuthService(_httpClient!);
          await authService.login(); // This ensures we have fresh tokens

          // The tokens are now set in the client but we can't access them directly
          // So we'll manually get them via a direct API call
          final response = await http.post(
            Uri.parse('${EzvizConstants.baseUrl}/api/lapp/token/get'),
            headers: {'Content-Type': 'application/x-www-form-urlencoded'},
            body: {'appKey': appKey, 'appSecret': appSecret},
          );

          if (response.statusCode == 200) {
            final data = jsonDecode(response.body);
            if (data['code'] == '200') {
              accessToken = data['data']['accessToken'];
              areaDomain = data['data']['areaDomain'];
            } else {
              throw Exception('Token API failed: ${data['msg']}');
            }
          } else {
            throw Exception('Token request failed: ${response.statusCode}');
          }
        } catch (e) {
          throw Exception('Failed to get token from existing HTTP client: $e');
        }
      } else {
        // Get fresh tokens via direct API call
        setState(() {
          _statusMessage = 'Getting fresh access token from EZVIZ API...';
        });

        final response = await http
            .post(
              Uri.parse('${EzvizConstants.baseUrl}/api/lapp/token/get'),
              headers: {'Content-Type': 'application/x-www-form-urlencoded'},
              body: {'appKey': appKey, 'appSecret': appSecret},
            )
            .timeout(
              const Duration(seconds: 15),
              onTimeout: () {
                throw Exception(
                  'Token request timeout - check network connection',
                );
              },
            );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          if (data['code'] == '200') {
            accessToken = data['data']['accessToken'];
            areaDomain = data['data']['areaDomain'];

            setState(() {
              _statusMessage = 'Got access token and area domain: $areaDomain';
            });
          } else {
            // Handle specific EZVIZ error codes
            String errorMsg = data['msg'] ?? 'Unknown error';
            if (data['code'] == '10017') {
              throw Exception('INVALID APP KEY: $errorMsg');
            } else if (data['code'] == '10030') {
              throw Exception('INVALID APP SECRET: $errorMsg');
            } else if (data['code'] == '10005') {
              throw Exception('APP KEY SUSPENDED: $errorMsg');
            } else {
              throw Exception(
                'Authentication failed: $errorMsg (Code: ${data['code']})',
              );
            }
          }
        } else {
          throw Exception(
            'HTTP ${response.statusCode}: Failed to get access token',
          );
        }
      }

      // STEP 2: Initialize Native SDK with proper credentials
      setState(() {
        _statusMessage =
            'Initializing Native SDK with area domain: $areaDomain';
      });

      final options = EzvizInitOptions(
        appKey: appKey,
        accessToken:
            accessToken, // Use the proper access token, not app secret!
        enableLog: true,
        enableP2P: false, // Disable P2P to reduce complexity
      );

      final result = await EzvizManager.shared()
          .initSDK(options)
          .timeout(
            const Duration(seconds: 15),
            onTimeout: () {
              throw Exception(
                'Native SDK initialization timeout - check your credentials',
              );
            },
          );

      if (result) {
        // STEP 3: Set the proper access token (this is critical!)
        try {
          await EzvizManager.shared().setAccessToken(accessToken);

          setState(() {
            _statusMessage =
                'SUCCESS: Native SDK initialized with access token from area domain: $areaDomain';
          });
        } catch (e) {
          // This is critical - if setAccessToken fails, the SDK won't work
          throw Exception('Failed to set access token in Native SDK: $e');
        }

        setState(() {
          _isInitialized = true;
          _accessTokenController.text = accessToken; // Show the token in UI
        });

        _showSnackBar('✅ Native SDK initialized with area domain: $areaDomain');

        // Load devices after initialization
        _loadNativeDevices();
      } else {
        throw Exception(
          'Native SDK initialization returned false - check credentials and network',
        );
      }
    } catch (e) {
      setState(() {
        _isInitialized = false;
        _statusMessage = 'NATIVE SDK FAILED: ${e.toString()}';
      });

      String errorTitle = '❌ Native SDK Error';
      String errorMessage = e.toString();

      if (errorMessage.contains('INVALID APP KEY')) {
        errorTitle = '❌ Invalid App Key (Native SDK)';
        errorMessage =
            'NATIVE SDK ERROR: Your App Key does not exist.\n\n'
            'App Key: "$appKey"\n\n'
            'The EZVIZ servers rejected your App Key.\n\n'
            'SOLUTION:\n'
            '1. Verify your App Key in EZVIZ developer console\n'
            '2. Make sure you copied it correctly (no extra spaces)\n'
            '3. Check that your developer account is active';
      } else if (errorMessage.contains('INVALID APP SECRET')) {
        errorTitle = '❌ Invalid App Secret (Native SDK)';
        errorMessage =
            'NATIVE SDK ERROR: App Key and App Secret do not match.\n\n'
            'App Key: "$appKey"\n'
            'App Secret: "${appSecret.substring(0, 10)}..."\n\n'
            'The EZVIZ servers rejected your App Secret.\n\n'
            'SOLUTION:\n'
            '1. Verify both App Key and App Secret in EZVIZ console\n'
            '2. Make sure they belong to the same application\n'
            '3. Copy both values again carefully';
      } else if (errorMessage.contains('APP KEY SUSPENDED')) {
        errorTitle = '🚫 App Key Suspended (Native SDK)';
        errorMessage =
            'NATIVE SDK ERROR: Your App Key has been suspended.\n\n'
            'App Key: "$appKey"\n\n'
            'Your EZVIZ developer account has been frozen.\n\n'
            'SOLUTION:\n'
            '1. Contact EZVIZ support immediately\n'
            '2. Check for any policy violations\n'
            '3. Create a new developer account if necessary';
      } else if (errorMessage.contains('timeout')) {
        errorTitle = '🌐 Native SDK Timeout';
        errorMessage =
            'TIMEOUT ERROR: Native SDK initialization timed out.\n\n'
            'This could be caused by:\n'
            '• Poor internet connection\n'
            '• EZVIZ servers temporarily unavailable\n'
            '• Invalid credentials causing delays\n\n'
            'SOLUTION:\n'
            '1. Check your internet connection\n'
            '2. Verify your credentials are correct\n'
            '3. Try again in a few minutes';
      } else {
        errorTitle = '❌ Native SDK Error';
        errorMessage =
            'NATIVE SDK INITIALIZATION FAILED:\n$errorMessage\n\n'
            'This may be a native SDK issue or credential problem.\n\n'
            'SOLUTION:\n'
            '1. Try HTTP API initialization first\n'
            '2. Check your credentials are valid\n'
            '3. Restart the app and try again';
      }

      _showErrorDialog(errorTitle, errorMessage);
      _showSnackBar('❌ Native SDK failed - see error dialog');
    } finally {
      setState(() {
        _isInitializing = false;
      });
    }
  }

  Future<void> _uninitializeSDK() async {
    try {
      setState(() {
        _isInitialized = false;
        _isHttpInitialized = false;
        _statusMessage = 'SDKs uninitialized';
        _nativeDevices.clear();
        _httpCameras.clear();
        _selectedNativeDevice = null;
        _selectedHttpCamera = null;
      });

      if (_playerController != null) {
        await _playerController!.release();
        _playerController = null;
        _isPlayerInitialized = false;
      }
    } catch (e) {
      setState(() {
        _statusMessage = 'Uninitialization failed: ${e.toString()}';
      });
    }
  }

  // Device Management Methods
  Future<void> _loadNativeDevices() async {
    if (!_isInitialized) {
      _showSnackBar('Please initialize Native SDK first');
      return;
    }

    if (_isLoadingDevices) {
      _showSnackBar('Device loading already in progress');
      return;
    }

    setState(() {
      _isLoadingDevices = true;
    });

    try {
      final devices = await EzvizManager.shared().deviceList.timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception(
            'Device list timeout - check your network connection',
          );
        },
      );

      setState(() {
        _nativeDevices = devices ?? [];
        if (_nativeDevices.isNotEmpty && _selectedNativeDevice == null) {
          _selectedNativeDevice = _nativeDevices.first;
        }
      });

      if (_nativeDevices.isEmpty) {
        _showSnackBar(
          'No devices found - make sure devices are added to your EZVIZ account',
        );
      } else {
        _showSnackBar('Loaded ${_nativeDevices.length} native devices');
      }
    } catch (e) {
      String errorMessage = e.toString();
      if (errorMessage.contains('10002') ||
          errorMessage.contains('AccessToken expired')) {
        errorMessage = 'Authentication expired - please reinitialize the SDK';
      } else if (errorMessage.contains('timeout')) {
        errorMessage = 'Network timeout - check your internet connection';
      }

      setState(() {
        _nativeDevices.clear();
        _selectedNativeDevice = null;
      });

      _showSnackBar('Failed to load native devices: $errorMessage');
    } finally {
      setState(() {
        _isLoadingDevices = false;
      });
    }
  }

  Future<void> _loadHTTPCameras() async {
    if (!_isHttpInitialized || _httpClient == null) {
      _showSnackBar('Please initialize HTTP API first');
      return;
    }

    if (_isLoadingDevices) {
      _showSnackBar('Device loading already in progress');
      return;
    }

    setState(() {
      _isLoadingDevices = true;
    });

    try {
      final deviceService = DeviceService(_httpClient!);
      final response = await deviceService
          .getCameraList(pageSize: 50)
          .timeout(
            const Duration(seconds: 15),
            onTimeout: () {
              throw Exception(
                'Camera list timeout - check your network connection',
              );
            },
          );

      // Parse the response to get camera list
      if (response['code'] == '200' && response['data'] != null) {
        final cameraDataList = response['data'] as List<dynamic>;

        final cameras = cameraDataList.map((data) {
          return Camera(
            deviceSerial: data['deviceSerial']?.toString() ?? 'Unknown Serial',
            channelNo: data['channelNo']?.toString() ?? '1',
            channelName: data['channelName']?.toString() ?? 'Unknown Camera',
            status: (data['status'] == 1 || data['status'] == '1')
                ? 'Online'
                : 'Offline',
            isShared: data['isShared']?.toString() ?? '0',
            thumbnailUrl: data['picUrl']?.toString() ?? '',
            isEncrypt: (data['isEncrypt'] == 1 || data['isEncrypt'] == '1'),
            videoLevel: data['videoLevel']?.toString() ?? '2',
          );
        }).toList();

        setState(() {
          _httpCameras = cameras;
          if (_httpCameras.isNotEmpty && _selectedHttpCamera == null) {
            _selectedHttpCamera = _httpCameras.first;
          }
        });

        if (_httpCameras.isEmpty) {
          _showSnackBar(
            'No cameras found - make sure cameras are added to your EZVIZ account',
          );
        } else {
          _showSnackBar('Loaded ${_httpCameras.length} HTTP cameras');
        }
      } else {
        String errorMsg = response['msg']?.toString() ?? 'Unknown error';
        if (errorMsg.contains('10002') ||
            errorMsg.contains('AccessToken expired')) {
          errorMsg =
              'Authentication expired - please reinitialize the HTTP API';
        } else if (errorMsg.contains('10017') ||
            errorMsg.contains("AppKey doesn't exist")) {
          errorMsg = 'Invalid App Key - check your credentials';
        }
        throw Exception('API Error: $errorMsg');
      }
    } catch (e) {
      String errorMessage = e.toString();
      if (errorMessage.contains('10002') ||
          errorMessage.contains('AccessToken expired')) {
        errorMessage =
            'Authentication expired - please reinitialize the HTTP API';
        setState(() {
          _isHttpInitialized = false;
        });
      } else if (errorMessage.contains('10017') ||
          errorMessage.contains("AppKey doesn't exist")) {
        errorMessage =
            'Invalid credentials - please check your App Key and App Secret';
        setState(() {
          _isHttpInitialized = false;
        });
      } else if (errorMessage.contains('timeout')) {
        errorMessage = 'Network timeout - check your internet connection';
      }

      setState(() {
        _httpCameras.clear();
        _selectedHttpCamera = null;
      });

      _showSnackBar('Failed to load HTTP cameras: $errorMessage');
    } finally {
      setState(() {
        _isLoadingDevices = false;
      });
    }
  }

  // Video Player Methods
  Future<void> _initializeNativePlayer() async {
    if (!_isInitialized || _selectedNativeDevice == null) {
      _showSnackBar('Please initialize Native SDK and select a device first');
      return;
    }

    try {
      _playerId++;
      _playerController = EzvizPlayerController(_playerId);

      // Set verify code if provided
      if (_verifyCodeController.text.isNotEmpty) {
        await _playerController!.setPlayVerifyCode(_verifyCodeController.text);
      }

      await _playerController!.initPlayerByDevice(
        _selectedNativeDevice!.deviceSerial,
        _selectedNativeDevice!.cameraNum,
      );

      setState(() {
        _isPlayerInitialized = true;
        _playerStatus = 'Native player initialized';
      });
    } catch (e) {
      setState(() {
        _playerStatus = 'Native player initialization failed: ${e.toString()}';
      });
    }
  }

  Future<void> _getHTTPStreamUrl(String protocol) async {
    if (!_isHttpInitialized ||
        _selectedHttpCamera == null ||
        _httpClient == null) {
      _showSnackBar('Please initialize HTTP API and select a camera first');
      return;
    }

    try {
      final liveService = LiveService(_httpClient!);

      // Map protocol names to protocol numbers
      int protocolNumber;
      switch (protocol.toLowerCase()) {
        case 'ezopen':
          protocolNumber = 1; // ezopen protocol (for native apps)
          break;
        case 'hls':
          protocolNumber = 2; // HLS protocol
          break;
        case 'rtmp':
          protocolNumber = 3; // RTMP protocol
          break;
        case 'flv':
          protocolNumber = 4; // FLV protocol
          break;
        default:
          throw Exception('Unsupported protocol: $protocol');
      }

      final response = await liveService.getPlayAddress(
        _selectedHttpCamera!.deviceSerial,
        channelNo: int.parse(_selectedHttpCamera!.channelNo),
        protocol: protocolNumber,
        quality: 1, // HD quality
        code: _verifyCodeController.text.isNotEmpty
            ? _verifyCodeController.text
            : null,
      );

      if (response['code'] == '200' &&
          response['data'] != null &&
          response['data']['url'] != null) {
        final streamUrl = response['data']['url'].toString();

        setState(() {
          _currentStreamUrl = streamUrl;
          _playerStatus =
              'Stream URL generated ($protocol): ${streamUrl.substring(0, 50)}...';
        });

        _showSnackBar('$protocol stream URL generated successfully');
      } else {
        throw Exception('API Error: ${response['msg']}');
      }
    } catch (e) {
      setState(() {
        _playerStatus = 'Failed to get $protocol stream URL: ${e.toString()}';
      });
    }
  }

  Future<void> _startNativeLivePlay() async {
    if (_playerController == null) {
      await _initializeNativePlayer();
      if (_playerController == null) return;
    }

    try {
      final result = await _playerController!.startRealPlay();
      setState(() {
        _playerStatus = result
            ? 'Native live stream started'
            : 'Failed to start native live stream';
      });
    } catch (e) {
      setState(() {
        _playerStatus = 'Failed to start native live stream: ${e.toString()}';
      });
    }
  }

  Future<void> _stopNativeLivePlay() async {
    if (_playerController == null) return;

    try {
      final result = await _playerController!.stopRealPlay();
      setState(() {
        _playerStatus = result
            ? 'Native live stream stopped'
            : 'Failed to stop native live stream';
      });
    } catch (e) {
      setState(() {
        _playerStatus = 'Failed to stop native live stream: ${e.toString()}';
      });
    }
  }

  // PTZ Control Methods
  Future<void> _startPTZ(String command, String action) async {
    if (_selectedAPI == 'Native' &&
        _isInitialized &&
        _selectedNativeDevice != null) {
      try {
        await EzvizManager.shared().controlPTZ(
          _selectedNativeDevice!.deviceSerial,
          _selectedNativeDevice!.cameraNum,
          command,
          action,
          4, // Medium speed
        );
      } catch (e) {
        _showSnackBar('Native PTZ control failed: ${e.toString()}');
      }
    } else if (_selectedAPI == 'HTTP' &&
        _isHttpInitialized &&
        _selectedHttpCamera != null &&
        _httpClient != null) {
      try {
        final ptzService = PtzService(_httpClient!);

        // Map command strings to PTZ enums
        PtzCommand? ptzCommand;
        switch (command.toUpperCase()) {
          case 'UP':
            ptzCommand = PtzCommand.up;
            break;
          case 'DOWN':
            ptzCommand = PtzCommand.down;
            break;
          case 'LEFT':
            ptzCommand = PtzCommand.left;
            break;
          case 'RIGHT':
            ptzCommand = PtzCommand.right;
            break;
          case 'ZOOM_IN':
            ptzCommand = PtzCommand.zoomIn;
            break;
          case 'ZOOM_OUT':
            ptzCommand = PtzCommand.zoomOut;
            break;
          default:
            _showSnackBar('Unsupported PTZ command: $command');
            return;
        }

        if (action.toUpperCase() == 'START') {
          await ptzService.startPtz(
            _selectedHttpCamera!.deviceSerial,
            int.parse(_selectedHttpCamera!.channelNo),
            direction: ptzCommand,
            speed: PtzSpeed.medium,
          );
        } else if (action.toUpperCase() == 'STOP') {
          await ptzService.stopPtz(
            _selectedHttpCamera!.deviceSerial,
            int.parse(_selectedHttpCamera!.channelNo),
            direction: ptzCommand,
          );
        }
      } catch (e) {
        _showSnackBar('HTTP PTZ control failed: ${e.toString()}');
      }
    }
  }

  // Audio & Recording Methods
  Future<void> _toggleAudio() async {
    if (_playerController == null) return;

    try {
      if (_isAudioEnabled) {
        await _playerController!.closeSound();
      } else {
        await _playerController!.openSound();
      }
      setState(() {
        _isAudioEnabled = !_isAudioEnabled;
      });
    } catch (e) {
      _showSnackBar('Audio toggle failed: ${e.toString()}');
    }
  }

  Future<void> _toggleRecording() async {
    if (_playerController == null) return;

    try {
      if (_isRecording) {
        await _playerController!.stopRecording();
      } else {
        await _playerController!.startRecording();
      }
      setState(() {
        _isRecording = !_isRecording;
      });
    } catch (e) {
      _showSnackBar('Recording toggle failed: ${e.toString()}');
    }
  }

  Future<void> _takeScreenshot() async {
    if (_playerController == null) return;

    try {
      final result = await _playerController!.capturePicture();
      _showSnackBar('Screenshot saved: ${result ?? "Unknown location"}');
    } catch (e) {
      _showSnackBar('Screenshot failed: ${e.toString()}');
    }
  }

  // Utility Methods
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EZVIZ SDK Demo (Native + HTTP)'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          tabs: const [
            Tab(icon: Icon(Icons.settings, size: 20), text: 'Init'),
            Tab(icon: Icon(Icons.devices, size: 20), text: 'Devices'),
            Tab(icon: Icon(Icons.videocam, size: 20), text: 'Native'),
            Tab(icon: Icon(Icons.stream, size: 20), text: 'HTTP'),
            Tab(icon: Icon(Icons.control_camera, size: 20), text: 'PTZ'),
            Tab(icon: Icon(Icons.mic, size: 20), text: 'Audio'),
            Tab(icon: Icon(Icons.wifi, size: 20), text: 'WiFi'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildInitTab(),
          _buildDevicesTab(),
          _buildNativePlayerTab(),
          _buildHTTPStreamTab(),
          _buildPTZControlTab(),
          _buildAudioRecordTab(),
          _buildWiFiConfigTab(),
        ],
      ),
    );
  }

  Widget _buildInitTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Status Display Card
            Card(
              color: _getStatusCardColor(),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          _getStatusIcon(),
                          color: _getStatusIconColor(),
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Current Status',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: _getStatusIconColor(),
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(_statusMessage, style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.phone_android,
                          color: _isInitialized ? Colors.green : Colors.red,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Native SDK: ${_isInitialized ? 'Ready' : 'Not Ready'}',
                        ),
                        const SizedBox(width: 16),
                        Icon(
                          Icons.http,
                          color: _isHttpInitialized ? Colors.green : Colors.red,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'HTTP API: ${_isHttpInitialized ? 'Ready' : 'Not Ready'}',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Credentials Warning Card
            if (!_canInitialize())
              Card(
                color: Colors.red.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.error, color: Colors.red, size: 24),
                          SizedBox(width: 8),
                          Text(
                            'CRITICAL: Invalid Credentials Detected',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'The current App Key and App Secret are placeholders and WILL NOT WORK.',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'This is causing the authentication errors you\'re seeing.',
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'To fix this:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const Text('1. Register at: https://open.ezvizlife.com/'),
                      const Text(
                        '2. Create an application in the developer console',
                      ),
                      const Text('3. Copy your real App Key and App Secret'),
                      const Text('4. Replace the values below'),
                      const SizedBox(height: 8),
                      ElevatedButton.icon(
                        onPressed: () {
                          // You could open the URL here
                        },
                        icon: const Icon(Icons.open_in_new),
                        label: const Text('Open EZVIZ Developer Portal'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 16),
            TextField(
              controller: _appKeyController,
              decoration: InputDecoration(
                labelText: 'App Key',
                hintText: 'Enter your EZVIZ App Key',
                helperText: 'Get from https://open.ezvizlife.com/',
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.key),
                suffixIcon: _appKeyController.text == 'YOUR_APP_KEY_HERE'
                    ? const Icon(Icons.warning, color: Colors.red)
                    : _appKeyController.text.length > 10
                    ? const Icon(Icons.check, color: Colors.green)
                    : null,
              ),
              onChanged: (value) => setState(() {}),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _appSecretController,
              decoration: InputDecoration(
                labelText: 'App Secret',
                hintText: 'Enter your EZVIZ App Secret',
                helperText: 'Get from https://open.ezvizlife.com/',
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.security),
                suffixIcon: _appSecretController.text == 'YOUR_APP_SECRET_HERE'
                    ? const Icon(Icons.warning, color: Colors.red)
                    : _appSecretController.text.length > 10
                    ? const Icon(Icons.check, color: Colors.green)
                    : null,
              ),
              obscureText: true,
              onChanged: (value) => setState(() {}),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _accessTokenController,
              decoration: const InputDecoration(
                labelText: 'Access Token (Optional)',
                hintText: 'Enter access token if available',
                helperText:
                    'Will be automatically obtained from App Key/Secret',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.token),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _canInitialize() && !_isHttpInitialized
                        ? _initializeHTTPAPI
                        : null,
                    icon: _isHttpInitialized
                        ? const Icon(Icons.check)
                        : const Icon(Icons.http),
                    label: Text(
                      _isHttpInitialized ? 'HTTP API Ready' : 'Init HTTP API',
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isHttpInitialized ? Colors.green : null,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed:
                        _canInitialize() && !_isInitialized && !_isInitializing
                        ? _initializeNativeSDK
                        : null,
                    icon: _isInitializing
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : _isInitialized
                        ? const Icon(Icons.check)
                        : const Icon(Icons.phone_android),
                    label: Text(
                      _isInitializing
                          ? 'Initializing...'
                          : _isInitialized
                          ? 'Native SDK Ready'
                          : 'Init Native SDK',
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isInitialized ? Colors.green : null,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: (_isInitialized || _isHttpInitialized)
                        ? _uninitializeSDK
                        : null,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Reset All'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusCardColor() {
    if (_statusMessage.contains('ERROR') ||
        _statusMessage.contains('INVALID')) {
      return Colors.red.shade50;
    } else if (_isHttpInitialized && _isInitialized) {
      return Colors.green.shade50;
    } else if (_isHttpInitialized || _isInitialized) {
      return Colors.orange.shade50;
    }
    return Colors.grey.shade50;
  }

  IconData _getStatusIcon() {
    if (_statusMessage.contains('ERROR') ||
        _statusMessage.contains('INVALID')) {
      return Icons.error;
    } else if (_isHttpInitialized && _isInitialized) {
      return Icons.check_circle;
    } else if (_isHttpInitialized || _isInitialized) {
      return Icons.pending;
    }
    return Icons.info;
  }

  Color _getStatusIconColor() {
    if (_statusMessage.contains('ERROR') ||
        _statusMessage.contains('INVALID')) {
      return Colors.red;
    } else if (_isHttpInitialized && _isInitialized) {
      return Colors.green;
    } else if (_isHttpInitialized || _isInitialized) {
      return Colors.orange;
    }
    return Colors.grey;
  }

  bool _canInitialize() {
    return _appKeyController.text.isNotEmpty &&
        _appSecretController.text.isNotEmpty &&
        _appKeyController.text != 'YOUR_APP_KEY_HERE' &&
        _appSecretController.text != 'YOUR_APP_SECRET_HERE' &&
        _appKeyController.text.length > 10 &&
        _appSecretController.text.length > 10;
  }

  Widget _buildDevicesTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // API Selection
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Text(
                    'Select API for Device Control:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: RadioListTile<String>(
                          title: const Text('HTTP API'),
                          value: 'HTTP',
                          groupValue: _selectedAPI,
                          onChanged: (value) {
                            setState(() {
                              _selectedAPI = value!;
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: RadioListTile<String>(
                          title: const Text('Native SDK'),
                          value: 'Native',
                          groupValue: _selectedAPI,
                          onChanged: (value) {
                            setState(() {
                              _selectedAPI = value!;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _selectedAPI == 'HTTP' && _isHttpInitialized
                      ? _loadHTTPCameras
                      : null,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Load HTTP Cameras'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _selectedAPI == 'Native' && _isInitialized
                      ? _loadNativeDevices
                      : null,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Load Native Devices'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (_isLoadingDevices)
            const Center(child: CircularProgressIndicator())
          else if (_selectedAPI == 'HTTP' && _httpCameras.isEmpty)
            const Center(child: Text('No HTTP cameras found'))
          else if (_selectedAPI == 'Native' && _nativeDevices.isEmpty)
            const Center(child: Text('No native devices found'))
          else
            Expanded(
              child: _selectedAPI == 'HTTP'
                  ? _buildHTTPCameraList()
                  : _buildNativeDeviceList(),
            ),
          if ((_selectedAPI == 'HTTP' && _selectedHttpCamera != null) ||
              (_selectedAPI == 'Native' && _selectedNativeDevice != null)) ...[
            const Divider(),
            TextField(
              controller: _verifyCodeController,
              decoration: const InputDecoration(
                labelText: 'Verify Code (if encrypted)',
                hintText: 'Enter device verify code',
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildHTTPCameraList() {
    return ListView.builder(
      itemCount: _httpCameras.length,
      itemBuilder: (context, index) {
        final camera = _httpCameras[index];
        return Card(
          child: ListTile(
            leading: Icon(
              Icons.videocam,
              color: camera.status == 'Online' ? Colors.green : Colors.red,
            ),
            title: Text(camera.channelName),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Serial: ${camera.deviceSerial}'),
                Text('Channel: ${camera.channelNo}'),
                Text('Status: ${camera.status}'),
                Text('Encrypted: ${camera.isEncrypt ? 'Yes' : 'No'}'),
              ],
            ),
            selected: _selectedHttpCamera?.deviceSerial == camera.deviceSerial,
            onTap: () {
              setState(() {
                _selectedHttpCamera = camera;
              });
            },
          ),
        );
      },
    );
  }

  Widget _buildNativeDeviceList() {
    return ListView.builder(
      itemCount: _nativeDevices.length,
      itemBuilder: (context, index) {
        final device = _nativeDevices[index];
        return Card(
          child: ListTile(
            leading: const Icon(Icons.videocam, color: Colors.green),
            title: Text(device.deviceName),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Serial: ${device.deviceSerial}'),
                Text('Camera: ${device.cameraNum}'),
                Text('PTZ Support: ${device.isSupportPTZ ? 'Yes' : 'No'}'),
              ],
            ),
            selected:
                _selectedNativeDevice?.deviceSerial == device.deviceSerial,
            onTap: () {
              setState(() {
                _selectedNativeDevice = device;
              });
            },
          ),
        );
      },
    );
  }

  Widget _buildNativePlayerTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text('Native Player Status: $_playerStatus'),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        _isPlayerInitialized
                            ? Icons.check_circle
                            : Icons.cancel,
                        color: _isPlayerInitialized ? Colors.green : Colors.red,
                      ),
                      const SizedBox(width: 8),
                      Text(_isPlayerInitialized ? 'Ready' : 'Not Ready'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (_selectedNativeDevice != null) ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Selected Device: ${_selectedNativeDevice!.deviceName}',
                    ),
                    Text('Serial: ${_selectedNativeDevice!.deviceSerial}'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
          // Native Video Player Container
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: _isPlayerInitialized && _playerController != null
                  ? EzvizPlayerWidget(playerId: _playerId)
                  : const Center(
                      child: Text(
                        'Initialize native player to start streaming',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: _selectedNativeDevice != null
                      ? _initializeNativePlayer
                      : null,
                  child: const Text('Initialize Player'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: _isPlayerInitialized ? _startNativeLivePlay : null,
                  child: const Text('Start Live'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: _isPlayerInitialized ? _stopNativeLivePlay : null,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text('Stop'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHTTPStreamTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text('HTTP Stream Status: $_playerStatus'),
                  const SizedBox(height: 8),
                  if (_currentStreamUrl != null) ...[
                    const Text(
                      'Current Stream URL:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    SelectableText(
                      _currentStreamUrl!,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (_selectedHttpCamera != null) ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Selected Camera: ${_selectedHttpCamera!.channelName}',
                    ),
                    Text('Serial: ${_selectedHttpCamera!.deviceSerial}'),
                    Text('Channel: ${_selectedHttpCamera!.channelNo}'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
          const Text(
            'Get Stream URLs:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 2.5,
            children: [
              ElevatedButton(
                onPressed: _selectedHttpCamera != null
                    ? () => _getHTTPStreamUrl('ezopen')
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                ),
                child: const Text(
                  'EZOPEN\n(Native App)',
                  textAlign: TextAlign.center,
                ),
              ),
              ElevatedButton(
                onPressed: _selectedHttpCamera != null
                    ? () => _getHTTPStreamUrl('hls')
                    : null,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                child: const Text(
                  'HLS\n(Web/Mobile)',
                  textAlign: TextAlign.center,
                ),
              ),
              ElevatedButton(
                onPressed: _selectedHttpCamera != null
                    ? () => _getHTTPStreamUrl('rtmp')
                    : null,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                child: const Text(
                  'RTMP\n(Live Stream)',
                  textAlign: TextAlign.center,
                ),
              ),
              ElevatedButton(
                onPressed: _selectedHttpCamera != null
                    ? () => _getHTTPStreamUrl('flv')
                    : null,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: const Text(
                  'FLV\n(Flash Video)',
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (_currentStreamUrl != null) ...[
            const Divider(),
            const Text(
              'Stream URL Actions:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Copy to clipboard
                      _showSnackBar('Stream URL copied to clipboard');
                    },
                    icon: const Icon(Icons.copy),
                    label: const Text('Copy URL'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Share URL
                      _showSnackBar('Stream URL sharing feature coming soon');
                    },
                    icon: const Icon(Icons.share),
                    label: const Text('Share URL'),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPTZControlTab() {
    bool canControlPTZ = false;
    String deviceName = '';

    if (_selectedAPI == 'HTTP' && _selectedHttpCamera != null) {
      canControlPTZ = true;
      deviceName = _selectedHttpCamera!.channelName;
    } else if (_selectedAPI == 'Native' && _selectedNativeDevice != null) {
      canControlPTZ = _selectedNativeDevice!.isSupportPTZ;
      deviceName = _selectedNativeDevice!.deviceName;
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text('PTZ Control via $_selectedAPI API'),
                  if (deviceName.isNotEmpty) Text('Device: $deviceName'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (!canControlPTZ)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Selected device does not support PTZ control or no device selected',
                ),
              ),
            )
          else ...[
            const SizedBox(height: 20),
            // PTZ Control Panel
            Expanded(
              child: PTZControlPanel(
                onPTZCommand: _startPTZ,
                enabled: canControlPTZ,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAudioRecordTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Text(
                    'Audio Controls (Native SDK Only)',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _isPlayerInitialized ? _toggleAudio : null,
                          icon: Icon(
                            _isAudioEnabled
                                ? Icons.volume_off
                                : Icons.volume_up,
                          ),
                          label: Text(
                            _isAudioEnabled ? 'Mute Audio' : 'Enable Audio',
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Text(
                    'Recording Controls (Native SDK Only)',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _isPlayerInitialized
                              ? _toggleRecording
                              : null,
                          icon: Icon(
                            _isRecording
                                ? Icons.stop
                                : Icons.fiber_manual_record,
                          ),
                          label: Text(
                            _isRecording ? 'Stop Recording' : 'Start Recording',
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _isRecording ? Colors.red : null,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _isPlayerInitialized
                              ? _takeScreenshot
                              : null,
                          icon: const Icon(Icons.camera_alt),
                          label: const Text('Screenshot'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWiFiConfigTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    'WiFi Configuration',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'WiFi configuration features will be available in a future update. '
                    'This includes device network setup, AP mode configuration, and sound wave configuration.',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: null, // Disabled for now
            icon: const Icon(Icons.wifi_outlined),
            label: const Text('Start WiFi Config (Coming Soon)'),
          ),
        ],
      ),
    );
  }
}

// Custom PTZ Control Panel Widget
class PTZControlPanel extends StatelessWidget {
  final Function(String command, String action) onPTZCommand;
  final bool enabled;

  const PTZControlPanel({
    super.key,
    required this.onPTZCommand,
    required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Up button
          _buildPTZButton(
            icon: Icons.keyboard_arrow_up,
            onPressed: () => onPTZCommand('UP', 'START'),
            onReleased: () => onPTZCommand('UP', 'STOP'),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Left button
              _buildPTZButton(
                icon: Icons.keyboard_arrow_left,
                onPressed: () => onPTZCommand('LEFT', 'START'),
                onReleased: () => onPTZCommand('LEFT', 'STOP'),
              ),
              // Center (Home) button
              _buildPTZButton(
                icon: Icons.home,
                onPressed: () => onPTZCommand('AUTO', 'START'),
                onReleased: () => onPTZCommand('AUTO', 'STOP'),
              ),
              // Right button
              _buildPTZButton(
                icon: Icons.keyboard_arrow_right,
                onPressed: () => onPTZCommand('RIGHT', 'START'),
                onReleased: () => onPTZCommand('RIGHT', 'STOP'),
              ),
            ],
          ),
          // Down button
          _buildPTZButton(
            icon: Icons.keyboard_arrow_down,
            onPressed: () => onPTZCommand('DOWN', 'START'),
            onReleased: () => onPTZCommand('DOWN', 'STOP'),
          ),
          const SizedBox(height: 20),
          // Zoom controls
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildPTZButton(
                icon: Icons.zoom_out,
                label: 'Zoom Out',
                onPressed: () => onPTZCommand('ZOOM_OUT', 'START'),
                onReleased: () => onPTZCommand('ZOOM_OUT', 'STOP'),
              ),
              _buildPTZButton(
                icon: Icons.zoom_in,
                label: 'Zoom In',
                onPressed: () => onPTZCommand('ZOOM_IN', 'START'),
                onReleased: () => onPTZCommand('ZOOM_IN', 'STOP'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPTZButton({
    required IconData icon,
    required VoidCallback onPressed,
    required VoidCallback onReleased,
    String? label,
  }) {
    return GestureDetector(
      onTapDown: enabled ? (_) => onPressed() : null,
      onTapUp: enabled ? (_) => onReleased() : null,
      onTapCancel: enabled ? onReleased : null,
      child: Container(
        margin: const EdgeInsets.all(8),
        width: label != null ? 100 : 60,
        height: 60,
        decoration: BoxDecoration(
          color: enabled ? Colors.blue : Colors.grey,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 24),
            if (label != null)
              Text(
                label,
                style: const TextStyle(color: Colors.white, fontSize: 10),
              ),
          ],
        ),
      ),
    );
  }
}

// Custom Player Widget
class EzvizPlayerWidget extends StatefulWidget {
  final int playerId;

  const EzvizPlayerWidget({super.key, required this.playerId});

  @override
  State<EzvizPlayerWidget> createState() => _EzvizPlayerWidgetState();
}

class _EzvizPlayerWidgetState extends State<EzvizPlayerWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: const Center(
        child: Text(
          'Native Video Player\n(Platform View)',
          style: TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
