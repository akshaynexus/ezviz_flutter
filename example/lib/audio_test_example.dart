import 'package:flutter/material.dart';
import 'package:ezviz_flutter/ezviz_flutter.dart';

/// Example demonstrating EzvizAudio functionality
class AudioTestExample extends StatefulWidget {
  const AudioTestExample({super.key});

  @override
  State<AudioTestExample> createState() => _AudioTestExampleState();
}

class _AudioTestExampleState extends State<AudioTestExample> {
  bool _isVoiceTalkActive = false;
  String _status = 'Ready';

  /// Test openSound functionality
  Future<void> _testOpenSound() async {
    setState(() {
      _status = 'Opening sound...';
    });

    try {
      final result = await EzvizAudio.openSound();
      setState(() {
        _status = result ? 'Sound opened successfully' : 'Failed to open sound';
      });
    } catch (e) {
      setState(() {
        _status = 'Error opening sound: $e';
      });
    }
  }

  /// Test closeSound functionality
  Future<void> _testCloseSound() async {
    setState(() {
      _status = 'Closing sound...';
    });

    try {
      final result = await EzvizAudio.closeSound();
      setState(() {
        _status = result ? 'Sound closed successfully' : 'Failed to close sound';
      });
    } catch (e) {
      setState(() {
        _status = 'Error closing sound: $e';
      });
    }
  }

  /// Test startVoiceTalk functionality
  Future<void> _testStartVoiceTalk() async {
    setState(() {
      _status = 'Starting voice talk...';
    });

    try {
      final result = await EzvizAudio.startVoiceTalk(
        deviceSerial: 'YOUR_DEVICE_SERIAL', // Replace with actual device serial
        verifyCode: 'YOUR_VERIFY_CODE', // Replace with actual verify code if needed
        cameraNo: 1,
        isPhone2Dev: 1, // Phone speaks, device listens
        supportTalk: 1, // Full duplex
      );
      
      setState(() {
        _isVoiceTalkActive = result;
        _status = result 
          ? 'Voice talk started successfully' 
          : 'Failed to start voice talk';
      });
    } catch (e) {
      setState(() {
        _status = 'Error starting voice talk: $e';
      });
    }
  }

  /// Test stopVoiceTalk functionality
  Future<void> _testStopVoiceTalk() async {
    setState(() {
      _status = 'Stopping voice talk...';
    });

    try {
      final result = await EzvizAudio.stopVoiceTalk();
      setState(() {
        _isVoiceTalkActive = false;
        _status = result 
          ? 'Voice talk stopped successfully' 
          : 'Failed to stop voice talk';
      });
    } catch (e) {
      setState(() {
        _status = 'Error stopping voice talk: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EZVIZ Audio Test'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Status display
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Status:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(_status),
                  const SizedBox(height: 8),
                  Text(
                    'Voice Talk: ${_isVoiceTalkActive ? "Active" : "Inactive"}',
                    style: TextStyle(
                      color: _isVoiceTalkActive ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Sound Controls
            const Text(
              'Sound Controls',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _testOpenSound,
                    icon: const Icon(Icons.volume_up),
                    label: const Text('Open Sound'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _testCloseSound,
                    icon: const Icon(Icons.volume_off),
                    label: const Text('Close Sound'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Voice Talk Controls
            const Text(
              'Voice Talk/Intercom',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            ElevatedButton.icon(
              onPressed: _isVoiceTalkActive ? _testStopVoiceTalk : _testStartVoiceTalk,
              icon: Icon(_isVoiceTalkActive ? Icons.stop : Icons.mic),
              label: Text(_isVoiceTalkActive ? 'Stop Voice Talk' : 'Start Voice Talk'),
              style: ElevatedButton.styleFrom(
                backgroundColor: _isVoiceTalkActive ? Colors.red : Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),

            const SizedBox(height: 24),

            // Instructions
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Instructions:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text('1. Replace YOUR_DEVICE_SERIAL with your actual device serial'),
                  Text('2. Replace YOUR_VERIFY_CODE with your device verification code if needed'),
                  Text('3. Ensure your device supports voice talk functionality'),
                  Text('4. Test sound controls with an active video stream'),
                  Text('5. Voice talk requires proper microphone permissions'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}