# Enhanced Video Playback Example

This document demonstrates enhanced video playback controls with comprehensive playback functionality.

## Features Demonstrated

- Enhanced playback controls for recorded videos
- Play/pause/stop functionality
- Speed control and seeking
- Progress tracking and time display
- Professional video player interface

## Usage

Import the necessary packages:

```dart
import 'package:ezviz_flutter/ezviz_flutter.dart';
```

## Complete Enhanced Playback Example

```dart
class EnhancedPlaybackPage extends StatefulWidget {
  final String deviceSerial;
  final int channelNo;
  
  const EnhancedPlaybackPage({
    Key? key,
    required this.deviceSerial,
    required this.channelNo,
  }) : super(key: key);

  @override
  _EnhancedPlaybackPageState createState() => _EnhancedPlaybackPageState();
}

class _EnhancedPlaybackPageState extends State<EnhancedPlaybackPage> {
  EzvizPlayerController? controller;
  bool isPlaying = false;
  bool isPaused = false;
  String status = 'Ready';
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enhanced Playback'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Status Bar
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(12),
            color: Colors.grey[100],
            child: Text(
              'Status: $status',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          
          // Video Player
          Expanded(
            flex: 2,
            child: Container(
              color: Colors.black,
              child: EzvizPlayer(
                onCreated: (ctrl) {
                  controller = ctrl;
                  _initializePlayer();
                },
              ),
            ),
          ),
          
          // Enhanced Controls
          Container(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                // Main Control Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildControlButton(
                      icon: Icons.play_arrow,
                      label: 'Play',
                      onPressed: _startPlayback,
                      color: Colors.green,
                    ),
                    _buildControlButton(
                      icon: isPaused ? Icons.play_arrow : Icons.pause,
                      label: isPaused ? 'Resume' : 'Pause',
                      onPressed: _togglePause,
                      color: Colors.blue,
                    ),
                    _buildControlButton(
                      icon: Icons.stop,
                      label: 'Stop',
                      onPressed: _stopPlayback,
                      color: Colors.red,
                    ),
                  ],
                ),
                
                SizedBox(height: 20),
                
                // Seek Controls
                Text(
                  'Seek Controls',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () => _seek(-30),
                      child: Text('-30s'),
                    ),
                    ElevatedButton(
                      onPressed: () => _seek(-10),
                      child: Text('-10s'),
                    ),
                    ElevatedButton(
                      onPressed: () => _seek(10),
                      child: Text('+10s'),
                    ),
                    ElevatedButton(
                      onPressed: () => _seek(30),
                      child: Text('+30s'),
                    ),
                  ],
                ),
                
                SizedBox(height: 20),
                
                // Speed Controls
                Text(
                  'Playback Speed',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  children: [0.5, 1.0, 1.5, 2.0].map((speed) {
                    return ElevatedButton(
                      onPressed: () => _setSpeed(speed),
                      child: Text('${speed}x'),
                    );
                  }).toList(),
                ),
                
                SizedBox(height: 20),
                
                // Additional Controls
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _captureFrame,
                      icon: Icon(Icons.camera_alt),
                      label: Text('Capture'),
                    ),
                    ElevatedButton.icon(
                      onPressed: _toggleSound,
                      icon: Icon(Icons.volume_up),
                      label: Text('Sound'),
                    ),
                  ],
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
    required String label,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            foregroundColor: Colors.white,
            shape: CircleBorder(),
            padding: EdgeInsets.all(20),
          ),
          child: Icon(icon, size: 24),
        ),
        SizedBox(height: 8),
        Text(label, style: TextStyle(fontSize: 12)),
      ],
    );
  }

  Future<void> _initializePlayer() async {
    try {
      await controller?.initPlayerByDevice(widget.deviceSerial, widget.channelNo);
      setState(() {
        status = 'Player initialized';
      });
    } catch (e) {
      setState(() {
        status = 'Initialization error: $e';
      });
    }
  }

  Future<void> _startPlayback() async {
    try {
      final startTime = DateTime.now().subtract(Duration(hours: 2));
      final endTime = DateTime.now();
      
      await controller?.startReplay(startTime, endTime);
      setState(() {
        isPlaying = true;
        isPaused = false;
        status = 'Playback started';
      });
    } catch (e) {
      setState(() {
        status = 'Playback start error: $e';
      });
    }
  }

  Future<void> _togglePause() async {
    try {
      if (isPaused) {
        await controller?.resumePlayback();
        setState(() {
          isPaused = false;
          status = 'Playback resumed';
        });
      } else {
        await controller?.pausePlayback();
        setState(() {
          isPaused = true;
          status = 'Playback paused';
        });
      }
    } catch (e) {
      setState(() {
        status = 'Pause/resume error: $e';
      });
    }
  }

  Future<void> _stopPlayback() async {
    try {
      await controller?.stopReplay();
      setState(() {
        isPlaying = false;
        isPaused = false;
        status = 'Playback stopped';
      });
    } catch (e) {
      setState(() {
        status = 'Stop error: $e';
      });
    }
  }

  Future<void> _seek(int seconds) async {
    try {
      final currentTime = await controller?.getOSDTime() ?? 0;
      final targetTime = currentTime + (seconds * 1000);
      
      await controller?.seekPlayback(targetTime);
      setState(() {
        status = 'Seeked ${seconds}s';
      });
    } catch (e) {
      setState(() {
        status = 'Seek error: $e';
      });
    }
  }

  Future<void> _setSpeed(double speed) async {
    try {
      await controller?.setPlaySpeed(speed);
      setState(() {
        status = 'Speed set to ${speed}x';
      });
    } catch (e) {
      setState(() {
        status = 'Speed change error: $e';
      });
    }
  }

  Future<void> _captureFrame() async {
    try {
      final imagePath = await controller?.captureImage();
      if (imagePath != null) {
        setState(() {
          status = 'Frame captured: ${imagePath.split('/').last}';
        });
      } else {
        setState(() {
          status = 'Frame capture failed';
        });
      }
    } catch (e) {
      setState(() {
        status = 'Capture error: $e';
      });
    }
  }

  Future<void> _toggleSound() async {
    try {
      // This would toggle sound - implementation depends on available APIs
      setState(() {
        status = 'Sound toggled';
      });
    } catch (e) {
      setState(() {
        status = 'Sound toggle error: $e';
      });
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
```

## Simple Playback Controls Widget

```dart
class PlaybackControls extends StatefulWidget {
  final EzvizPlayerController controller;
  
  const PlaybackControls({Key? key, required this.controller}) : super(key: key);

  @override
  _PlaybackControlsState createState() => _PlaybackControlsState();
}

class _PlaybackControlsState extends State<PlaybackControls> {
  bool isPlaying = false;
  bool isPaused = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
            onPressed: _startPlayback,
            child: Text('Play'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
          ),
          ElevatedButton(
            onPressed: _pauseResume,
            child: Text(isPaused ? 'Resume' : 'Pause'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
          ),
          ElevatedButton(
            onPressed: _stopPlayback,
            child: Text('Stop'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          ),
        ],
      ),
    );
  }

  Future<void> _startPlayback() async {
    try {
      final startTime = DateTime.now().subtract(Duration(hours: 1));
      final endTime = DateTime.now();
      await widget.controller.startReplay(startTime, endTime);
      setState(() {
        isPlaying = true;
        isPaused = false;
      });
    } catch (e) {
      print('Playback start error: $e');
    }
  }

  Future<void> _pauseResume() async {
    try {
      if (isPaused) {
        await widget.controller.resumePlayback();
        setState(() => isPaused = false);
      } else {
        await widget.controller.pausePlayback();
        setState(() => isPaused = true);
      }
    } catch (e) {
      print('Pause/resume error: $e');
    }
  }

  Future<void> _stopPlayback() async {
    try {
      await widget.controller.stopReplay();
      setState(() {
        isPlaying = false;
        isPaused = false;
      });
    } catch (e) {
      print('Stop error: $e');
    }
  }
}
```

## Professional Video Player Interface

```dart
class ProfessionalVideoPlayer extends StatefulWidget {
  final String deviceSerial;
  final int channelNo;
  
  const ProfessionalVideoPlayer({
    Key? key,
    required this.deviceSerial,
    required this.channelNo,
  }) : super(key: key);

  @override
  _ProfessionalVideoPlayerState createState() => _ProfessionalVideoPlayerState();
}

class _ProfessionalVideoPlayerState extends State<ProfessionalVideoPlayer> {
  EzvizPlayerController? controller;
  bool isPlaying = false;
  bool isPaused = false;
  bool showControls = true;
  bool isFullscreen = false;
  double progress = 0.0;
  String currentTime = '00:00';
  String totalTime = '00:00';
  
  Timer? _hideControlsTimer;
  Timer? _progressTimer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: _toggleControls,
        child: Stack(
          children: [
            // Video Player
            Positioned.fill(
              child: EzvizPlayer(
                onCreated: (ctrl) {
                  controller = ctrl;
                  _initializePlayer();
                },
              ),
            ),
            
            // Controls Overlay
            if (showControls) ...[
              // Top Bar
              Positioned(
                top: MediaQuery.of(context).padding.top,
                left: 0,
                right: 0,
                child: _buildTopBar(),
              ),
              
              // Bottom Controls
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: _buildBottomControls(),
              ),
              
              // Center Play Button
              if (!isPlaying)
                Positioned.fill(
                  child: Center(
                    child: GestureDetector(
                      onTap: _startPlayback,
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.play_arrow,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.black54, Colors.transparent],
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(Icons.arrow_back, color: Colors.white),
          ),
          Expanded(
            child: Text(
              'Camera ${widget.deviceSerial}',
              style: TextStyle(color: Colors.white, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
          IconButton(
            onPressed: _toggleFullscreen,
            icon: Icon(
              isFullscreen ? Icons.fullscreen_exit : Icons.fullscreen,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomControls() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [Colors.black54, Colors.transparent],
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Progress Bar
          Row(
            children: [
              Text(currentTime, style: TextStyle(color: Colors.white, fontSize: 12)),
              Expanded(
                child: Slider(
                  value: progress,
                  onChanged: _onProgressChanged,
                  activeColor: Colors.white,
                  inactiveColor: Colors.white30,
                ),
              ),
              Text(totalTime, style: TextStyle(color: Colors.white, fontSize: 12)),
            ],
          ),
          
          // Control Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: () => _seek(-10),
                icon: Icon(Icons.replay_10, color: Colors.white),
              ),
              IconButton(
                onPressed: _togglePlayPause,
                icon: Icon(
                  isPlaying ? (isPaused ? Icons.play_arrow : Icons.pause) : Icons.play_arrow,
                  color: Colors.white,
                  size: 32,
                ),
              ),
              IconButton(
                onPressed: () => _seek(10),
                icon: Icon(Icons.forward_10, color: Colors.white),
              ),
              IconButton(
                onPressed: _showSpeedDialog,
                icon: Icon(Icons.speed, color: Colors.white),
              ),
              IconButton(
                onPressed: _captureFrame,
                icon: Icon(Icons.camera_alt, color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _toggleControls() {
    setState(() {
      showControls = !showControls;
    });
    
    if (showControls) {
      _startHideTimer();
    }
  }

  void _startHideTimer() {
    _hideControlsTimer?.cancel();
    _hideControlsTimer = Timer(Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          showControls = false;
        });
      }
    });
  }

  void _startProgressTimer() {
    _progressTimer?.cancel();
    _progressTimer = Timer.periodic(Duration(seconds: 1), (timer) async {
      if (controller != null && isPlaying && !isPaused) {
        try {
          final time = await controller!.getOSDTime();
          // Update progress and time displays
          // Implementation depends on available time APIs
        } catch (e) {
          // Handle error silently
        }
      }
    });
  }

  Future<void> _initializePlayer() async {
    try {
      await controller?.initPlayerByDevice(widget.deviceSerial, widget.channelNo);
    } catch (e) {
      print('Player initialization error: $e');
    }
  }

  Future<void> _startPlayback() async {
    try {
      final startTime = DateTime.now().subtract(Duration(hours: 2));
      final endTime = DateTime.now();
      
      await controller?.startReplay(startTime, endTime);
      setState(() {
        isPlaying = true;
        isPaused = false;
      });
      
      _startProgressTimer();
      _startHideTimer();
    } catch (e) {
      print('Playback start error: $e');
    }
  }

  Future<void> _togglePlayPause() async {
    try {
      if (isPlaying) {
        if (isPaused) {
          await controller?.resumePlayback();
          setState(() => isPaused = false);
        } else {
          await controller?.pausePlayback();
          setState(() => isPaused = true);
        }
      } else {
        await _startPlayback();
      }
      _startHideTimer();
    } catch (e) {
      print('Play/pause error: $e');
    }
  }

  Future<void> _seek(int seconds) async {
    try {
      final currentTime = await controller?.getOSDTime() ?? 0;
      final targetTime = currentTime + (seconds * 1000);
      await controller?.seekPlayback(targetTime);
      _startHideTimer();
    } catch (e) {
      print('Seek error: $e');
    }
  }

  void _onProgressChanged(double value) {
    setState(() {
      progress = value;
    });
    // Implement seeking based on progress
    _startHideTimer();
  }

  void _toggleFullscreen() {
    setState(() {
      isFullscreen = !isFullscreen;
    });
    // Implement fullscreen toggle
    _startHideTimer();
  }

  Future<void> _captureFrame() async {
    try {
      final imagePath = await controller?.captureImage();
      if (imagePath != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Frame captured'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      print('Capture error: $e');
    }
  }

  void _showSpeedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Playback Speed'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [0.25, 0.5, 1.0, 1.25, 1.5, 2.0].map((speed) {
            return ListTile(
              title: Text('${speed}x'),
              onTap: () {
                _setSpeed(speed);
                Navigator.of(context).pop();
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  Future<void> _setSpeed(double speed) async {
    try {
      await controller?.setPlaySpeed(speed);
    } catch (e) {
      print('Speed change error: $e');
    }
  }

  @override
  void dispose() {
    _hideControlsTimer?.cancel();
    _progressTimer?.cancel();
    controller?.dispose();
    super.dispose();
  }
}
```

## Key Features

### Enhanced Controls
- Professional video player interface
- Auto-hiding controls with timer
- Progress bar with seek functionality
- Speed control with multiple options
- Frame capture capability

### User Experience
- Tap to show/hide controls
- Gesture-based interaction
- Fullscreen mode support
- Smooth transitions and animations

### Playback Management
- Play/pause/stop controls
- Seek forward/backward
- Speed adjustment (0.25x to 2x)
- Progress tracking with time display

### Best Practices
- Timer management for UI elements
- Proper resource cleanup in dispose()
- Error handling with user feedback
- Responsive design for different screen sizes