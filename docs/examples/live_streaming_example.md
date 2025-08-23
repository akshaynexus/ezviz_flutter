# Manual Enhanced Live Streaming Example

This document demonstrates manual enhanced live streaming functionality with comprehensive controls and features.

## Features Demonstrated

- Manual live stream initialization and control
- Enhanced player controls overlay
- Stream quality management
- Audio controls and PTZ integration
- Professional streaming interface

## Usage

Import the necessary packages:

```dart
import 'package:ezviz_flutter/ezviz_flutter.dart';
```

## Complete Enhanced Live Stream Example

```dart
class EnhancedLiveStreamPage extends StatefulWidget {
  final String deviceSerial;
  final int channelNo;
  
  const EnhancedLiveStreamPage({
    Key? key,
    required this.deviceSerial,
    required this.channelNo,
  }) : super(key: key);

  @override
  _EnhancedLiveStreamPageState createState() => _EnhancedLiveStreamPageState();
}

class _EnhancedLiveStreamPageState extends State<EnhancedLiveStreamPage> {
  EzvizPlayerController? playerController;
  bool isPlaying = false;
  bool isRecording = false;
  bool soundEnabled = false;
  bool isFullScreen = false;
  int currentQuality = 2; // 0=smooth, 1=balanced, 2=HD, 3=UHD
  String status = 'Ready to stream';
  
  final List<String> qualityNames = ['Smooth', 'Balanced', 'HD', 'UHD'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Video Player
          Container(
            width: double.infinity,
            height: isFullScreen ? MediaQuery.of(context).size.height : 300,
            child: EzvizPlayer(
              onCreated: (controller) {
                playerController = controller;
                _initializePlayer();
              },
            ),
          ),
          
          // Enhanced Controls Overlay
          if (!isFullScreen) ...[
            Container(
              width: double.infinity,
              height: 300,
              child: EnhancedPlayerControls(
                isPlaying: isPlaying,
                isRecording: isRecording,
                soundEnabled: soundEnabled,
                isFullScreen: isFullScreen,
                currentQuality: currentQuality,
                qualityNames: qualityNames,
                onPlayPause: _togglePlayback,
                onStop: _stopPlayback,
                onRecord: _toggleRecording,
                onScreenshot: _takeScreenshot,
                onSoundToggle: _toggleSound,
                onFullScreenToggle: _toggleFullScreen,
                onQualityChange: _changeQuality,
              ),
            ),
          ],
          
          // Status bar
          if (!isFullScreen)
            Positioned(
              bottom: 310,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                color: Colors.black54,
                child: Text(
                  status,
                  style: TextStyle(color: Colors.white, fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
      
      // Bottom controls and information
      bottomNavigationBar: isFullScreen ? null : _buildBottomControls(),
    );
  }

  Widget _buildBottomControls() {
    return Container(
      padding: EdgeInsets.all(16),
      color: Colors.grey[900],
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Device Information
          Row(
            children: [
              Icon(Icons.videocam, color: Colors.white70),
              SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Device: ${widget.deviceSerial}',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Channel: ${widget.channelNo} | Quality: ${qualityNames[currentQuality]}',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
              ),
              // Connection indicator
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: isPlaying ? Colors.green : Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
          
          SizedBox(height: 16),
          
          // Quick action buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildQuickButton(
                icon: Icons.refresh,
                label: 'Reconnect',
                onPressed: _reconnectStream,
              ),
              _buildQuickButton(
                icon: Icons.settings,
                label: 'Settings',
                onPressed: _showSettingsDialog,
              ),
              _buildQuickButton(
                icon: Icons.info,
                label: 'Info',
                onPressed: _showStreamInfo,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: onPressed,
          icon: Icon(icon, color: Colors.white70),
          style: IconButton.styleFrom(
            backgroundColor: Colors.white10,
            padding: EdgeInsets.all(12),
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(color: Colors.white70, fontSize: 10),
        ),
      ],
    );
  }

  Future<void> _initializePlayer() async {
    setState(() {
      status = 'Initializing player...';
    });

    try {
      await playerController?.initPlayerByDevice(widget.deviceSerial, widget.channelNo);
      await playerController?.setPlayVerifyCode(''); // Add verify code if needed
      
      setState(() {
        status = 'Player initialized. Ready to start stream.';
      });
    } catch (e) {
      setState(() {
        status = 'Initialization error: $e';
      });
    }
  }

  Future<void> _togglePlayback() async {
    if (isPlaying) {
      await _stopPlayback();
    } else {
      await _startPlayback();
    }
  }

  Future<void> _startPlayback() async {
    setState(() {
      status = 'Starting live stream...';
    });

    try {
      await playerController?.startRealPlay();
      setState(() {
        isPlaying = true;
        status = 'Live stream active';
      });
    } catch (e) {
      setState(() {
        status = 'Stream start error: $e';
      });
    }
  }

  Future<void> _stopPlayback() async {
    setState(() {
      status = 'Stopping stream...';
    });

    try {
      await playerController?.stopRealPlay();
      setState(() {
        isPlaying = false;
        status = 'Stream stopped';
      });
    } catch (e) {
      setState(() {
        status = 'Stream stop error: $e';
      });
    }
  }

  Future<void> _toggleRecording() async {
    if (isRecording) {
      await _stopRecording();
    } else {
      await _startRecording();
    }
  }

  Future<void> _startRecording() async {
    setState(() {
      status = 'Starting recording...';
    });

    try {
      final success = await playerController?.startRecording();
      if (success == true) {
        setState(() {
          isRecording = true;
          status = 'Recording started';
        });
      } else {
        setState(() {
          status = 'Failed to start recording';
        });
      }
    } catch (e) {
      setState(() {
        status = 'Recording start error: $e';
      });
    }
  }

  Future<void> _stopRecording() async {
    setState(() {
      status = 'Stopping recording...';
    });

    try {
      final success = await playerController?.stopRecording();
      if (success == true) {
        setState(() {
          isRecording = false;
          status = 'Recording stopped';
        });
      } else {
        setState(() {
          status = 'Failed to stop recording';
        });
      }
    } catch (e) {
      setState(() {
        status = 'Recording stop error: $e';
      });
    }
  }

  Future<void> _takeScreenshot() async {
    setState(() {
      status = 'Taking screenshot...';
    });

    try {
      final imagePath = await playerController?.capturePicture();
      if (imagePath != null) {
        setState(() {
          status = 'Screenshot saved: ${imagePath.split('/').last}';
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Screenshot saved: ${imagePath.split('/').last}'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        setState(() {
          status = 'Screenshot failed';
        });
      }
    } catch (e) {
      setState(() {
        status = 'Screenshot error: $e';
      });
    }
  }

  Future<void> _toggleSound() async {
    setState(() {
      status = soundEnabled ? 'Disabling sound...' : 'Enabling sound...';
    });

    try {
      if (soundEnabled) {
        await playerController?.closeSound();
        setState(() {
          soundEnabled = false;
          status = 'Sound disabled';
        });
      } else {
        await playerController?.openSound();
        setState(() {
          soundEnabled = true;
          status = 'Sound enabled';
        });
      }
    } catch (e) {
      setState(() {
        status = 'Sound toggle error: $e';
      });
    }
  }

  void _toggleFullScreen() {
    setState(() {
      isFullScreen = !isFullScreen;
      status = isFullScreen ? 'Entering fullscreen' : 'Exiting fullscreen';
    });
  }

  Future<void> _changeQuality(int quality) async {
    setState(() {
      status = 'Changing quality to ${qualityNames[quality]}...';
    });

    try {
      // Stop current stream
      if (isPlaying) {
        await playerController?.stopRealPlay();
      }
      
      // Set new quality
      await playerController?.setVideoQuality(quality);
      
      // Restart stream with new quality
      if (isPlaying) {
        await playerController?.startRealPlay();
      }
      
      setState(() {
        currentQuality = quality;
        status = 'Quality changed to ${qualityNames[quality]}';
      });
    } catch (e) {
      setState(() {
        status = 'Quality change error: $e';
      });
    }
  }

  Future<void> _reconnectStream() async {
    setState(() {
      status = 'Reconnecting stream...';
    });

    try {
      // Stop current stream
      if (isPlaying) {
        await playerController?.stopRealPlay();
        setState(() {
          isPlaying = false;
        });
      }
      
      // Wait a moment
      await Future.delayed(Duration(seconds: 1));
      
      // Restart stream
      await _startPlayback();
    } catch (e) {
      setState(() {
        status = 'Reconnection error: $e';
      });
    }
  }

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Stream Settings'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Quality Selection
            Text('Video Quality:', style: TextStyle(fontWeight: FontWeight.bold)),
            ...qualityNames.asMap().entries.map((entry) {
              return RadioListTile<int>(
                title: Text(entry.value),
                value: entry.key,
                groupValue: currentQuality,
                onChanged: (value) {
                  Navigator.of(context).pop();
                  _changeQuality(value!);
                },
              );
            }).toList(),
            
            SizedBox(height: 16),
            
            // Audio Settings
            SwitchListTile(
              title: Text('Enable Audio'),
              value: soundEnabled,
              onChanged: (value) {
                Navigator.of(context).pop();
                _toggleSound();
              },
            ),
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

  void _showStreamInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Stream Information'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow('Device Serial', widget.deviceSerial),
            _buildInfoRow('Channel', '${widget.channelNo}'),
            _buildInfoRow('Status', isPlaying ? 'Streaming' : 'Stopped'),
            _buildInfoRow('Quality', qualityNames[currentQuality]),
            _buildInfoRow('Audio', soundEnabled ? 'Enabled' : 'Disabled'),
            _buildInfoRow('Recording', isRecording ? 'Active' : 'Inactive'),
            _buildInfoRow('Fullscreen', isFullScreen ? 'Yes' : 'No'),
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

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // Clean up resources
    if (isPlaying) {
      playerController?.stopRealPlay();
    }
    if (isRecording) {
      playerController?.stopRecording();
    }
    playerController?.dispose();
    super.dispose();
  }
}
```

## Enhanced Player Controls Widget

```dart
class EnhancedPlayerControls extends StatelessWidget {
  final bool isPlaying;
  final bool isRecording;
  final bool soundEnabled;
  final bool isFullScreen;
  final int currentQuality;
  final List<String> qualityNames;
  final VoidCallback onPlayPause;
  final VoidCallback onStop;
  final VoidCallback onRecord;
  final VoidCallback onScreenshot;
  final VoidCallback onSoundToggle;
  final VoidCallback onFullScreenToggle;
  final Function(int) onQualityChange;

  const EnhancedPlayerControls({
    Key? key,
    required this.isPlaying,
    required this.isRecording,
    required this.soundEnabled,
    required this.isFullScreen,
    required this.currentQuality,
    required this.qualityNames,
    required this.onPlayPause,
    required this.onStop,
    required this.onRecord,
    required this.onScreenshot,
    required this.onSoundToggle,
    required this.onFullScreenToggle,
    required this.onQualityChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Colors.black26,
            Colors.black54,
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Top row - Quality and fullscreen
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Quality indicator
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    qualityNames[currentQuality],
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
                
                // Fullscreen button
                IconButton(
                  onPressed: onFullScreenToggle,
                  icon: Icon(
                    isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          
          Spacer(),
          
          // Main control buttons
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildControlButton(
                  icon: isPlaying ? Icons.pause : Icons.play_arrow,
                  onPressed: onPlayPause,
                  active: isPlaying,
                ),
                _buildControlButton(
                  icon: Icons.stop,
                  onPressed: onStop,
                ),
                _buildControlButton(
                  icon: Icons.fiber_manual_record,
                  onPressed: onRecord,
                  active: isRecording,
                  activeColor: Colors.red,
                ),
                _buildControlButton(
                  icon: Icons.camera_alt,
                  onPressed: onScreenshot,
                ),
                _buildControlButton(
                  icon: soundEnabled ? Icons.volume_up : Icons.volume_off,
                  onPressed: onSoundToggle,
                  active: soundEnabled,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback onPressed,
    bool active = false,
    Color activeColor = Colors.blue,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: active ? activeColor.withOpacity(0.3) : Colors.black26,
        shape: BoxShape.circle,
        border: active ? Border.all(color: activeColor, width: 2) : null,
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.white),
        iconSize: 24,
      ),
    );
  }
}
```

## Simple Live Stream Widget

```dart
class SimpleLiveStream extends StatefulWidget {
  final String deviceSerial;
  final int channelNo;
  final String? verifyCode;
  
  const SimpleLiveStream({
    Key? key,
    required this.deviceSerial,
    required this.channelNo,
    this.verifyCode,
  }) : super(key: key);

  @override
  _SimpleLiveStreamState createState() => _SimpleLiveStreamState();
}

class _SimpleLiveStreamState extends State<SimpleLiveStream> {
  EzvizPlayerController? controller;
  bool isPlaying = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Video player
        Container(
          height: 200,
          color: Colors.black,
          child: EzvizPlayer(
            onCreated: (ctrl) {
              controller = ctrl;
              _initializeStream();
            },
          ),
        ),
        
        // Simple controls
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: isPlaying ? _stop : _start,
              child: Text(isPlaying ? 'Stop' : 'Start'),
            ),
            ElevatedButton(
              onPressed: _screenshot,
              child: Text('Screenshot'),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _initializeStream() async {
    await controller?.initPlayerByDevice(widget.deviceSerial, widget.channelNo);
    if (widget.verifyCode != null) {
      await controller?.setPlayVerifyCode(widget.verifyCode!);
    }
  }

  Future<void> _start() async {
    await controller?.startRealPlay();
    setState(() => isPlaying = true);
  }

  Future<void> _stop() async {
    await controller?.stopRealPlay();
    setState(() => isPlaying = false);
  }

  Future<void> _screenshot() async {
    final path = await controller?.capturePicture();
    if (path != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Screenshot saved')),
      );
    }
  }

  @override
  void dispose() {
    if (isPlaying) {
      controller?.stopRealPlay();
    }
    controller?.dispose();
    super.dispose();
  }
}
```

## Key Concepts

### Live Stream Management
- Initialize player with device credentials
- Start/stop real-time playback
- Handle stream quality changes
- Manage audio/video settings

### Enhanced Controls
- Professional overlay interface
- Quality selection and display
- Recording controls with indicators
- Fullscreen mode support
- Real-time status updates

### Resource Management
- Proper cleanup in dispose()
- Handle stream reconnection
- Manage multiple concurrent features
- Error handling with user feedback

### User Experience
- Smooth control transitions
- Visual feedback for all actions
- Settings and information dialogs
- Quick action buttons for common tasks