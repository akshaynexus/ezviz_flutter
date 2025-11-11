# Multi-Region Global SDK Example

This example demonstrates how to use EZVIZ's global SDK deployment across different regions.

## Features Demonstrated

- Loading available global regions/areas
- Area selection dialog for user choice
- Regional login authentication
- Multi-region SDK initialization

## Usage

Import the necessary packages:

```dart
import 'package:ezviz_flutter/ezviz_flutter.dart';
```

## Complete Example

```dart
class GlobalSDKExample extends StatefulWidget {
  @override
  _GlobalSDKExampleState createState() => _GlobalSDKExampleState();
}

class _GlobalSDKExampleState extends State<GlobalSDKExample> {
  List<EzvizAreaInfo> areas = [];
  String? selectedAreaId;
  String status = 'Loading areas...';

  @override
  void initState() {
    super.initState();
    _loadAvailableAreas();
  }

  Future<void> _loadAvailableAreas() async {
    try {
      areas = await EzvizAuthManager.getAreaList();
      setState(() {
        status = 'Loaded ${areas.length} available regions';
      });
    } catch (e) {
      setState(() {
        status = 'Error loading areas: $e';
      });
    }
  }

  Future<void> _loginToArea(String areaId) async {
    setState(() {
      status = 'Logging in to selected region...';
    });

    try {
      final success = await EzvizAuthManager.openLoginPage(areaId: areaId);
      
      if (success) {
        setState(() {
          selectedAreaId = areaId;
          status = 'Login successful for region: $areaId';
        });
        
        // Initialize global SDK for the selected area
        await EzvizAuthManager.initGlobalSDK(areaId: areaId);
      } else {
        setState(() {
          status = 'Login failed for region: $areaId';
        });
      }
    } catch (e) {
      setState(() {
        status = 'Error during login: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Global SDK Regions'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Status Section
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16),
            color: Colors.grey[100],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Status: $status',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                if (selectedAreaId != null) ...[
                  SizedBox(height: 8),
                  Text(
                    'Current Region: $selectedAreaId',
                    style: TextStyle(color: Colors.green),
                  ),
                ],
              ],
            ),
          ),

          // Areas List
          Expanded(
            child: areas.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text('Loading available regions...'),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: areas.length,
                    itemBuilder: (context, index) {
                      final area = areas[index];
                      final isSelected = selectedAreaId == area.areaId;
                      
                      return Card(
                        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        child: ListTile(
                          leading: Icon(
                            Icons.public,
                            color: isSelected ? Colors.green : Colors.grey,
                          ),
                          title: Text(
                            area.areaName,
                            style: TextStyle(
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              color: isSelected ? Colors.green : null,
                            ),
                          ),
                          subtitle: Text('Region ID: ${area.areaId}'),
                          trailing: isSelected
                              ? Icon(Icons.check_circle, color: Colors.green)
                              : Icon(Icons.arrow_forward_ios, size: 16),
                          onTap: () => _loginToArea(area.areaId),
                        ),
                      );
                    },
                  ),
          ),

          // Action Buttons
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _loadAvailableAreas,
                    icon: Icon(Icons.refresh),
                    label: Text('Refresh Regions'),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: selectedAreaId != null ? _logout : null,
                    icon: Icon(Icons.logout),
                    label: Text('Logout'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _logout() async {
    try {
      await EzvizAuthManager.logout();
      setState(() {
        selectedAreaId = null;
        status = 'Logged out successfully';
      });
    } catch (e) {
      setState(() {
        status = 'Logout error: $e';
      });
    }
  }
}
```

## Simplified Usage Example

For a simple region selection dialog:

```dart
class SimpleRegionSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<EzvizAreaInfo>>(
      future: EzvizAuthManager.getAreaList(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        
        if (snapshot.hasError) {
          return Center(
            child: Text('Error loading regions: ${snapshot.error}'),
          );
        }
        
        if (snapshot.hasData) {
          final areas = snapshot.data!;
          return ListView.builder(
            itemCount: areas.length,
            itemBuilder: (context, index) {
              final area = areas[index];
              return ListTile(
                title: Text(area.areaName),
                subtitle: Text('ID: ${area.areaId}'),
                onTap: () => _loginToArea(area.areaId),
              );
            },
          );
        }
        
        return Center(child: Text('No regions available'));
      },
    );
  }

  Future<void> _loginToArea(String areaId) async {
    await EzvizAuthManager.openLoginPage(areaId: areaId);
  }
}
```

## Key Concepts

### Area Information
Each `EzvizAreaInfo` contains:
- `areaId`: Unique identifier for the region
- `areaName`: Human-readable region name

### Global SDK Initialization
After successful login to a region, initialize the global SDK:
```dart
await EzvizAuthManager.initGlobalSDK(areaId: selectedAreaId);
```

### Region Selection Best Practices

1. **Always load areas first**: Call `getAreaList()` before showing login options
2. **Handle empty areas**: Some deployments may not have multiple regions
3. **Store selection**: Remember user's preferred region for future sessions
4. **Error handling**: Provide fallback for network or authentication errors

### Common Regional Deployments

- **China**: Mainland China deployment
- **Europe**: European Union deployment
- **Americas**: North/South America deployment
- **Asia-Pacific**: APAC regional deployment

## Integration Tips

### Auto-Region Detection
You can implement automatic region detection based on user's location or previous selections:

```dart
Future<String?> _detectBestRegion() async {
  final areas = await EzvizAuthManager.getAreaList();
  
  // Implement logic to detect best region based on:
  // - User's current location
  // - Previous successful login region
  // - Network latency testing
  
  return areas.first.areaId; // Fallback to first available
}
```

### Region Persistence
Store the selected region for future app launches:

```dart
// Save selected region
await SharedPreferences.getInstance().then((prefs) {
  prefs.setString('selected_region', areaId);
});

// Load saved region on app start
final prefs = await SharedPreferences.getInstance();
final savedRegion = prefs.getString('selected_region');
```