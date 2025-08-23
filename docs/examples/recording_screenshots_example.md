# Recording & Screenshots Examples

This document demonstrates recording video and capturing screenshots from EZVIZ camera streams.

## Features Demonstrated

- Start/stop video recording
- Screenshot capture from live stream
- Recording status monitoring
- File management utilities
- Custom recording controls

## Usage

Import the necessary packages:

```dart
import 'package:ezviz_flutter/ezviz_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
```

## Complete Recording Manager Example

```dart
class RecordingManager extends StatefulWidget {
  final EzvizPlayerController controller;
  final String deviceSerial;
  
  const RecordingManager({
    Key? key,
    required this.controller,
    required this.deviceSerial,
  }) : super(key: key);

  @override
  _RecordingManagerState createState() => _RecordingManagerState();
}

class _RecordingManagerState extends State<RecordingManager> {
  bool isRecording = false;
  String status = 'Ready';
  List<String> recordedFiles = [];
  List<String> screenshots = [];
  String? currentRecordingPath;
  DateTime? recordingStartTime;
  
  @override
  void initState() {
    super.initState();
    _loadExistingFiles();
    _checkRecordingStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recording Manager'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Status Card
          _buildStatusCard(),
          
          // Control Panel
          _buildControlPanel(),
          
          // File Lists
          Expanded(
            child: DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  TabBar(
                    tabs: [
                      Tab(
                        icon: Icon(Icons.videocam),
                        text: 'Recordings (${recordedFiles.length})',
                      ),
                      Tab(
                        icon: Icon(Icons.photo_camera),
                        text: 'Screenshots (${screenshots.length})',
                      ),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        _buildRecordingsList(),
                        _buildScreenshotsList(),
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

  Widget _buildStatusCard() {
    return Card(
      color: _getStatusColor(),
      margin: EdgeInsets.all(16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isRecording ? Icons.fiber_manual_record : Icons.stop,
                  color: Colors.white,
                ),
                SizedBox(width: 8),
                Text(
                  isRecording ? 'Recording Active' : 'Recording Stopped',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              'Status: $status',
              style: TextStyle(color: Colors.white),
            ),
            if (isRecording && recordingStartTime != null) ...[
              SizedBox(height: 4),
              Text(
                'Duration: ${_getRecordingDuration()}',
                style: TextStyle(color: Colors.white),
              ),
              Text(
                'File: ${currentRecordingPath?.split('/').last ?? 'Unknown'}',
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildControlPanel() {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Recording Control
                _buildControlButton(
                  icon: isRecording ? Icons.stop : Icons.fiber_manual_record,
                  label: isRecording ? 'Stop Recording' : 'Start Recording',
                  color: isRecording ? Colors.red : Colors.green,
                  onPressed: isRecording ? _stopRecording : _startRecording,
                ),
                
                // Screenshot Button
                _buildControlButton(
                  icon: Icons.camera_alt,
                  label: 'Screenshot',
                  color: Colors.blue,
                  onPressed: _takeScreenshot,
                ),
              ],
            ),
            
            SizedBox(height: 16),
            
            // Additional Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton.icon(
                  onPressed: _checkRecordingStatus,
                  icon: Icon(Icons.refresh),
                  label: Text('Refresh Status'),
                ),
                TextButton.icon(
                  onPressed: _loadExistingFiles,
                  icon: Icon(Icons.folder),
                  label: Text('Reload Files'),
                ),
                TextButton.icon(
                  onPressed: _clearAllFiles,
                  icon: Icon(Icons.delete_sweep),
                  label: Text('Clear All'),
                  style: TextButton.styleFrom(foregroundColor: Colors.red),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            foregroundColor: Colors.white,
            padding: EdgeInsets.all(20),
            shape: CircleBorder(),
          ),
          child: Icon(icon, size: 32),
        ),
        SizedBox(height: 8),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildRecordingsList() {
    if (recordedFiles.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.videocam_off, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No recordings found',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            SizedBox(height: 8),
            Text('Start recording to create files'),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: recordedFiles.length,
      itemBuilder: (context, index) {
        final file = recordedFiles[index];
        final fileName = file.split('/').last;
        
        return Card(
          child: ListTile(
            leading: Icon(Icons.movie, color: Colors.red),
            title: Text(fileName),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Path: $file'),
                Text('Size: ${_getFileSize(file)}'),
                Text('Created: ${_getFileDate(file)}'),
              ],
            ),
            trailing: PopupMenuButton<String>(
              onSelected: (action) => _handleFileAction(action, file),
              itemBuilder: (context) => [
                PopupMenuItem(value: 'play', child: Text('Play')),
                PopupMenuItem(value: 'share', child: Text('Share')),
                PopupMenuItem(value: 'delete', child: Text('Delete')),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildScreenshotsList() {
    if (screenshots.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.photo_camera_back, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No screenshots found',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            SizedBox(height: 8),
            Text('Take screenshots to create files'),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.0,
      ),
      itemCount: screenshots.length,
      itemBuilder: (context, index) {
        final file = screenshots[index];
        final fileName = file.split('/').last;
        
        return Card(
          child: InkWell(
            onTap: () => _viewScreenshot(file),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
                    ),
                    child: File(file).existsSync()
                        ? Image.file(
                            File(file),
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(Icons.broken_image, size: 48);
                            },
                          )
                        : Icon(Icons.image, size: 48),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        fileName,
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        _getFileDate(file),
                        style: TextStyle(fontSize: 10, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Recording Methods
  Future<void> _startRecording() async {
    setState(() {
      status = 'Starting recording...';
    });

    try {
      // Generate unique file path
      final directory = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final filePath = '${directory.path}/ezviz_recording_$timestamp.mp4';

      final success = await EzvizRecording.startRecording(
        filePath: filePath,
      );

      if (success) {
        setState(() {
          isRecording = true;
          currentRecordingPath = filePath;
          recordingStartTime = DateTime.now();
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
      final success = await EzvizRecording.stopRecording();
      
      if (success) {
        if (currentRecordingPath != null) {
          recordedFiles.add(currentRecordingPath!);
        }
        
        setState(() {
          isRecording = false;
          currentRecordingPath = null;
          recordingStartTime = null;
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
      final imagePath = await EzvizRecording.capturePicture();
      
      if (imagePath != null) {
        screenshots.add(imagePath);
        setState(() {
          status = 'Screenshot saved: ${imagePath.split('/').last}';
        });
        
        _showSnackbar('Screenshot saved successfully', Colors.green);
      } else {
        setState(() {
          status = 'Screenshot failed';
        });
        _showSnackbar('Screenshot failed', Colors.red);
      }
    } catch (e) {
      setState(() {
        status = 'Screenshot error: $e';
      });
      _showSnackbar('Screenshot error: $e', Colors.red);
    }
  }

  Future<void> _checkRecordingStatus() async {
    try {
      final recording = await EzvizRecording.isRecording();
      setState(() {
        isRecording = recording;
        status = recording ? 'Recording active' : 'Recording inactive';
      });
    } catch (e) {
      setState(() {
        status = 'Status check error: $e';
      });
    }
  }

  // File Management Methods
  Future<void> _loadExistingFiles() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final dir = Directory(directory.path);
      
      if (await dir.exists()) {
        final files = await dir.list().toList();
        
        recordedFiles.clear();
        screenshots.clear();
        
        for (final file in files) {
          if (file is File) {
            final path = file.path;
            if (path.endsWith('.mp4') || path.endsWith('.mov')) {
              recordedFiles.add(path);
            } else if (path.endsWith('.jpg') || path.endsWith('.png')) {
              screenshots.add(path);
            }
          }
        }
        
        setState(() {
          status = 'Files loaded: ${recordedFiles.length + screenshots.length} total';
        });
      }
    } catch (e) {
      setState(() {
        status = 'File loading error: $e';
      });
    }
  }

  Future<void> _clearAllFiles() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Clear All Files'),
        content: Text('Are you sure you want to delete all recordings and screenshots?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('Delete All'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        for (final filePath in [...recordedFiles, ...screenshots]) {
          final file = File(filePath);
          if (await file.exists()) {
            await file.delete();
          }
        }
        
        recordedFiles.clear();
        screenshots.clear();
        
        setState(() {
          status = 'All files deleted';
        });
      } catch (e) {
        setState(() {
          status = 'Delete error: $e';
        });
      }
    }
  }

  void _handleFileAction(String action, String filePath) {
    switch (action) {
      case 'play':
        _playFile(filePath);
        break;
      case 'share':
        _shareFile(filePath);
        break;
      case 'delete':
        _deleteFile(filePath);
        break;
    }
  }

  void _playFile(String filePath) {
    // Implement file playback
    _showSnackbar('Playing: ${filePath.split('/').last}', Colors.blue);
  }

  void _shareFile(String filePath) {
    // Implement file sharing
    _showSnackbar('Sharing: ${filePath.split('/').last}', Colors.blue);
  }

  Future<void> _deleteFile(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
        recordedFiles.remove(filePath);
        screenshots.remove(filePath);
        setState(() {
          status = 'File deleted: ${filePath.split('/').last}';
        });
      }
    } catch (e) {
      _showSnackbar('Delete error: $e', Colors.red);
    }
  }

  void _viewScreenshot(String filePath) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: Text(filePath.split('/').last),
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
          ),
          backgroundColor: Colors.black,
          body: Center(
            child: Image.file(File(filePath)),
          ),
        ),
      ),
    );
  }

  // Utility Methods
  Color _getStatusColor() {
    if (isRecording) return Colors.red;
    if (status.contains('error') || status.contains('failed')) return Colors.red;
    if (status.contains('success') || status.contains('saved')) return Colors.green;
    return Colors.blue;
  }

  String _getRecordingDuration() {
    if (recordingStartTime == null) return '00:00';
    final duration = DateTime.now().difference(recordingStartTime!);
    final minutes = duration.inMinutes.toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  String _getFileSize(String filePath) {
    try {
      final file = File(filePath);
      if (file.existsSync()) {
        final bytes = file.lengthSync();
        if (bytes < 1024) return '${bytes}B';
        if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)}KB';
        return '${(bytes / (1024 * 1024)).toStringAsFixed(1)}MB';
      }
    } catch (e) {
      // Handle error silently
    }
    return 'Unknown';
  }

  String _getFileDate(String filePath) {
    try {
      final file = File(filePath);
      if (file.existsSync()) {
        final stat = file.statSync();
        final date = stat.modified;
        return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}';
      }
    } catch (e) {
      // Handle error silently
    }
    return 'Unknown';
  }

  void _showSnackbar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: Duration(seconds: 2),
      ),
    );
  }
}
```

## Simple Recording Controls Widget

```dart
class SimpleRecordingControls extends StatefulWidget {
  final EzvizPlayerController controller;
  
  const SimpleRecordingControls({Key? key, required this.controller}) : super(key: key);

  @override
  _SimpleRecordingControlsState createState() => _SimpleRecordingControlsState();
}

class _SimpleRecordingControlsState extends State<SimpleRecordingControls> {
  bool isRecording = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton.icon(
          onPressed: _toggleRecording,
          icon: Icon(isRecording ? Icons.stop : Icons.fiber_manual_record),
          label: Text(isRecording ? 'Stop' : 'Record'),
          style: ElevatedButton.styleFrom(
            backgroundColor: isRecording ? Colors.red : Colors.green,
            foregroundColor: Colors.white,
          ),
        ),
        ElevatedButton.icon(
          onPressed: _takeScreenshot,
          icon: Icon(Icons.camera_alt),
          label: Text('Screenshot'),
        ),
      ],
    );
  }

  Future<void> _toggleRecording() async {
    if (isRecording) {
      await _stopRecording();
    } else {
      await _startRecording();
    }
  }

  Future<void> _startRecording() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final filePath = '${directory.path}/recording_$timestamp.mp4';
      
      final success = await EzvizRecording.startRecording(filePath: filePath);
      if (success) {
        setState(() => isRecording = true);
      }
    } catch (e) {
      print('Recording start error: $e');
    }
  }

  Future<void> _stopRecording() async {
    try {
      final success = await EzvizRecording.stopRecording();
      if (success) {
        setState(() => isRecording = false);
      }
    } catch (e) {
      print('Recording stop error: $e');
    }
  }

  Future<void> _takeScreenshot() async {
    try {
      final imagePath = await EzvizRecording.capturePicture();
      if (imagePath != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Screenshot saved: ${imagePath.split('/').last}')),
        );
      }
    } catch (e) {
      print('Screenshot error: $e');
    }
  }
}
```

## Key Concepts

### Recording Management

1. **Start Recording**: Generate unique file path and start recording
2. **Stop Recording**: Stop recording and save file
3. **Status Monitoring**: Check if recording is currently active
4. **File Management**: Organize and manage recorded files

### Screenshot Capture

- Capture current frame from video stream
- Save as image file (JPG/PNG)
- Handle file path management
- Display thumbnails in grid view

### File Organization

- Separate recordings and screenshots
- Use timestamp-based file naming
- Provide file size and date information
- Support file actions (play, share, delete)

### Error Handling

Always handle potential errors:
- Storage permission issues
- Disk space problems
- File system errors
- Recording state conflicts

### Best Practices

1. **Unique File Names**: Use timestamps to avoid conflicts
2. **Storage Management**: Monitor available disk space
3. **Cleanup**: Provide options to delete old files
4. **User Feedback**: Show recording status and progress
5. **Permission Handling**: Request storage permissions appropriately