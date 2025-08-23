# Comprehensive SDK Integration Example

This example demonstrates full native SDK integration with authentication, device management, and cloud record searching.

## Features Demonstrated

- Authentication with area/region selection
- Device list management with pagination
- Device probing and adding with verification codes
- Cloud recording search and display
- Device deletion
- Global multi-region SDK support

## Usage

Import the necessary packages:

```dart
import 'package:ezviz_flutter/ezviz_flutter.dart';
```

## Complete Example

```dart
class ComprehensiveSDKExample extends StatefulWidget {
  @override
  _ComprehensiveSDKExampleState createState() => _ComprehensiveSDKExampleState();
}

class _ComprehensiveSDKExampleState extends State<ComprehensiveSDKExample> {
  List<EzvizDeviceInfo> devices = [];
  List<EzvizAreaInfo> areas = [];
  EzvizAccessToken? accessToken;
  String status = 'Ready';

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    // Load access token
    accessToken = await EzvizAuthManager.getAccessToken();
    
    // Load available regions/areas for global SDK
    areas = await EzvizAuthManager.getAreaList();
    
    // Load devices if authenticated
    if (accessToken != null && !accessToken!.isExpired) {
      await _loadDevices();
    }
  }

  Future<void> _loadDevices() async {
    devices = await EzvizDeviceManager.getDeviceList(
      pageStart: 0,
      pageSize: 20,
    );
    setState(() {});
  }

  Future<void> _loginWithAreaSelection() async {
    String? selectedAreaId;
    
    // Let user select region/area if available
    if (areas.isNotEmpty) {
      selectedAreaId = await _showAreaSelectionDialog();
    }

    final success = await EzvizAuthManager.openLoginPage(
      areaId: selectedAreaId,
    );
    
    if (success) {
      // Refresh data after login
      await _loadInitialData();
    }
  }

  Future<void> _addNewDevice() async {
    final deviceSerial = await _showInputDialog(
      title: 'Add Device',
      hint: 'Enter device serial number',
    );

    if (deviceSerial != null && deviceSerial.isNotEmpty) {
      // First probe the device to check if it exists
      final probeInfo = await EzvizDeviceManager.probeDeviceInfo(deviceSerial);
      
      if (probeInfo != null) {
        String? verifyCode;
        
        // If device requires verification, prompt for it
        if (probeInfo.status == 20035 || probeInfo.status == 20036) {
          verifyCode = await _showInputDialog(
            title: 'Verification Required',
            hint: 'Enter device verification code',
          );
        }

        final success = await EzvizDeviceManager.addDevice(
          deviceSerial: deviceSerial,
          verifyCode: verifyCode ?? '',
        );

        if (success) {
          await _loadDevices(); // Refresh device list
          setState(() => status = 'Device added successfully');
        }
      }
    }
  }

  Future<void> _searchRecordFiles(EzvizDeviceInfo device) async {
    final now = DateTime.now();
    final yesterday = now.subtract(Duration(days: 1));

    final recordFiles = await EzvizDeviceManager.searchCloudRecordFiles(
      deviceSerial: device.deviceSerial,
      cameraNo: 1,
      startTime: yesterday.millisecondsSinceEpoch,
      endTime: now.millisecondsSinceEpoch,
      recType: RecordingType.all.value,
    );

    _showRecordFilesDialog(recordFiles);
  }

  Future<void> _deleteDevice(EzvizDeviceInfo device) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Device'),
        content: Text('Are you sure you want to delete ${device.deviceName}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Delete'),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() => status = 'Deleting device...');

      try {
        final success = await EzvizDeviceManager.deleteDevice(device.deviceSerial);
        if (success) {
          setState(() => status = 'Device deleted successfully');
          await _loadDevices(); // Refresh device list
        } else {
          setState(() => status = 'Failed to delete device');
        }
      } catch (e) {
        setState(() => status = 'Error deleting device: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Comprehensive EZVIZ SDK'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Status and Authentication Section
          Container(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Status: $status', style: TextStyle(fontWeight: FontWeight.bold)),
                if (accessToken != null) ...[
                  Text('Access Token: Valid'),
                  Text('Expires in: ${accessToken!.remainingMinutes} minutes'),
                ],
                Text('Areas Available: ${areas.length}'),
                Text('Devices: ${devices.length}'),
              ],
            ),
          ),
          
          // Control Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                onPressed: _loginWithAreaSelection,
                icon: Icon(Icons.login),
                label: Text('Login'),
              ),
              ElevatedButton.icon(
                onPressed: _addNewDevice,
                icon: Icon(Icons.add),
                label: Text('Add Device'),
              ),
              ElevatedButton.icon(
                onPressed: _loadDevices,
                icon: Icon(Icons.refresh),
                label: Text('Refresh'),
              ),
            ],
          ),
          
          // Devices List
          Expanded(
            child: ListView.builder(
              itemCount: devices.length,
              itemBuilder: (context, index) {
                final device = devices[index];
                return Card(
                  child: ListTile(
                    leading: Icon(
                      device.isSupportPTZ ? Icons.videocam : Icons.camera_alt,
                      color: device.status == 1 ? Colors.green : Colors.grey,
                    ),
                    title: Text(device.deviceName),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Serial: ${device.deviceSerial}'),
                        Text('Status: ${device.status == 1 ? "Online" : "Offline"}'),
                        if (device.isEncrypt == 1)
                          Text('Encrypted', style: TextStyle(color: Colors.orange)),
                        Text('Cameras: ${device.cameraInfoList?.length ?? 0}'),
                      ],
                    ),
                    trailing: PopupMenuButton<String>(
                      onSelected: (action) {
                        switch (action) {
                          case 'records':
                            _searchRecordFiles(device);
                            break;
                          case 'delete':
                            _deleteDevice(device);
                            break;
                        }
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(value: 'records', child: Text('Search Records')),
                        PopupMenuItem(value: 'delete', child: Text('Delete Device')),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<String?> _showAreaSelectionDialog() async {
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Select Area'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: areas.length,
            itemBuilder: (context, index) {
              final area = areas[index];
              return ListTile(
                title: Text(area.areaName),
                subtitle: Text('ID: ${area.areaId}'),
                onTap: () => Navigator.of(context).pop(area.areaId),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }

  Future<String?> _showInputDialog({
    required String title,
    required String hint,
  }) async {
    final controller = TextEditingController();
    
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(hintText: hint),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(controller.text),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showRecordFilesDialog(List<EzvizCloudRecordFile> files) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Record Files'),
        content: SizedBox(
          width: double.maxFinite,
          height: 400,
          child: ListView.builder(
            itemCount: files.length,
            itemBuilder: (context, index) {
              final file = files[index];
              final startTime = DateTime.fromMillisecondsSinceEpoch(file.startTime);
              final endTime = DateTime.fromMillisecondsSinceEpoch(file.endTime);
              final duration = endTime.difference(startTime);

              return ListTile(
                title: Text(file.fileName),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Start: ${startTime.toString().substring(0, 19)}'),
                    Text('Duration: ${duration.inMinutes} minutes'),
                    Text('Size: ${(file.fileSize / 1024 / 1024).toStringAsFixed(2)} MB'),
                    Text('Type: ${_getRecordTypeString(file.recType)}'),
                  ],
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  // Here you could start playback of this specific file
                },
              );
            },
          ),
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

  String _getRecordTypeString(int recType) {
    switch (recType) {
      case 1: return 'Timing';
      case 2: return 'Alarm';
      case 3: return 'Manual';
      default: return 'Unknown';
    }
  }
}
```

## Key Concepts

### Device Probing
Before adding a device, always probe it first to check availability:
```dart
final probeInfo = await EzvizDeviceManager.probeDeviceInfo(deviceSerial);
```

### Verification Codes
Some devices require verification codes based on status:
- Status 20035: Device requires verification code
- Status 20036: Device requires verification code

### Global SDK Areas
Load available regions for multi-region deployment:
```dart
final areas = await EzvizAuthManager.getAreaList();
```

### Recording Search
Search cloud recordings with time range and type filtering:
```dart
final recordFiles = await EzvizDeviceManager.searchCloudRecordFiles(
  deviceSerial: device.deviceSerial,
  cameraNo: 1,
  startTime: yesterday.millisecondsSinceEpoch,
  endTime: now.millisecondsSinceEpoch,
  recType: RecordingType.all.value,
);
```

## Error Handling

Always wrap SDK calls in try-catch blocks and provide user feedback through the status display.