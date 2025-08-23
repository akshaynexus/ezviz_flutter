# Audio & Intercom Examples

This document demonstrates audio and intercom functionality for two-way communication with EZVIZ cameras.

## Features Demonstrated

- Two-way audio communication (full-duplex and half-duplex)
- Audio enable/disable controls
- Push-to-talk functionality
- Continuous intercom mode
- Audio status monitoring

## Usage

Import the necessary packages:

```dart
import 'package:ezviz_flutter/ezviz_flutter.dart';
```

## Complete Intercom Example

```dart
class IntercomPage extends StatefulWidget {
  final String deviceSerial;
  final String verifyCode;
  
  const IntercomPage({
    Key? key,
    required this.deviceSerial,
    this.verifyCode = '',
  }) : super(key: key);

  @override
  _IntercomPageState createState() => _IntercomPageState();
}

class _IntercomPageState extends State<IntercomPage> {
  bool isTalking = false;
  bool isAudioEnabled = false;
  bool isFullDuplex = true;
  String status = 'Ready';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Audio & Intercom'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Status Display
            _buildStatusCard(),
            
            SizedBox(height: 32),
            
            // Audio Controls
            _buildAudioControls(),
            
            SizedBox(height: 32),
            
            // Intercom Mode Selection
            _buildModeSelection(),
            
            SizedBox(height: 32),
            
            // Main Intercom Controls
            _buildIntercomControls(),
            
            SizedBox(height: 32),
            
            // Quick Actions
            _buildQuickActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isTalking ? Icons.mic : Icons.mic_off,
                  color: isTalking ? Colors.red : Colors.grey,
                ),
                SizedBox(width: 8),
                Text(
                  'Status: $status',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text('Device: ${widget.deviceSerial}'),
            Text('Audio: ${isAudioEnabled ? 'Enabled' : 'Disabled'}'),
            Text('Mode: ${isFullDuplex ? 'Full-Duplex' : 'Half-Duplex'}'),
            if (isTalking)
              Padding(
                padding: EdgeInsets.only(top: 8),
                child: Row(
                  children: [
                    SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Intercom Active',
                      style: TextStyle(color: Colors.red),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAudioControls() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Audio Controls',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: isAudioEnabled ? _disableAudio : _enableAudio,
                  icon: Icon(isAudioEnabled ? Icons.volume_off : Icons.volume_up),
                  label: Text(isAudioEnabled ? 'Disable Audio' : 'Enable Audio'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isAudioEnabled ? Colors.red : Colors.green,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
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
              'Intercom Mode',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: RadioListTile<bool>(
                    title: Text('Full-Duplex'),
                    subtitle: Text('Simultaneous 2-way talk'),
                    value: true,
                    groupValue: isFullDuplex,
                    onChanged: (value) {
                      setState(() => isFullDuplex = value!);
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile<bool>(
                    title: Text('Half-Duplex'),
                    subtitle: Text('Push-to-talk'),
                    value: false,
                    groupValue: isFullDuplex,
                    onChanged: (value) {
                      setState(() => isFullDuplex = value!);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIntercomControls() {
    return Column(
      children: [
        Text(
          'Intercom Controls',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 20),
        
        if (isFullDuplex) ...[
          // Full-duplex mode - toggle button
          GestureDetector(
            onTap: isTalking ? _stopIntercom : _startFullDuplexIntercom,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: isTalking ? Colors.red : Colors.blue,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                Icons.mic,
                color: Colors.white,
                size: 48,
              ),
            ),
          ),
          SizedBox(height: 12),
          Text(
            isTalking ? 'Tap to Stop' : 'Tap to Start',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ] else ...[
          // Half-duplex mode - push to talk
          GestureDetector(
            onTapDown: (_) => _startHalfDuplexIntercom(),
            onTapUp: (_) => _stopIntercom(),
            onTapCancel: () => _stopIntercom(),
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: isTalking ? Colors.red : Colors.orange,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                Icons.mic,
                color: Colors.white,
                size: 48,
              ),
            ),
          ),
          SizedBox(height: 12),
          Text(
            'Hold to Talk',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ],
      ],
    );
  }

  Widget _buildQuickActions() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick Actions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                ElevatedButton(
                  onPressed: _testAudio,
                  child: Text('Test Audio'),
                ),
                ElevatedButton(
                  onPressed: _checkAudioStatus,
                  child: Text('Check Status'),
                ),
                ElevatedButton(
                  onPressed: _resetAudio,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                  child: Text('Reset'),
                ),
                ElevatedButton(
                  onPressed: isTalking ? _stopIntercom : null,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: Text('Emergency Stop'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Audio Control Methods
  Future<void> _enableAudio() async {
    try {
      final success = await EzvizAudio.openSound();
      if (success) {
        setState(() {
          isAudioEnabled = true;
          status = 'Audio enabled';
        });
      } else {
        setState(() {
          status = 'Failed to enable audio';
        });
      }
    } catch (e) {
      setState(() {
        status = 'Audio error: $e';
      });
    }
  }

  Future<void> _disableAudio() async {
    try {
      // Stop intercom if active
      if (isTalking) {
        await _stopIntercom();
      }
      
      final success = await EzvizAudio.closeSound();
      if (success) {
        setState(() {
          isAudioEnabled = false;
          status = 'Audio disabled';
        });
      } else {
        setState(() {
          status = 'Failed to disable audio';
        });
      }
    } catch (e) {
      setState(() {
        status = 'Audio disable error: $e';
      });
    }
  }

  // Intercom Methods
  Future<void> _startFullDuplexIntercom() async {
    if (!isAudioEnabled) {
      await _enableAudio();
    }

    setState(() {
      status = 'Starting full-duplex intercom...';
    });

    try {
      final success = await EzvizAudio.startVoiceTalk(
        deviceSerial: widget.deviceSerial,
        verifyCode: widget.verifyCode,
        cameraNo: 1,
        isPhone2Dev: 1, // Phone speaks, device listens
        supportTalk: 1, // Full-duplex
      );
      
      if (success) {
        setState(() {
          isTalking = true;
          status = 'Full-duplex intercom active';
        });
      } else {
        setState(() {
          status = 'Failed to start intercom';
        });
      }
    } catch (e) {
      setState(() {
        status = 'Intercom start error: $e';
      });
    }
  }

  Future<void> _startHalfDuplexIntercom() async {
    if (!isAudioEnabled) {
      await _enableAudio();
    }

    setState(() {
      status = 'Starting half-duplex intercom...';
    });

    try {
      final success = await EzvizAudio.startVoiceTalk(
        deviceSerial: widget.deviceSerial,
        verifyCode: widget.verifyCode,
        cameraNo: 1,
        isPhone2Dev: 1, // Phone speaks, device listens
        supportTalk: 3, // Half-duplex
      );
      
      if (success) {
        setState(() {
          isTalking = true;
          status = 'Half-duplex intercom active (talking)';
        });
      } else {
        setState(() {
          status = 'Failed to start intercom';
        });
      }
    } catch (e) {
      setState(() {
        status = 'Intercom start error: $e';
      });
    }
  }

  Future<void> _stopIntercom() async {
    setState(() {
      status = 'Stopping intercom...';
    });

    try {
      await EzvizAudio.stopVoiceTalk();
      setState(() {
        isTalking = false;
        status = 'Intercom stopped';
      });
    } catch (e) {
      setState(() {
        isTalking = false;
        status = 'Intercom stop error: $e';
      });
    }
  }

  // Utility Methods
  Future<void> _testAudio() async {
    setState(() {
      status = 'Testing audio...';
    });
    
    // Simple audio test - enable then disable
    await _enableAudio();
    await Future.delayed(Duration(seconds: 1));
    await _disableAudio();
    
    setState(() {
      status = 'Audio test completed';
    });
  }

  Future<void> _checkAudioStatus() async {
    setState(() {
      status = 'Checking audio status...';
    });
    
    // This would check actual audio status
    // Implementation depends on available APIs
    
    setState(() {
      status = 'Audio check completed - Status: ${isAudioEnabled ? 'Enabled' : 'Disabled'}';
    });
  }

  Future<void> _resetAudio() async {
    setState(() {
      status = 'Resetting audio...';
    });
    
    try {
      // Stop any active intercom
      if (isTalking) {
        await _stopIntercom();
      }
      
      // Reset audio state
      await _disableAudio();
      await Future.delayed(Duration(milliseconds: 500));
      await _enableAudio();
      
      setState(() {
        status = 'Audio reset completed';
      });
    } catch (e) {
      setState(() {
        status = 'Audio reset error: $e';
      });
    }
  }

  @override
  void dispose() {
    // Clean up - stop any active intercom
    if (isTalking) {
      EzvizAudio.stopVoiceTalk();
    }
    super.dispose();
  }
}
```

## Simple Push-to-Talk Widget

```dart
class PushToTalkButton extends StatefulWidget {
  final String deviceSerial;
  final String verifyCode;
  final VoidCallback? onTalkStart;
  final VoidCallback? onTalkStop;
  
  const PushToTalkButton({
    Key? key,
    required this.deviceSerial,
    this.verifyCode = '',
    this.onTalkStart,
    this.onTalkStop,
  }) : super(key: key);

  @override
  _PushToTalkButtonState createState() => _PushToTalkButtonState();
}

class _PushToTalkButtonState extends State<PushToTalkButton> {
  bool isTalking = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _startTalking(),
      onTapUp: (_) => _stopTalking(),
      onTapCancel: () => _stopTalking(),
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: isTalking ? Colors.red : Colors.blue,
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white,
            width: 3,
          ),
        ),
        child: Icon(
          Icons.mic,
          color: Colors.white,
          size: 32,
        ),
      ),
    );
  }

  Future<void> _startTalking() async {
    try {
      final success = await EzvizAudio.startVoiceTalk(
        deviceSerial: widget.deviceSerial,
        verifyCode: widget.verifyCode,
        cameraNo: 1,
        isPhone2Dev: 1,
        supportTalk: 3, // Half-duplex
      );
      
      if (success) {
        setState(() => isTalking = true);
        widget.onTalkStart?.call();
      }
    } catch (e) {
      print('Start talking error: $e');
    }
  }

  Future<void> _stopTalking() async {
    try {
      await EzvizAudio.stopVoiceTalk();
      setState(() => isTalking = false);
      widget.onTalkStop?.call();
    } catch (e) {
      print('Stop talking error: $e');
    }
  }

  @override
  void dispose() {
    if (isTalking) {
      EzvizAudio.stopVoiceTalk();
    }
    super.dispose();
  }
}
```

## Audio Manager Utility

```dart
class AudioManager {
  static bool _isAudioEnabled = false;
  static bool _isTalking = false;
  
  static bool get isAudioEnabled => _isAudioEnabled;
  static bool get isTalking => _isTalking;
  
  static Future<bool> enableAudio() async {
    try {
      final success = await EzvizAudio.openSound();
      _isAudioEnabled = success;
      return success;
    } catch (e) {
      print('Enable audio error: $e');
      return false;
    }
  }
  
  static Future<bool> disableAudio() async {
    try {
      // Stop talking if active
      if (_isTalking) {
        await stopTalking();
      }
      
      final success = await EzvizAudio.closeSound();
      _isAudioEnabled = !success;
      return success;
    } catch (e) {
      print('Disable audio error: $e');
      return false;
    }
  }
  
  static Future<bool> startTalking({
    required String deviceSerial,
    String verifyCode = '',
    int cameraNo = 1,
    bool fullDuplex = false,
  }) async {
    try {
      if (!_isAudioEnabled) {
        await enableAudio();
      }
      
      final success = await EzvizAudio.startVoiceTalk(
        deviceSerial: deviceSerial,
        verifyCode: verifyCode,
        cameraNo: cameraNo,
        isPhone2Dev: 1,
        supportTalk: fullDuplex ? 1 : 3,
      );
      
      _isTalking = success;
      return success;
    } catch (e) {
      print('Start talking error: $e');
      return false;
    }
  }
  
  static Future<bool> stopTalking() async {
    try {
      await EzvizAudio.stopVoiceTalk();
      _isTalking = false;
      return true;
    } catch (e) {
      print('Stop talking error: $e');
      return false;
    }
  }
  
  static Future<void> reset() async {
    if (_isTalking) {
      await stopTalking();
    }
    if (_isAudioEnabled) {
      await disableAudio();
    }
  }
}
```

## Key Concepts

### Audio Modes

1. **Full-Duplex (supportTalk: 1)**: Both parties can talk simultaneously
2. **Half-Duplex (supportTalk: 3)**: Push-to-talk, one direction at a time

### Parameters

- `deviceSerial`: Target camera device serial number
- `verifyCode`: Device verification code (if required)
- `cameraNo`: Camera channel number (usually 1)
- `isPhone2Dev`: Direction (1 = phone to device)
- `supportTalk`: Duplex mode (1 = full, 3 = half)

### Best Practices

1. **Enable Audio First**: Always enable audio before starting intercom
2. **Handle Lifecycle**: Stop intercom in dispose() methods
3. **Error Handling**: Provide user feedback for connection issues
4. **Permission Management**: Request microphone permissions
5. **State Management**: Track audio and talking states properly

### Common Issues

- **No Audio**: Check microphone permissions and device support
- **Echo**: Use half-duplex mode to prevent feedback
- **Connection Failed**: Verify device serial and network connectivity
- **Interrupted Calls**: Handle network interruptions gracefully