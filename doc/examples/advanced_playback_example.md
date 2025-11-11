# Advanced Playback Controls Example

This example demonstrates enhanced playback control with comprehensive features including pause/resume, seek, speed control, and progress tracking.

## Features Demonstrated

- Advanced playback controls for recorded videos
- Progress bar with seek functionality
- Playback speed control (0.25x to 4x)
- Time display and formatting
- Screenshot capture during playback
- Local recording during playback
- Real-time time updates

## Usage

Import the necessary packages:

```dart
import 'package:ezviz_flutter/ezviz_flutter.dart';
import 'dart:async';
```

## Complete Example

```dart
class AdvancedPlaybackExample extends StatefulWidget {
  final EzvizCloudRecordFile recordFile;
  
  const AdvancedPlaybackExample({
    Key? key, 
    required this.recordFile
  }) : super(key: key);
  
  @override
  _AdvancedPlaybackExampleState createState() => _AdvancedPlaybackExampleState();
}

class _AdvancedPlaybackExampleState extends State<AdvancedPlaybackExample> {
  EzvizPlayerController? controller;
  bool isPlaying = false;
  bool isPaused = false;
  bool isLocalRecording = false;
  double currentSpeed = 1.0;
  int currentTime = 0;
  Timer? _timeUpdateTimer;
  
  @override
  void dispose() {
    _timeUpdateTimer?.cancel();
    controller?.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Advanced Playback'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Video Player
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              color: Colors.black,
              child: EzvizPlayer(
                onCreated: (ctrl) {
                  controller = ctrl;
                  _initializePlayback();
                },
              ),
            ),
          ),
          
          // Advanced Playback Controls
          Expanded(
            flex: 2,
            child: Container(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  // Progress Bar
                  Row(
                    children: [
                      Text(
                        EzvizPlaybackUtils.formatPlaybackTime(currentTime),
                        style: TextStyle(fontSize: 12),
                      ),
                      Expanded(
                        child: Slider(
                          value: EzvizPlaybackUtils.calculateProgress(
                            currentTime: currentTime,
                            startTime: widget.recordFile.startTime,
                            endTime: widget.recordFile.endTime,
                          ),
                          onChanged: (value) => _seekToProgress(value),
                          activeColor: Colors.purple,
                        ),
                      ),
                      Text(
                        EzvizPlaybackUtils.formatPlaybackTime(widget.recordFile.endTime),
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                  
                  // Control Buttons Row 1
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildControlButton(
                        icon: isPlaying && !isPaused ? Icons.pause : Icons.play_arrow,
                        label: isPaused ? 'Resume' : (isPlaying ? 'Pause' : 'Play'),
                        onPressed: _togglePlayback,
                        color: Colors.blue,
                      ),
                      _buildControlButton(
                        icon: Icons.stop,
                        label: 'Stop',
                        onPressed: _stopPlayback,
                        color: Colors.red,
                      ),
                      _buildControlButton(
                        icon: Icons.camera_alt,
                        label: 'Screenshot',
                        onPressed: _captureImage,
                        color: Colors.green,
                      ),
                      _buildControlButton(
                        icon: isLocalRecording ? Icons.stop_circle : Icons.fiber_manual_record,
                        label: isLocalRecording ? 'Stop Rec' : 'Record',
                        onPressed: _toggleRecording,
                        color: isLocalRecording ? Colors.red : Colors.orange,
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 16),
                  
                  // Speed Control
                  Text('Playback Speed:', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: EzvizPlaybackUtils.getPlaybackSpeeds().map(
                      (speed) => _buildSpeedButton(speed),
                    ).toList(),
                  ),
                  
                  SizedBox(height: 16),
                  
                  // Status Information
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('File: ${widget.recordFile.fileName}'),
                        Text('Size: ${(widget.recordFile.fileSize / 1024 / 1024).toStringAsFixed(2)} MB'),
                        Text('Type: ${_getRecordTypeString(widget.recordFile.recType)}'),
                        Text('Speed: ${currentSpeed}x'),
                        if (isLocalRecording)
                          Text('🔴 Local Recording Active', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
              ),
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
            padding: EdgeInsets.all(16),
          ),
          child: Icon(icon, size: 24),
        ),
        SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 10)),
      ],
    );
  }

  Widget _buildSpeedButton(PlaybackSpeed speed) {
    final isSelected = currentSpeed == speed.value;
    return ElevatedButton(
      onPressed: () => _setPlaybackSpeed(speed.value),
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.purple : Colors.grey[300],
        foregroundColor: isSelected ? Colors.white : Colors.black,
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      ),
      child: Text(speed.display, style: TextStyle(fontSize: 12)),
    );
  }

  Future<void> _initializePlayback() async {
    try {
      // Initialize playback for the specific record file
      await controller?.startReplayByCloudFile(widget.recordFile);
      setState(() => isPlaying = true);
      
      // Start time updates
      _startTimeUpdates();
    } catch (e) {
      _showError('Failed to initialize playback: $e');
    }
  }

  void _startTimeUpdates() {
    _timeUpdateTimer?.cancel();
    _timeUpdateTimer = Timer.periodic(Duration(seconds: 1), (timer) async {
      if (controller != null && isPlaying && !isPaused) {
        try {
          final time = await controller!.getOSDTime();
          if (mounted) {
            setState(() => currentTime = time);
          }
        } catch (e) {
          // Handle time update errors silently
        }
      }
    });
  }

  Future<void> _togglePlayback() async {
    try {
      if (isPaused) {
        await controller?.resumePlayback();
        setState(() => isPaused = false);
        _startTimeUpdates();
      } else if (isPlaying) {
        await controller?.pausePlayback();
        setState(() => isPaused = true);
        _timeUpdateTimer?.cancel();
      } else {
        // Start playback if stopped
        await _initializePlayback();
      }
    } catch (e) {
      _showError('Playback control failed: $e');
    }
  }

  Future<void> _stopPlayback() async {
    try {
      await controller?.stopReplay();
      setState(() {
        isPlaying = false;
        isPaused = false;
        currentTime = widget.recordFile.startTime;
      });
      _timeUpdateTimer?.cancel();
    } catch (e) {
      _showError('Stop playback failed: $e');
    }
  }

  Future<void> _seekToProgress(double progress) async {
    if (!isPlaying) return;
    
    try {
      final targetTime = EzvizPlaybackUtils.progressToTime(
        progress: progress,
        startTime: widget.recordFile.startTime,
        endTime: widget.recordFile.endTime,
      );
      
      final success = await controller?.seekPlayback(targetTime);
      if (success == true) {
        setState(() => currentTime = targetTime);
      }
    } catch (e) {
      _showError('Seek failed: $e');
    }
  }

  Future<void> _setPlaybackSpeed(double speed) async {
    try {
      final success = await controller?.setPlaySpeed(speed);
      if (success == true) {
        setState(() => currentSpeed = speed);
        _showSuccess('Playback speed set to ${speed}x');
      }
    } catch (e) {
      _showError('Speed change failed: $e');
    }
  }

  Future<void> _captureImage() async {
    try {
      final imagePath = await controller?.captureImage();
      if (imagePath != null) {
        _showSuccess('Screenshot saved: $imagePath');
      } else {
        _showError('Screenshot failed');
      }
    } catch (e) {
      _showError('Screenshot error: $e');
    }
  }

  Future<void> _toggleRecording() async {
    try {
      if (isLocalRecording) {
        final success = await controller?.stopLocalRecord();
        if (success == true) {
          setState(() => isLocalRecording = false);
          _showSuccess('Recording stopped');
        }
      } else {
        // Generate a unique file path
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final filePath = '/storage/emulated/0/Download/ezviz_recording_$timestamp.mp4';
        
        final success = await controller?.startLocalRecord(filePath);
        if (success == true) {
          setState(() => isLocalRecording = true);
          _showSuccess('Recording started: $filePath');
        }
      }
    } catch (e) {
      _showError('Recording control failed: $e');
    }
  }

  String _getRecordTypeString(int recType) {
    switch (recType) {
      case 1: return 'Timing';
      case 2: return 'Alarm';
      case 3: return 'Manual';
      default: return 'Unknown';
    }
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
      ),
    );
  }
}
```

## Utility Functions Example

```dart
class PlaybackControlsExample extends StatelessWidget {
  final EzvizPlayerController controller;
  
  const PlaybackControlsExample({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: () => _startPlayback(),
          child: Text('Play'),
        ),
        ElevatedButton(
          onPressed: () => _pauseResume(),
          child: Text('Pause/Resume'),
        ),
        ElevatedButton(
          onPressed: () => _stopPlayback(),
          child: Text('Stop'),
        ),
      ],
    );
  }

  Future<void> _startPlayback() async {
    final startTime = DateTime.now().subtract(Duration(hours: 1));
    final endTime = DateTime.now();
    await controller.startReplay(startTime, endTime);
  }

  Future<void> _pauseResume() async {
    // Toggle between pause and resume
    final isRecording = await controller.isLocalRecording();
    if (isRecording) {
      await controller.resumePlayback();
    } else {
      await controller.pausePlayback();
    }
  }

  Future<void> _stopPlayback() async {
    await controller.stopReplay();
  }
}
```

## Key Concepts

### Playback Control Flow

1. **Initialize**: Call `startReplayByCloudFile()` with record file
2. **Control**: Use pause/resume/stop methods
3. **Seek**: Use `seekPlayback()` with target time in milliseconds
4. **Speed**: Use `setPlaySpeed()` with multiplier (0.25 to 4.0)
5. **Cleanup**: Cancel timers and dispose controller

### Time Management

- All times are in milliseconds since epoch
- Use `EzvizPlaybackUtils.formatPlaybackTime()` for display
- Progress calculation: `(current - start) / (end - start)`

### Local Recording

- Generate unique file paths to avoid conflicts
- Check recording status with `isLocalRecording()`
- Handle storage permissions appropriately

### Error Handling

Always wrap playback operations in try-catch blocks:
```dart
try {
  await controller?.pausePlayback();
} catch (e) {
  // Handle error appropriately
  print('Playback error: $e');
}
```

## Best Practices

1. **Timer Management**: Cancel update timers in `dispose()`
2. **State Synchronization**: Keep UI state in sync with actual playback state
3. **Error Recovery**: Provide user feedback and recovery options
4. **Performance**: Limit timer frequency to avoid excessive updates
5. **File Paths**: Use app-specific directories for recordings