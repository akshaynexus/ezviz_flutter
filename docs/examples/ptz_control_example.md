# PTZ Control Examples

This document demonstrates Pan-Tilt-Zoom (PTZ) control functionality using both the circular control panel widget and direct API calls.

## Features Demonstrated

- Circular PTZ control panel for intuitive touch control
- Individual PTZ commands (up, down, left, right)
- Zoom in/out controls
- PTZ speed control
- Direct API integration
- Custom PTZ control implementations

## Usage

Import the necessary packages:

```dart
import 'package:ezviz_flutter/ezviz_flutter.dart';
```

## Complete PTZ Control Example

```dart
class PTZControlPage extends StatefulWidget {
  final String deviceSerial;
  final int cameraId;
  
  const PTZControlPage({
    Key? key,
    required this.deviceSerial,
    required this.cameraId,
  }) : super(key: key);

  @override
  _PTZControlPageState createState() => _PTZControlPageState();
}

class _PTZControlPageState extends State<PTZControlPage> {
  String status = 'Ready';
  int currentSpeed = EzvizPtzSpeeds.Normal;
  bool isControlling = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PTZ Control'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Status Display
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Status: $status',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('Device: ${widget.deviceSerial}'),
                  Text('Camera: ${widget.cameraId}'),
                  Text('Speed: ${_getSpeedName(currentSpeed)}'),
                  if (isControlling)
                    Text(
                      '🟢 PTZ Active',
                      style: TextStyle(color: Colors.green),
                    ),
                ],
              ),
            ),

            SizedBox(height: 32),

            // Circular PTZ Control Panel
            PTZControlPanel(
              size: 280,
              backgroundColor: Colors.black.withOpacity(0.3),
              activeColor: Colors.orange,
              borderColor: Colors.white,
              centerIcon: Icon(
                Icons.camera_alt,
                color: Colors.grey[700],
                size: 32,
              ),
              onDirectionStart: (direction) => _startPTZ(direction),
              onDirectionStop: (direction) => _stopPTZ(direction),
              onCenterTap: () => _centerCamera(),
            ),

            SizedBox(height: 32),

            // Speed Control
            _buildSpeedControl(),

            SizedBox(height: 32),

            // Zoom Controls
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildZoomButton(
                  'Zoom In',
                  Icons.zoom_in,
                  EzvizPtzCommands.ZoomIn,
                ),
                _buildZoomButton(
                  'Zoom Out',
                  Icons.zoom_out,
                  EzvizPtzCommands.ZoomOut,
                ),
              ],
            ),

            SizedBox(height: 32),

            // Manual Direction Controls
            _buildManualControls(),

            SizedBox(height: 32),

            // Preset Controls
            _buildPresetControls(),
          ],
        ),
      ),
    );
  }

  Widget _buildSpeedControl() {
    return Column(
      children: [
        Text(
          'PTZ Speed',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildSpeedButton('Slow', EzvizPtzSpeeds.Slow),
            _buildSpeedButton('Normal', EzvizPtzSpeeds.Normal),
            _buildSpeedButton('Fast', EzvizPtzSpeeds.Fast),
          ],
        ),
      ],
    );
  }

  Widget _buildSpeedButton(String label, int speed) {
    final isSelected = currentSpeed == speed;
    return ElevatedButton(
      onPressed: () => _setSpeed(speed),
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.orange : Colors.grey[300],
        foregroundColor: isSelected ? Colors.white : Colors.black,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
      child: Text(label),
    );
  }

  Widget _buildZoomButton(String label, IconData icon, String command) {
    return Column(
      children: [
        GestureDetector(
          onTapDown: (_) => _startPTZCommand(command),
          onTapUp: (_) => _stopPTZCommand(command),
          onTapCancel: () => _stopPTZCommand(command),
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 32,
            ),
          ),
        ),
        SizedBox(height: 8),
        Text(label, style: TextStyle(fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildManualControls() {
    return Column(
      children: [
        Text(
          'Manual Controls',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 16),
        Column(
          children: [
            // Up
            _buildDirectionButton('UP', Icons.keyboard_arrow_up),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Left
                _buildDirectionButton('LEFT', Icons.keyboard_arrow_left),
                SizedBox(width: 80), // Spacer
                // Right
                _buildDirectionButton('RIGHT', Icons.keyboard_arrow_right),
              ],
            ),
            SizedBox(height: 8),
            // Down
            _buildDirectionButton('DOWN', Icons.keyboard_arrow_down),
          ],
        ),
      ],
    );
  }

  Widget _buildDirectionButton(String direction, IconData icon) {
    return GestureDetector(
      onTapDown: (_) => _startPTZ(direction),
      onTapUp: (_) => _stopPTZ(direction),
      onTapCancel: () => _stopPTZ(direction),
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 28),
      ),
    );
  }

  Widget _buildPresetControls() {
    return Column(
      children: [
        Text(
          'Preset Positions',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _buildPresetButton('Home', 1),
            _buildPresetButton('Position 1', 2),
            _buildPresetButton('Position 2', 3),
            _buildPresetButton('Position 3', 4),
          ],
        ),
        SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: _saveCurrentPosition,
              child: Text('Save Position'),
            ),
            ElevatedButton(
              onPressed: _clearPresets,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text('Clear All'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPresetButton(String label, int presetId) {
    return ElevatedButton(
      onPressed: () => _gotoPreset(presetId),
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      child: Text(label),
    );
  }

  // PTZ Control Methods
  Future<void> _startPTZ(String direction) async {
    setState(() {
      isControlling = true;
      status = 'Moving $direction...';
    });

    String command = _getCommandForDirection(direction);
    
    try {
      await EzvizManager.shared().controlPTZ(
        widget.deviceSerial,
        widget.cameraId,
        command,
        EzvizPtzActions.Start,
        currentSpeed,
      );
    } catch (e) {
      setState(() {
        status = 'PTZ control failed: $e';
      });
    }
  }

  Future<void> _stopPTZ(String direction) async {
    setState(() {
      isControlling = false;
      status = 'PTZ stopped';
    });

    String command = _getCommandForDirection(direction);
    
    try {
      await EzvizManager.shared().controlPTZ(
        widget.deviceSerial,
        widget.cameraId,
        command,
        EzvizPtzActions.Stop,
        currentSpeed,
      );
    } catch (e) {
      setState(() {
        status = 'PTZ stop failed: $e';
      });
    }
  }

  Future<void> _startPTZCommand(String command) async {
    setState(() {
      isControlling = true;
      status = 'Executing ${command}...';
    });

    try {
      await EzvizManager.shared().controlPTZ(
        widget.deviceSerial,
        widget.cameraId,
        command,
        EzvizPtzActions.Start,
        currentSpeed,
      );
    } catch (e) {
      setState(() {
        status = 'Command failed: $e';
      });
    }
  }

  Future<void> _stopPTZCommand(String command) async {
    setState(() {
      isControlling = false;
      status = 'Command stopped';
    });

    try {
      await EzvizManager.shared().controlPTZ(
        widget.deviceSerial,
        widget.cameraId,
        command,
        EzvizPtzActions.Stop,
        currentSpeed,
      );
    } catch (e) {
      setState(() {
        status = 'Stop command failed: $e';
      });
    }
  }

  Future<void> _centerCamera() async {
    setState(() {
      status = 'Centering camera...';
    });

    try {
      // Move to center/home position
      await EzvizManager.shared().controlPTZ(
        widget.deviceSerial,
        widget.cameraId,
        EzvizPtzCommands.GotoPreset,
        EzvizPtzActions.Start,
        currentSpeed,
      );
      
      setState(() {
        status = 'Camera centered';
      });
    } catch (e) {
      setState(() {
        status = 'Center failed: $e';
      });
    }
  }

  void _setSpeed(int speed) {
    setState(() {
      currentSpeed = speed;
      status = 'Speed set to ${_getSpeedName(speed)}';
    });
  }

  Future<void> _gotoPreset(int presetId) async {
    setState(() {
      status = 'Moving to preset $presetId...';
    });

    try {
      // Implementation would depend on specific PTZ preset commands
      await EzvizManager.shared().controlPTZ(
        widget.deviceSerial,
        widget.cameraId,
        '${EzvizPtzCommands.GotoPreset}$presetId',
        EzvizPtzActions.Start,
        currentSpeed,
      );
      
      setState(() {
        status = 'Moved to preset $presetId';
      });
    } catch (e) {
      setState(() {
        status = 'Preset movement failed: $e';
      });
    }
  }

  Future<void> _saveCurrentPosition() async {
    setState(() {
      status = 'Saving current position...';
    });

    try {
      // Save current position as preset
      // Implementation would depend on specific PTZ save commands
      setState(() {
        status = 'Position saved successfully';
      });
    } catch (e) {
      setState(() {
        status = 'Save position failed: $e';
      });
    }
  }

  Future<void> _clearPresets() async {
    setState(() {
      status = 'Clearing all presets...';
    });

    try {
      // Clear all preset positions
      // Implementation would depend on specific PTZ clear commands
      setState(() {
        status = 'All presets cleared';
      });
    } catch (e) {
      setState(() {
        status = 'Clear presets failed: $e';
      });
    }
  }

  String _getCommandForDirection(String direction) {
    switch (direction.toUpperCase()) {
      case 'UP':
        return EzvizPtzCommands.Up;
      case 'DOWN':
        return EzvizPtzCommands.Down;
      case 'LEFT':
        return EzvizPtzCommands.Left;
      case 'RIGHT':
        return EzvizPtzCommands.Right;
      default:
        return EzvizPtzCommands.Up;
    }
  }

  String _getSpeedName(int speed) {
    switch (speed) {
      case EzvizPtzSpeeds.Slow:
        return 'Slow';
      case EzvizPtzSpeeds.Normal:
        return 'Normal';
      case EzvizPtzSpeeds.Fast:
        return 'Fast';
      default:
        return 'Unknown';
    }
  }
}
```

## Simple PTZ Control Widget

For basic PTZ functionality:

```dart
class SimplePTZControl extends StatelessWidget {
  final String deviceSerial;
  final int cameraId;

  const SimplePTZControl({
    Key? key,
    required this.deviceSerial,
    required this.cameraId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'PTZ Controls',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            
            // Circular PTZ Panel
            PTZControlPanel(
              size: 200,
              backgroundColor: Colors.grey[300]!,
              activeColor: Colors.blue,
              borderColor: Colors.grey[600]!,
              centerIcon: Icon(Icons.center_focus_strong),
              onDirectionStart: (direction) => _controlPTZ(direction, true),
              onDirectionStop: (direction) => _controlPTZ(direction, false),
              onCenterTap: _centerCamera,
            ),
            
            SizedBox(height: 16),
            
            // Zoom buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _zoom(true),
                  icon: Icon(Icons.zoom_in),
                  label: Text('Zoom In'),
                ),
                ElevatedButton.icon(
                  onPressed: () => _zoom(false),
                  icon: Icon(Icons.zoom_out),
                  label: Text('Zoom Out'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _controlPTZ(String direction, bool start) async {
    final command = _getCommand(direction);
    final action = start ? EzvizPtzActions.Start : EzvizPtzActions.Stop;
    
    try {
      await EzvizManager.shared().controlPTZ(
        deviceSerial,
        cameraId,
        command,
        action,
        EzvizPtzSpeeds.Normal,
      );
    } catch (e) {
      print('PTZ control error: $e');
    }
  }

  Future<void> _zoom(bool zoomIn) async {
    final command = zoomIn ? EzvizPtzCommands.ZoomIn : EzvizPtzCommands.ZoomOut;
    
    try {
      await EzvizManager.shared().controlPTZ(
        deviceSerial,
        cameraId,
        command,
        EzvizPtzActions.Start,
        EzvizPtzSpeeds.Normal,
      );
      
      // Auto-stop after short delay
      await Future.delayed(Duration(milliseconds: 500));
      
      await EzvizManager.shared().controlPTZ(
        deviceSerial,
        cameraId,
        command,
        EzvizPtzActions.Stop,
        EzvizPtzSpeeds.Normal,
      );
    } catch (e) {
      print('Zoom error: $e');
    }
  }

  Future<void> _centerCamera() async {
    // Implement center/home position logic
    print('Centering camera');
  }

  String _getCommand(String direction) {
    switch (direction.toLowerCase()) {
      case 'up':
        return EzvizPtzCommands.Up;
      case 'down':
        return EzvizPtzCommands.Down;
      case 'left':
        return EzvizPtzCommands.Left;
      case 'right':
        return EzvizPtzCommands.Right;
      default:
        return EzvizPtzCommands.Up;
    }
  }
}
```

## PTZ Constants Reference

### Commands
```dart
class EzvizPtzCommands {
  static const String Up = 'UP';
  static const String Down = 'DOWN';
  static const String Left = 'LEFT';
  static const String Right = 'RIGHT';
  static const String ZoomIn = 'ZOOM_IN';
  static const String ZoomOut = 'ZOOM_OUT';
  static const String GotoPreset = 'GOTO_PRESET';
  static const String SetPreset = 'SET_PRESET';
}
```

### Actions
```dart
class EzvizPtzActions {
  static const int Start = 0;
  static const int Stop = 1;
}
```

### Speeds
```dart
class EzvizPtzSpeeds {
  static const int Slow = 1;
  static const int Normal = 3;
  static const int Fast = 5;
}
```

## Custom PTZ Implementation

For advanced custom controls:

```dart
class CustomPTZController {
  final String deviceSerial;
  final int cameraId;
  
  CustomPTZController({
    required this.deviceSerial,
    required this.cameraId,
  });

  Future<bool> moveUp({int speed = EzvizPtzSpeeds.Normal}) async {
    return await _executeCommand(EzvizPtzCommands.Up, speed);
  }

  Future<bool> moveDown({int speed = EzvizPtzSpeeds.Normal}) async {
    return await _executeCommand(EzvizPtzCommands.Down, speed);
  }

  Future<bool> moveLeft({int speed = EzvizPtzSpeeds.Normal}) async {
    return await _executeCommand(EzvizPtzCommands.Left, speed);
  }

  Future<bool> moveRight({int speed = EzvizPtzSpeeds.Normal}) async {
    return await _executeCommand(EzvizPtzCommands.Right, speed);
  }

  Future<bool> zoomIn() async {
    return await _executeCommand(EzvizPtzCommands.ZoomIn, EzvizPtzSpeeds.Normal);
  }

  Future<bool> zoomOut() async {
    return await _executeCommand(EzvizPtzCommands.ZoomOut, EzvizPtzSpeeds.Normal);
  }

  Future<bool> stopMovement() async {
    // Stop all movements
    try {
      await EzvizManager.shared().controlPTZ(
        deviceSerial,
        cameraId,
        EzvizPtzCommands.Up,
        EzvizPtzActions.Stop,
        EzvizPtzSpeeds.Normal,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> _executeCommand(String command, int speed) async {
    try {
      // Start movement
      await EzvizManager.shared().controlPTZ(
        deviceSerial,
        cameraId,
        command,
        EzvizPtzActions.Start,
        speed,
      );
      
      return true;
    } catch (e) {
      print('PTZ command failed: $e');
      return false;
    }
  }
}
```

## Key Concepts

### PTZ Control Flow

1. **Start Command**: Send start action with direction and speed
2. **Continue**: Command continues until stop is sent
3. **Stop Command**: Send stop action to halt movement
4. **Error Handling**: Always handle network/device errors

### Best Practices

1. **Always Stop**: Send stop commands to prevent continuous movement
2. **Speed Control**: Use appropriate speeds for user experience
3. **Error Recovery**: Handle connection failures gracefully
4. **UI Feedback**: Provide visual feedback during movements
5. **Resource Management**: Clean up resources when done

### Gesture Handling

- **onTapDown**: Start PTZ movement
- **onTapUp**: Stop PTZ movement  
- **onTapCancel**: Always stop movement on gesture cancel
- **Long Press**: For continuous movement

### Device Compatibility

Not all cameras support all PTZ features:
- Check device capabilities before showing controls
- Handle unsupported command errors
- Provide fallback UI for non-PTZ cameras