# WiFi Configuration Examples

This document demonstrates WiFi configuration functionality for setting up EZVIZ camera network connections.

## Features Demonstrated

- WiFi network configuration
- AP (Access Point) mode configuration  
- Sound wave configuration
- Configuration status monitoring
- Multiple configuration methods

## Usage

Import the necessary packages:

```dart
import 'package:ezviz_flutter/ezviz_flutter.dart';
```

## Complete WiFi Configuration Example

```dart
class WiFiConfigPage extends StatefulWidget {
  @override
  _WiFiConfigPageState createState() => _WiFiConfigPageState();
}

class _WiFiConfigPageState extends State<WiFiConfigPage> {
  final _ssidController = TextEditingController();
  final _passwordController = TextEditingController();
  final _deviceSerialController = TextEditingController();
  final _verifyCodeController = TextEditingController();
  
  String status = 'Ready to configure';
  bool isConfiguring = false;
  EzvizWifiConfigMode selectedMode = EzvizWifiConfigMode.wifi;
  
  @override
  void initState() {
    super.initState();
    _setupConfigEventHandler();
  }

  @override
  void dispose() {
    _ssidController.dispose();
    _passwordController.dispose();
    _deviceSerialController.dispose();
    _verifyCodeController.dispose();
    EzvizWifiConfig.removeConfigEventHandler();
    super.dispose();
  }

  void _setupConfigEventHandler() {
    EzvizWifiConfig.setConfigEventHandler((result) {
      setState(() {
        isConfiguring = false;
      });
      
      if (result.isSuccess) {
        setState(() {
          status = 'Configuration successful!';
        });
        _showSuccessDialog(result);
      } else {
        setState(() {
          status = 'Configuration failed: ${result.errorMessage}';
        });
        _showErrorDialog(result);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('WiFi Configuration'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Status Card
            _buildStatusCard(),
            
            SizedBox(height: 20),
            
            // Configuration Form
            _buildConfigurationForm(),
            
            SizedBox(height: 20),
            
            // Mode Selection
            _buildModeSelection(),
            
            SizedBox(height: 20),
            
            // Action Buttons
            _buildActionButtons(),
            
            SizedBox(height: 20),
            
            // Instructions
            _buildInstructions(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard() {
    return Card(
      color: _getStatusColor(),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isConfiguring ? Icons.hourglass_empty : Icons.info,
                  color: Colors.white,
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Status',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              status,
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            if (isConfiguring) ...[
              SizedBox(height: 12),
              LinearProgressIndicator(backgroundColor: Colors.white30),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildConfigurationForm() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Device & Network Details',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            
            TextField(
              controller: _deviceSerialController,
              decoration: InputDecoration(
                labelText: 'Device Serial Number',
                hintText: 'Enter device serial number',
                prefixIcon: Icon(Icons.camera_alt),
                border: OutlineInputBorder(),
              ),
            ),
            
            SizedBox(height: 16),
            
            TextField(
              controller: _verifyCodeController,
              decoration: InputDecoration(
                labelText: 'Verification Code',
                hintText: 'Enter device verification code',
                prefixIcon: Icon(Icons.security),
                border: OutlineInputBorder(),
              ),
            ),
            
            SizedBox(height: 16),
            
            TextField(
              controller: _ssidController,
              decoration: InputDecoration(
                labelText: 'WiFi Network (SSID)',
                hintText: 'Enter WiFi network name',
                prefixIcon: Icon(Icons.wifi),
                border: OutlineInputBorder(),
              ),
            ),
            
            SizedBox(height: 16),
            
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'WiFi Password',
                hintText: 'Enter WiFi password',
                prefixIcon: Icon(Icons.lock),
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(Icons.visibility),
                  onPressed: () {
                    // Toggle password visibility
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModeSelection() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Configuration Method',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            
            RadioListTile<EzvizWifiConfigMode>(
              title: Text('WiFi Configuration'),
              subtitle: Text('Standard WiFi setup'),
              value: EzvizWifiConfigMode.wifi,
              groupValue: selectedMode,
              onChanged: (value) {
                setState(() => selectedMode = value!);
              },
            ),
            
            RadioListTile<EzvizWifiConfigMode>(
              title: Text('Sound Wave Configuration'),
              subtitle: Text('Audio-based configuration'),
              value: EzvizWifiConfigMode.wave,
              groupValue: selectedMode,
              onChanged: (value) {
                setState(() => selectedMode = value!);
              },
            ),
            
            RadioListTile<EzvizWifiConfigMode>(
              title: Text('AP Mode Configuration'),
              subtitle: Text('Access Point mode setup'),
              value: EzvizWifiConfigMode.ap,
              groupValue: selectedMode,
              onChanged: (value) {
                setState(() => selectedMode = value!);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton.icon(
          onPressed: isConfiguring ? null : _startConfiguration,
          icon: Icon(isConfiguring ? Icons.hourglass_empty : Icons.settings),
          label: Text(isConfiguring ? 'Configuring...' : 'Start Configuration'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 16),
          ),
        ),
        
        SizedBox(height: 12),
        
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: isConfiguring ? _stopConfiguration : null,
                icon: Icon(Icons.stop),
                label: Text('Stop'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                ),
              ),
            ),
            
            SizedBox(width: 12),
            
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _clearForm,
                icon: Icon(Icons.clear),
                label: Text('Clear'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInstructions() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Configuration Instructions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            
            _buildInstructionStep('1', 'Power on the camera and wait for startup'),
            _buildInstructionStep('2', 'Put the camera in configuration mode'),
            _buildInstructionStep('3', 'Enter device serial and verification code'),
            _buildInstructionStep('4', 'Enter your WiFi network credentials'),
            _buildInstructionStep('5', 'Select configuration method and start'),
            _buildInstructionStep('6', 'Wait for configuration to complete'),
            
            SizedBox(height: 12),
            
            Text(
              'Configuration Methods:',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            Text('• WiFi: Direct network configuration'),
            Text('• Sound Wave: Audio-based pairing'),
            Text('• AP Mode: Temporary access point setup'),
          ],
        ),
      ),
    );
  }

  Widget _buildInstructionStep(String number, String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          SizedBox(width: 12),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }

  Color _getStatusColor() {
    if (isConfiguring) return Colors.orange;
    if (status.contains('successful')) return Colors.green;
    if (status.contains('failed')) return Colors.red;
    return Colors.blue;
  }

  // Configuration Methods
  Future<void> _startConfiguration() async {
    if (!_validateInput()) return;
    
    setState(() {
      isConfiguring = true;
      status = 'Starting configuration...';
    });

    try {
      switch (selectedMode) {
        case EzvizWifiConfigMode.wifi:
          await _startWiFiConfig();
          break;
        case EzvizWifiConfigMode.wave:
          await _startSoundWaveConfig();
          break;
        case EzvizWifiConfigMode.ap:
          await _startAPConfig();
          break;
      }
    } catch (e) {
      setState(() {
        isConfiguring = false;
        status = 'Configuration error: $e';
      });
    }
  }

  Future<void> _startWiFiConfig() async {
    setState(() {
      status = 'Configuring WiFi connection...';
    });

    await EzvizWifiConfig.startWifiConfig(
      deviceSerial: _deviceSerialController.text,
      ssid: _ssidController.text,
      password: _passwordController.text,
      mode: EzvizWifiConfigMode.wifi,
    );
  }

  Future<void> _startSoundWaveConfig() async {
    setState(() {
      status = 'Configuring via sound wave...';
    });

    await EzvizWifiConfig.startWifiConfig(
      deviceSerial: _deviceSerialController.text,
      ssid: _ssidController.text,
      password: _passwordController.text,
      mode: EzvizWifiConfigMode.wave,
    );
  }

  Future<void> _startAPConfig() async {
    setState(() {
      status = 'Configuring AP mode...';
    });

    await EzvizWifiConfig.startAPConfig(
      deviceSerial: _deviceSerialController.text,
      ssid: _ssidController.text,
      password: _passwordController.text,
      verifyCode: _verifyCodeController.text,
    );
  }

  Future<void> _stopConfiguration() async {
    try {
      await EzvizWifiConfig.stopConfig();
      setState(() {
        isConfiguring = false;
        status = 'Configuration stopped';
      });
    } catch (e) {
      setState(() {
        status = 'Stop configuration error: $e';
      });
    }
  }

  bool _validateInput() {
    if (_deviceSerialController.text.isEmpty) {
      _showValidationError('Device serial number is required');
      return false;
    }
    
    if (_ssidController.text.isEmpty) {
      _showValidationError('WiFi network name is required');
      return false;
    }
    
    if (_passwordController.text.isEmpty) {
      _showValidationError('WiFi password is required');
      return false;
    }
    
    if (selectedMode == EzvizWifiConfigMode.ap && 
        _verifyCodeController.text.isEmpty) {
      _showValidationError('Verification code is required for AP mode');
      return false;
    }
    
    return true;
  }

  void _showValidationError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _clearForm() {
    _deviceSerialController.clear();
    _verifyCodeController.clear();
    _ssidController.clear();
    _passwordController.clear();
    setState(() {
      status = 'Form cleared';
      selectedMode = EzvizWifiConfigMode.wifi;
    });
  }

  void _showSuccessDialog(EzvizWifiConfigResult result) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green),
            SizedBox(width: 8),
            Text('Configuration Successful'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Device has been configured successfully!'),
            SizedBox(height: 12),
            Text('Device Serial: ${_deviceSerialController.text}'),
            Text('Network: ${_ssidController.text}'),
            Text('Method: ${selectedMode.toString().split('.').last}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _clearForm();
            },
            child: Text('Configure Another'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(EzvizWifiConfigResult result) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.error, color: Colors.red),
            SizedBox(width: 8),
            Text('Configuration Failed'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Configuration could not be completed.'),
            SizedBox(height: 12),
            Text('Error: ${result.errorMessage}'),
            SizedBox(height: 12),
            Text('Troubleshooting:'),
            Text('• Check device is in configuration mode'),
            Text('• Verify WiFi credentials are correct'),
            Text('• Ensure device is within range'),
            Text('• Try a different configuration method'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _startConfiguration();
            },
            child: Text('Retry'),
          ),
        ],
      ),
    );
  }
}
```

## Simple WiFi Configuration Widget

```dart
class SimpleWiFiConfig extends StatefulWidget {
  final String deviceSerial;
  final Function(bool success, String message)? onResult;
  
  const SimpleWiFiConfig({
    Key? key,
    required this.deviceSerial,
    this.onResult,
  }) : super(key: key);

  @override
  _SimpleWiFiConfigState createState() => _SimpleWiFiConfigState();
}

class _SimpleWiFiConfigState extends State<SimpleWiFiConfig> {
  final _ssidController = TextEditingController();
  final _passwordController = TextEditingController();
  bool isConfiguring = false;

  @override
  void initState() {
    super.initState();
    EzvizWifiConfig.setConfigEventHandler((result) {
      setState(() => isConfiguring = false);
      widget.onResult?.call(result.isSuccess, result.errorMessage);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _ssidController,
              decoration: InputDecoration(
                labelText: 'WiFi Network',
                prefixIcon: Icon(Icons.wifi),
              ),
            ),
            SizedBox(height: 12),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: Icon(Icons.lock),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: isConfiguring ? null : _configure,
              icon: Icon(isConfiguring ? Icons.hourglass_empty : Icons.settings),
              label: Text(isConfiguring ? 'Configuring...' : 'Configure'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _configure() async {
    if (_ssidController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    setState(() => isConfiguring = true);

    await EzvizWifiConfig.startWifiConfig(
      deviceSerial: widget.deviceSerial,
      ssid: _ssidController.text,
      password: _passwordController.text,
      mode: EzvizWifiConfigMode.wifi,
    );
  }

  @override
  void dispose() {
    _ssidController.dispose();
    _passwordController.dispose();
    EzvizWifiConfig.removeConfigEventHandler();
    super.dispose();
  }
}
```

## Configuration Utility Class

```dart
class WiFiConfigManager {
  static bool _isConfiguring = false;
  static String? _currentDeviceSerial;
  
  static bool get isConfiguring => _isConfiguring;
  static String? get currentDevice => _currentDeviceSerial;
  
  static Future<bool> configureWiFi({
    required String deviceSerial,
    required String ssid,
    required String password,
    EzvizWifiConfigMode mode = EzvizWifiConfigMode.wifi,
  }) async {
    if (_isConfiguring) {
      throw Exception('Configuration already in progress');
    }
    
    _isConfiguring = true;
    _currentDeviceSerial = deviceSerial;
    
    final completer = Completer<bool>();
    
    EzvizWifiConfig.setConfigEventHandler((result) {
      _isConfiguring = false;
      _currentDeviceSerial = null;
      EzvizWifiConfig.removeConfigEventHandler();
      completer.complete(result.isSuccess);
    });
    
    try {
      await EzvizWifiConfig.startWifiConfig(
        deviceSerial: deviceSerial,
        ssid: ssid,
        password: password,
        mode: mode,
      );
      
      return await completer.future;
    } catch (e) {
      _isConfiguring = false;
      _currentDeviceSerial = null;
      EzvizWifiConfig.removeConfigEventHandler();
      rethrow;
    }
  }
  
  static Future<bool> configureAP({
    required String deviceSerial,
    required String ssid,
    required String password,
    required String verifyCode,
  }) async {
    if (_isConfiguring) {
      throw Exception('Configuration already in progress');
    }
    
    _isConfiguring = true;
    _currentDeviceSerial = deviceSerial;
    
    final completer = Completer<bool>();
    
    EzvizWifiConfig.setConfigEventHandler((result) {
      _isConfiguring = false;
      _currentDeviceSerial = null;
      EzvizWifiConfig.removeConfigEventHandler();
      completer.complete(result.isSuccess);
    });
    
    try {
      await EzvizWifiConfig.startAPConfig(
        deviceSerial: deviceSerial,
        ssid: ssid,
        password: password,
        verifyCode: verifyCode,
      );
      
      return await completer.future;
    } catch (e) {
      _isConfiguring = false;
      _currentDeviceSerial = null;
      EzvizWifiConfig.removeConfigEventHandler();
      rethrow;
    }
  }
  
  static Future<void> stopConfiguration() async {
    if (_isConfiguring) {
      await EzvizWifiConfig.stopConfig();
      _isConfiguring = false;
      _currentDeviceSerial = null;
      EzvizWifiConfig.removeConfigEventHandler();
    }
  }
}
```

## Key Concepts

### Configuration Modes

1. **WiFi Mode**: Direct network configuration
2. **Sound Wave Mode**: Audio-based pairing using sound
3. **AP Mode**: Creates temporary access point for setup

### Configuration Flow

1. Put device in configuration mode
2. Gather network credentials  
3. Select appropriate configuration method
4. Start configuration process
5. Monitor status via event handler
6. Handle success/failure results

### Event Handling

Always set up event handler before starting configuration:
```dart
EzvizWifiConfig.setConfigEventHandler((result) {
  if (result.isSuccess) {
    // Handle success
  } else {
    // Handle error: result.errorMessage
  }
});
```

### Best Practices

1. **Validate Input**: Check all required fields before starting
2. **Handle Events**: Always set up event handler first
3. **Cleanup**: Remove event handler when done
4. **User Feedback**: Show configuration progress
5. **Error Recovery**: Provide retry options for failures

### Troubleshooting

Common configuration issues:
- Device not in configuration mode
- Incorrect WiFi credentials
- Network connectivity problems
- Device out of range
- Interference with configuration signal