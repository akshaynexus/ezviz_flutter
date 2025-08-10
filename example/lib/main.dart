import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ezviz_flutter/ezviz_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    initSDK();
  }

  Future<bool> initSDK() async {
    bool result;
    EzvizInitOptions options = EzvizInitOptions(
      appKey: 'your_app_key_here',
      accessToken: 'your_access_token_here',
      enableLog: true,
      enableP2P: false,
    );
    try {
      result = await EzvizManager.shared().initSDK(options);
    } on PlatformException {
      result = false;
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EZVIZ Flutter SDK Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _platformVersion = 'Unknown';
  String _sdkVersion = 'Unknown';
  List<EzvizDeviceInfo> _devices = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    initPlatformState();
    setupEventHandlers();
  }

  Future<void> initPlatformState() async {
    String platformVersion;
    String sdkVersion;

    try {
      platformVersion = await EzvizManager.shared().platformVersion;
      sdkVersion = await EzvizManager.shared().sdkVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
      sdkVersion = 'Failed to get SDK version.';
    }

    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
      _sdkVersion = sdkVersion;
    });
  }

  void setupEventHandlers() {
    EzvizManager.shared().setEventHandler(
      (EzvizEvent event) {
        print('Event received: ${event.eventType}');
        print('Message: ${event.msg}');

        if (event.eventType == EzvizChannelEvents.playerStatusChange) {
          final status = event.data as EzvizPlayerStatus;
          print('Player Status: ${status.status}');
          if (status.message != null) {
            print('Status Message: ${status.message}');
          }
        }
      },
      (error) {
        print('Event Error: $error');
      },
    );
  }

  Future<void> _loadDevices() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final devices = await EzvizManager.shared().deviceList;
      setState(() {
        _devices = devices ?? [];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorDialog('Failed to load devices: $e');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('EZVIZ Flutter SDK Demo'), elevation: 0),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoCard(),
            SizedBox(height: 16),
            _buildActionsCard(),
            SizedBox(height: 16),
            _buildDevicesCard(),
            SizedBox(height: 16),
            _buildNavigationCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'SDK Information',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            SizedBox(height: 8),
            Text('Platform Version: $_platformVersion'),
            Text('SDK Version: $_sdkVersion'),
          ],
        ),
      ),
    );
  }

  Widget _buildActionsCard() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick Actions',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton.icon(
                  onPressed: _loadDevices,
                  icon: Icon(Icons.refresh),
                  label: Text('Load Devices'),
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    await EzvizManager.shared().enableLog(true);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Debug logging enabled')),
                    );
                  },
                  icon: Icon(Icons.bug_report),
                  label: Text('Enable Logs'),
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    await EzvizManager.shared().enableP2P(true);
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text('P2P enabled')));
                  },
                  icon: Icon(Icons.network_check),
                  label: Text('Enable P2P'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDevicesCard() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Devices (${_devices.length})',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                if (_isLoading)
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
              ],
            ),
            SizedBox(height: 16),
            if (_devices.isEmpty && !_isLoading)
              Text(
                'No devices found. Tap "Load Devices" to refresh.',
                style: TextStyle(color: Colors.grey[600]),
              )
            else
              ..._devices.map((device) => _buildDeviceItem(device)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildDeviceItem(EzvizDeviceInfo device) {
    return Card(
      margin: EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(
          device.isSupportPTZ ? Icons.videocam : Icons.camera_alt,
          color: Colors.blue,
        ),
        title: Text(device.deviceName),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Serial: ${device.deviceSerial}'),
            Text('Cameras: ${device.cameraNum}'),
            if (device.isSupportPTZ)
              Text('PTZ Supported', style: TextStyle(color: Colors.green)),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) => _handleDeviceAction(value, device),
          itemBuilder: (context) => [
            PopupMenuItem(value: 'live', child: Text('Live Stream')),
            if (device.isSupportPTZ)
              PopupMenuItem(value: 'ptz', child: Text('PTZ Control')),
            PopupMenuItem(value: 'info', child: Text('Device Info')),
          ],
        ),
      ),
    );
  }

  void _handleDeviceAction(String action, EzvizDeviceInfo device) {
    switch (action) {
      case 'live':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LiveStreamPage(device: device),
          ),
        );
        break;
      case 'ptz':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PTZControlPage(device: device),
          ),
        );
        break;
      case 'info':
        _showDeviceInfo(device);
        break;
    }
  }

  void _showDeviceInfo(EzvizDeviceInfo device) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Device Information'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${device.deviceName}'),
            Text('Serial: ${device.deviceSerial}'),
            Text('Camera Count: ${device.cameraNum}'),
            Text('PTZ Support: ${device.isSupportPTZ ? "Yes" : "No"}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationCard() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Examples', style: Theme.of(context).textTheme.headlineSmall),
            SizedBox(height: 16),
            ListTile(
              leading: Icon(Icons.video_library),
              title: Text('Live Streaming Demo'),
              subtitle: Text('Test live video streaming'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LiveStreamDemoPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.control_camera),
              title: Text('PTZ Control Demo'),
              subtitle: Text('Test camera movement controls'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PTZDemoPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.api),
              title: Text('HTTP API Demo'),
              subtitle: Text('Test HTTP API features'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HttpApiDemoPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Live Stream Page
class LiveStreamPage extends StatefulWidget {
  final EzvizDeviceInfo device;

  LiveStreamPage({required this.device});

  @override
  _LiveStreamPageState createState() => _LiveStreamPageState();
}

class _LiveStreamPageState extends State<LiveStreamPage> {
  EzvizPlayerController? playerController;
  bool _isPlaying = false;
  String _videoQuality = '2-HD';
  final List<String> _videoQualities = [
    '0-Smooth',
    '1-Balanced',
    '2-HD',
    '3-UHD',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Live Stream - ${widget.device.deviceName}')),
      body: Column(
        children: [
          // Video Player
          Container(
            width: double.infinity,
            height: 300,
            color: Colors.black,
            child: EzvizPlayer(
              onCreated: (controller) {
                playerController = controller;
                _initializePlayer();
              },
            ),
          ),
          // Controls
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  // Video Quality Selector
                  Row(
                    children: [
                      Text('Quality: '),
                      Expanded(
                        child: DropdownButton<String>(
                          value: _videoQuality,
                          isExpanded: true,
                          items: _videoQualities.map((quality) {
                            return DropdownMenuItem(
                              value: quality,
                              child: Text(quality),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                _videoQuality = value;
                              });
                              _setVideoQuality(value);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  // Play/Stop Controls
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: _isPlaying ? null : _startLiveStream,
                        icon: Icon(Icons.play_arrow),
                        label: Text('Start Live'),
                      ),
                      ElevatedButton.icon(
                        onPressed: !_isPlaying ? null : _stopLiveStream,
                        icon: Icon(Icons.stop),
                        label: Text('Stop Live'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
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

  Future<void> _initializePlayer() async {
    if (playerController != null) {
      await playerController!.initPlayerByDevice(
        widget.device.deviceSerial,
        1, // Camera number
      );
      // Set verify code if needed
      // await playerController!.setPlayVerifyCode('your_verify_code');
    }
  }

  Future<void> _startLiveStream() async {
    final success = await playerController?.startRealPlay();
    if (success == true) {
      setState(() {
        _isPlaying = true;
      });
    }
  }

  Future<void> _stopLiveStream() async {
    final success = await playerController?.stopRealPlay();
    if (success == true) {
      setState(() {
        _isPlaying = false;
      });
    }
  }

  Future<void> _setVideoQuality(String quality) async {
    final level = int.parse(quality.split('-')[0]);
    await EzvizManager.shared().setVideoLevel(
      widget.device.deviceSerial,
      1,
      level,
    );
  }

  @override
  void dispose() {
    playerController?.release();
    super.dispose();
  }
}

// PTZ Control Page
class PTZControlPage extends StatelessWidget {
  final EzvizDeviceInfo device;

  PTZControlPage({required this.device});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('PTZ Control - ${device.deviceName}')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'PTZ Controls',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            SizedBox(height: 40),
            // Direction Controls
            Column(
              children: [
                _buildPTZButton(context, '↑', EzvizPtzCommands.Up),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildPTZButton(context, '←', EzvizPtzCommands.Left),
                    SizedBox(width: 60),
                    _buildPTZButton(context, '→', EzvizPtzCommands.Right),
                  ],
                ),
                SizedBox(height: 10),
                _buildPTZButton(context, '↓', EzvizPtzCommands.Down),
              ],
            ),
            SizedBox(height: 40),
            // Zoom Controls
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildPTZButton(context, 'Zoom In', EzvizPtzCommands.ZoomIn),
                _buildPTZButton(context, 'Zoom Out', EzvizPtzCommands.ZoomOut),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPTZButton(BuildContext context, String label, String command) {
    return GestureDetector(
      onTapDown: (_) => _startPTZ(command),
      onTapUp: (_) => _stopPTZ(command),
      onTapCancel: () => _stopPTZ(command),
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(40),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Future<void> _startPTZ(String command) async {
    await EzvizManager.shared().controlPTZ(
      device.deviceSerial,
      1,
      command,
      EzvizPtzActions.Start,
      EzvizPtzSpeeds.Normal,
    );
  }

  Future<void> _stopPTZ(String command) async {
    await EzvizManager.shared().controlPTZ(
      device.deviceSerial,
      1,
      command,
      EzvizPtzActions.Stop,
      EzvizPtzSpeeds.Normal,
    );
  }
}

// Demo Pages
class LiveStreamDemoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Live Stream Demo')),
      body: Center(
        child: Text(
          'Configure your device serial in the code to test live streaming',
        ),
      ),
    );
  }
}

class PTZDemoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('PTZ Demo')),
      body: Center(
        child: Text(
          'Configure your PTZ device serial in the code to test PTZ controls',
        ),
      ),
    );
  }
}

class HttpApiDemoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('HTTP API Demo')),
      body: Center(child: Text('HTTP API examples coming soon')),
    );
  }
}
