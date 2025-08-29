import 'package:flutter/material.dart';
import 'dart:math' as math;

/// PTZ Control Panel Widget
/// A circular touch control panel for intuitive camera movement
class PTZControlPanel extends StatefulWidget {
  final Function(String direction)? onDirectionStart;
  final Function(String direction)? onDirectionStop;
  final Function()? onCenterTap;
  final double size;
  final Color backgroundColor;
  final Color activeColor;
  final Color borderColor;
  final Widget? centerIcon;

  const PTZControlPanel({
    super.key,
    this.onDirectionStart,
    this.onDirectionStop,
    this.onCenterTap,
    this.size = 200,
    this.backgroundColor = Colors.black26,
    this.activeColor = Colors.blue,
    this.borderColor = Colors.white,
    this.centerIcon,
  });

  @override
  State<PTZControlPanel> createState() => _PTZControlPanelState();
}

class _PTZControlPanelState extends State<PTZControlPanel> {
  Offset? touchPosition;
  String? activeDirection;
  double get outerRadius => widget.size / 2;
  double get innerRadius => widget.size / 6;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.size,
      height: widget.size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer control ring
          GestureDetector(
            onPanStart: _onPanStart,
            onPanUpdate: _onPanUpdate,
            onPanEnd: _onPanEnd,
            onTapUp: _onTapUp,
            child: CustomPaint(
              size: Size(widget.size, widget.size),
              painter: _PTZPanelPainter(
                outerRadius: outerRadius,
                innerRadius: innerRadius,
                backgroundColor: widget.backgroundColor,
                activeColor: widget.activeColor,
                borderColor: widget.borderColor,
                touchPosition: touchPosition,
                activeDirection: activeDirection,
              ),
            ),
          ),
          // Center button
          GestureDetector(
            onTap: widget.onCenterTap,
            child: Container(
              width: innerRadius * 2,
              height: innerRadius * 2,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.9),
                shape: BoxShape.circle,
                border: Border.all(color: widget.borderColor, width: 2),
              ),
              child:
                  widget.centerIcon ??
                  Icon(
                    Icons.center_focus_strong,
                    color: Colors.grey[700],
                    size: innerRadius,
                  ),
            ),
          ),
          // Direction indicators
          ..._buildDirectionIndicators(),
        ],
      ),
    );
  }

  List<Widget> _buildDirectionIndicators() {
    final indicators = <Widget>[];
    final directions = ['UP', 'RIGHT', 'DOWN', 'LEFT'];
    final icons = [
      Icons.keyboard_arrow_up,
      Icons.keyboard_arrow_right,
      Icons.keyboard_arrow_down,
      Icons.keyboard_arrow_left,
    ];
    final positions = [
      Offset(0, -outerRadius + 20), // Top
      Offset(outerRadius - 20, 0), // Right
      Offset(0, outerRadius - 20), // Bottom
      Offset(-outerRadius + 20, 0), // Left
    ];

    for (int i = 0; i < directions.length; i++) {
      indicators.add(
        Positioned(
          left: outerRadius + positions[i].dx - 15,
          top: outerRadius + positions[i].dy - 15,
          child: Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: activeDirection == directions[i]
                  ? widget.activeColor
                  : Colors.white.withValues(alpha: 0.8),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icons[i],
              color: activeDirection == directions[i]
                  ? Colors.white
                  : Colors.grey[700],
              size: 18,
            ),
          ),
        ),
      );
    }

    return indicators;
  }

  void _onPanStart(DragStartDetails details) {
    _updateTouchPosition(details.localPosition);
  }

  void _onPanUpdate(DragUpdateDetails details) {
    _updateTouchPosition(details.localPosition);
  }

  void _onPanEnd(DragEndDetails details) {
    if (activeDirection != null && widget.onDirectionStop != null) {
      widget.onDirectionStop!(activeDirection!);
    }
    setState(() {
      touchPosition = null;
      activeDirection = null;
    });
  }

  void _onTapUp(TapUpDetails details) {
    _updateTouchPosition(details.localPosition);

    // Brief delay to show the direction, then stop
    Future.delayed(Duration(milliseconds: 100), () {
      if (activeDirection != null && widget.onDirectionStop != null) {
        widget.onDirectionStop!(activeDirection!);
      }
      setState(() {
        touchPosition = null;
        activeDirection = null;
      });
    });
  }

  void _updateTouchPosition(Offset position) {
    final center = Offset(outerRadius, outerRadius);
    final distance = (position - center).distance;

    // Only respond to touches in the control ring area
    if (distance > innerRadius && distance <= outerRadius) {
      final direction = _getDirection(position, center);

      if (direction != activeDirection) {
        // Stop previous direction
        if (activeDirection != null && widget.onDirectionStop != null) {
          widget.onDirectionStop!(activeDirection!);
        }

        // Start new direction
        if (widget.onDirectionStart != null) {
          widget.onDirectionStart!(direction);
        }

        setState(() {
          touchPosition = position;
          activeDirection = direction;
        });
      }
    }
  }

  String _getDirection(Offset position, Offset center) {
    final angle = math.atan2(position.dy - center.dy, position.dx - center.dx);
    final degrees = (angle * 180 / math.pi + 360) % 360;

    // Divide circle into 4 quadrants
    if (degrees >= 315 || degrees < 45) {
      return 'RIGHT';
    } else if (degrees >= 45 && degrees < 135) {
      return 'DOWN';
    } else if (degrees >= 135 && degrees < 225) {
      return 'LEFT';
    } else {
      return 'UP';
    }
  }
}

class _PTZPanelPainter extends CustomPainter {
  final double outerRadius;
  final double innerRadius;
  final Color backgroundColor;
  final Color activeColor;
  final Color borderColor;
  final Offset? touchPosition;
  final String? activeDirection;

  _PTZPanelPainter({
    required this.outerRadius,
    required this.innerRadius,
    required this.backgroundColor,
    required this.activeColor,
    required this.borderColor,
    this.touchPosition,
    this.activeDirection,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()..style = PaintingStyle.fill;

    // Draw outer circle background
    paint.color = backgroundColor;
    canvas.drawCircle(center, outerRadius, paint);

    // Draw border
    paint
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(center, outerRadius, paint);

    // Draw inner circle cutout
    paint
      ..color = Colors.transparent
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, innerRadius, paint);

    // Draw active direction highlight
    if (activeDirection != null && touchPosition != null) {
      _drawActiveSection(canvas, center);
    }
  }

  void _drawActiveSection(Canvas canvas, Offset center) {
    final paint = Paint()
      ..color = activeColor.withValues(alpha: 0.6)
      ..style = PaintingStyle.fill;

    final angle = _getAngleForDirection(activeDirection!);
    const sectionAngle = math.pi / 2; // 90 degrees for each section

    final path = Path();
    path.moveTo(center.dx, center.dy);
    path.arcTo(
      Rect.fromCircle(center: center, radius: outerRadius),
      angle - sectionAngle / 2,
      sectionAngle,
      false,
    );
    path.close();

    // Create inner circle cutout
    final innerPath = Path();
    innerPath.addOval(Rect.fromCircle(center: center, radius: innerRadius));

    final finalPath = Path.combine(PathOperation.difference, path, innerPath);
    canvas.drawPath(finalPath, paint);
  }

  double _getAngleForDirection(String direction) {
    switch (direction) {
      case 'UP':
        return -math.pi / 2;
      case 'RIGHT':
        return 0;
      case 'DOWN':
        return math.pi / 2;
      case 'LEFT':
        return math.pi;
      default:
        return 0;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
