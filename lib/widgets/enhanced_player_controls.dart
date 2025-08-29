import 'package:flutter/material.dart';

/// Enhanced Player Controls with recording, screenshot, and audio features
class EnhancedPlayerControls extends StatefulWidget {
  final bool isPlaying;
  final bool isRecording;
  final bool soundEnabled;
  final bool isFullScreen;
  final Function()? onPlayPause;
  final Function()? onStop;
  final Function()? onRecord;
  final Function()? onScreenshot;
  final Function()? onSoundToggle;
  final Function()? onFullScreenToggle;
  final Function(int quality)? onQualityChange;
  final int currentQuality;

  const EnhancedPlayerControls({
    super.key,
    required this.isPlaying,
    this.isRecording = false,
    this.soundEnabled = false,
    this.isFullScreen = false,
    this.onPlayPause,
    this.onStop,
    this.onRecord,
    this.onScreenshot,
    this.onSoundToggle,
    this.onFullScreenToggle,
    this.onQualityChange,
    this.currentQuality = 2,
  });

  @override
  State<EnhancedPlayerControls> createState() => _EnhancedPlayerControlsState();
}

class _EnhancedPlayerControlsState extends State<EnhancedPlayerControls>
    with TickerProviderStateMixin {
  late AnimationController _recordingController;
  bool _controlsVisible = true;

  @override
  void initState() {
    super.initState();
    _recordingController = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );

    if (widget.isRecording) {
      _recordingController.repeat();
    }
  }

  @override
  void didUpdateWidget(EnhancedPlayerControls oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isRecording != oldWidget.isRecording) {
      if (widget.isRecording) {
        _recordingController.repeat();
      } else {
        _recordingController.stop();
      }
    }
  }

  @override
  void dispose() {
    _recordingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Main content area (tap to toggle controls)
        Positioned.fill(
          child: GestureDetector(
            onTap: _toggleControlsVisibility,
            child: Container(color: Colors.transparent),
          ),
        ),

        // Controls overlay
        if (_controlsVisible) ...[
          // Top controls bar
          Positioned(top: 0, left: 0, right: 0, child: _buildTopControls()),

          // Center play/pause button
          if (!widget.isPlaying) Center(child: _buildCenterPlayButton()),

          // Bottom controls bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildBottomControls(),
          ),
        ],
      ],
    );
  }

  Widget _buildTopControls() {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.black.withValues(alpha: 0.7), Colors.transparent],
        ),
      ),
      child: Row(
        children: [
          // Quality selector
          _buildQualitySelector(),
          Spacer(),
          // Recording indicator
          if (widget.isRecording)
            AnimatedBuilder(
              animation: _recordingController,
              builder: (context, child) {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(
                      alpha: 0.5 + 0.5 * _recordingController.value,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 6),
                      Text(
                        'REC',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          // Full screen button
          IconButton(
            icon: Icon(
              widget.isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen,
              color: Colors.white,
            ),
            onPressed: widget.onFullScreenToggle,
          ),
        ],
      ),
    );
  }

  Widget _buildCenterPlayButton() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.7),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(Icons.play_arrow, color: Colors.white, size: 40),
        onPressed: widget.onPlayPause,
      ),
    );
  }

  Widget _buildBottomControls() {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [Colors.black.withValues(alpha: 0.7), Colors.transparent],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Play/Pause button
          IconButton(
            icon: Icon(
              widget.isPlaying ? Icons.pause : Icons.play_arrow,
              color: Colors.white,
              size: 28,
            ),
            onPressed: widget.onPlayPause,
          ),

          // Stop button
          IconButton(
            icon: Icon(Icons.stop, color: Colors.white, size: 28),
            onPressed: widget.onStop,
          ),

          // Record button
          IconButton(
            icon: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: widget.isRecording ? Colors.red : Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: widget.isRecording
                  ? Container(
                      margin: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.rectangle,
                      ),
                    )
                  : Container(
                      margin: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
            ),
            onPressed: widget.onRecord,
          ),

          // Screenshot button
          IconButton(
            icon: Icon(Icons.camera_alt, color: Colors.white, size: 28),
            onPressed: widget.onScreenshot,
          ),

          // Sound toggle button
          IconButton(
            icon: Icon(
              widget.soundEnabled ? Icons.volume_up : Icons.volume_off,
              color: Colors.white,
              size: 28,
            ),
            onPressed: widget.onSoundToggle,
          ),
        ],
      ),
    );
  }

  Widget _buildQualitySelector() {
    final qualities = [
      {'value': 0, 'label': 'Smooth'},
      {'value': 1, 'label': 'Balanced'},
      {'value': 2, 'label': 'HD'},
      {'value': 3, 'label': 'UHD'},
    ];

    return PopupMenuButton<int>(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.hd, color: Colors.white, size: 16),
            SizedBox(width: 4),
            Text(
              qualities[widget.currentQuality]['label'] as String,
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
            Icon(Icons.arrow_drop_down, color: Colors.white, size: 16),
          ],
        ),
      ),
      onSelected: (quality) {
        if (widget.onQualityChange != null) {
          widget.onQualityChange!(quality);
        }
      },
      itemBuilder: (context) => qualities.map((quality) {
        return PopupMenuItem<int>(
          value: quality['value'] as int,
          child: Row(
            children: [
              if (quality['value'] == widget.currentQuality)
                Icon(Icons.check, color: Colors.blue, size: 16)
              else
                SizedBox(width: 16),
              SizedBox(width: 8),
              Text(quality['label'] as String),
            ],
          ),
        );
      }).toList(),
    );
  }

  void _toggleControlsVisibility() {
    setState(() {
      _controlsVisible = !_controlsVisible;
    });

    // Auto-hide controls after 3 seconds
    if (_controlsVisible) {
      Future.delayed(Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            _controlsVisible = false;
          });
        }
      });
    }
  }
}
