import 'package:flutter/material.dart';
import 'package:ezviz_flutter/ezviz_flutter.dart';

/// Comprehensive example showcasing all EZVIZ SDK native functionality
class ComprehensiveSDKExample extends StatefulWidget {
  const ComprehensiveSDKExample({super.key});

  @override
  State<ComprehensiveSDKExample> createState() => _ComprehensiveSDKExampleState();
}

class _ComprehensiveSDKExampleState extends State<ComprehensiveSDKExample> {
  List<EzvizDeviceInfo> _devices = [];
  List<EzvizAreaInfo> _areas = [];
  EzvizAccessToken? _accessToken;
  String _status = 'Ready';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    setState(() {
      _isLoading = true;
      _status = 'Loading initial data...';
    });

    try {
      // Load access token
      _accessToken = await EzvizAuthManager.getAccessToken();
      
      // Load areas for global SDK
      _areas = await EzvizAuthManager.getAreaList();
      
      // Load devices if we have a token
      if (_accessToken != null && !_accessToken!.isExpired) {
        await _loadDevices();
      }
      
      setState(() {
        _status = 'Ready';
      });
    } catch (e) {
      setState(() {
        _status = 'Error loading data: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadDevices() async {
    setState(() {
      _isLoading = true;
      _status = 'Loading devices...';
    });

    try {
      _devices = await EzvizDeviceManager.getDeviceList(
        pageStart: 0,
        pageSize: 20,
      );
      
      setState(() {
        _status = 'Loaded ${_devices.length} devices';
      });
    } catch (e) {
      setState(() {
        _status = 'Error loading devices: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _openLoginPage() async {
    setState(() {
      _status = 'Opening login page...';
    });

    try {
      String? selectedAreaId;
      
      // If we have areas, let user select one
      if (_areas.isNotEmpty) {
        selectedAreaId = await _showAreaSelectionDialog();
        if (selectedAreaId == null) return; // User cancelled
      }

      final success = await EzvizAuthManager.openLoginPage(
        areaId: selectedAreaId,
      );

      if (success) {
        setState(() {
          _status = 'Login page opened. Complete login and return to app.';
        });
      } else {
        setState(() {
          _status = 'Failed to open login page';
        });
      }
    } catch (e) {
      setState(() {
        _status = 'Error opening login page: $e';
      });
    }
  }

  Future<String?> _showAreaSelectionDialog() async {
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Area'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: _areas.length,
            itemBuilder: (context, index) {
              final area = _areas[index];
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
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  Future<void> _addDevice() async {
    final deviceSerial = await _showInputDialog(
      title: 'Add Device',
      hint: 'Enter device serial number',
    );

    if (deviceSerial == null || deviceSerial.isEmpty) return;

    setState(() {
      _status = 'Adding device...';
    });

    try {
      // First probe the device
      final probeInfo = await EzvizDeviceManager.probeDeviceInfo(deviceSerial);
      
      if (probeInfo != null) {
        // Device found, try to add it
        String? verifyCode;
        
        // If device requires verification, ask for it
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
          setState(() {
            _status = 'Device added successfully';
          });
          await _loadDevices(); // Refresh device list
        } else {
          setState(() {
            _status = 'Failed to add device';
          });
        }
      } else {
        setState(() {
          _status = 'Device not found or not available';
        });
      }
    } catch (e) {
      setState(() {
        _status = 'Error adding device: $e';
      });
    }
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
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(controller.text),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _searchRecordFiles(EzvizDeviceInfo device) async {
    setState(() {
      _status = 'Searching record files...';
    });

    try {
      final now = DateTime.now();
      final yesterday = now.subtract(const Duration(days: 1));

      final recordFiles = await EzvizDeviceManager.searchCloudRecordFiles(
        deviceSerial: device.deviceSerial,
        cameraNo: 1,
        startTime: yesterday.millisecondsSinceEpoch,
        endTime: now.millisecondsSinceEpoch,
        recType: RecordingType.all.value,
      );

      setState(() {
        _status = 'Found ${recordFiles.length} record files';
      });

      if (recordFiles.isNotEmpty) {
        _showRecordFilesDialog(recordFiles);
      }
    } catch (e) {
      setState(() {
        _status = 'Error searching record files: $e';
      });
    }
  }

  void _showRecordFilesDialog(List<EzvizCloudRecordFile> files) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Record Files'),
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
            child: const Text('Close'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comprehensive EZVIZ SDK'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Status Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Status: $_status',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  if (_isLoading)
                    const Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: LinearProgressIndicator(),
                    ),
                  if (_accessToken != null) ...[
                    const SizedBox(height: 8),
                    Text('Access Token: Valid'),
                    Text('Expires in: ${_accessToken!.remainingMinutes} minutes'),
                  ],
                  Text('Areas Available: ${_areas.length}'),
                  Text('Devices: ${_devices.length}'),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Authentication Section
            const Text(
              'Authentication',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _openLoginPage,
                    icon: const Icon(Icons.login),
                    label: const Text('Login'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      await EzvizAuthManager.logout();
                      setState(() {
                        _accessToken = null;
                        _devices.clear();
                        _status = 'Logged out';
                      });
                    },
                    icon: const Icon(Icons.logout),
                    label: const Text('Logout'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Device Management Section
            const Text(
              'Device Management',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _loadDevices,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Refresh'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _addDevice,
                    icon: const Icon(Icons.add),
                    label: const Text('Add Device'),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Devices List
            const Text(
              'Devices',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: _devices.isEmpty
                  ? const Center(
                      child: Text('No devices found\nTry logging in first'),
                    )
                  : ListView.builder(
                      itemCount: _devices.length,
                      itemBuilder: (context, index) {
                        final device = _devices[index];
                        return Card(
                          child: ListTile(
                            leading: Icon(
                              device.isSupportPTZ
                                  ? Icons.videocam
                                  : Icons.camera_alt,
                              // Status is not available on EzvizDeviceInfo; use theme color
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            title: Text(device.deviceName),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Serial: ${device.deviceSerial}'),
                                Text('PTZ: ${device.isSupportPTZ ? "Yes" : "No"}'),
                                Text('Cameras: ${device.cameraNum}'),
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
                                const PopupMenuItem(
                                  value: 'records',
                                  child: Text('Search Records'),
                                ),
                                const PopupMenuItem(
                                  value: 'delete',
                                  child: Text('Delete Device'),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _deleteDevice(EzvizDeviceInfo device) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Device'),
        content: Text('Are you sure you want to delete ${device.deviceName}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() {
        _status = 'Deleting device...';
      });

      try {
        final success = await EzvizDeviceManager.deleteDevice(device.deviceSerial);
        if (success) {
          setState(() {
            _status = 'Device deleted successfully';
          });
          await _loadDevices(); // Refresh device list
        } else {
          setState(() {
            _status = 'Failed to delete device';
          });
        }
      } catch (e) {
        setState(() {
          _status = 'Error deleting device: $e';
        });
      }
    }
  }
}
