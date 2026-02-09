import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Virtual joystick: drag to set direction, outputs -1..1 for x and y.
/// Same control scheme as dungeon (design: virtual joystick + buttons).
class VirtualJoystick extends StatefulWidget {
  const VirtualJoystick({
    super.key,
    required this.onChanged,
    this.size = 120,
    this.knobRadius = 28,
  });

  final void Function(double dx, double dy) onChanged;
  final double size;
  final double knobRadius;

  @override
  State<VirtualJoystick> createState() => _VirtualJoystickState();
}

class _VirtualJoystickState extends State<VirtualJoystick> {
  double _dx = 0;
  double _dy = 0;

  void _onPanUpdate(DragUpdateDetails details) {
    final r = context.findRenderObject() as RenderBox?;
    if (r == null) return;
    final center = r.size.center(Offset.zero);
    var dx = details.localPosition.dx - center.dx;
    var dy = details.localPosition.dy - center.dy;
    final maxDist = widget.size / 2 - widget.knobRadius;
    final dist = math.sqrt(dx * dx + dy * dy);
    if (dist > maxDist && dist > 0) {
      final scale = maxDist / dist;
      dx *= scale;
      dy *= scale;
    }
    setState(() {
      _dx = maxDist > 0 ? dx / maxDist : 0;
      _dy = maxDist > 0 ? dy / maxDist : 0;
    });
    widget.onChanged(_dx, _dy);
  }

  void _onPanEnd(DragEndDetails _) {
    setState(() {
      _dx = 0;
      _dy = 0;
    });
    widget.onChanged(0, 0);
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.size;
    final c = s / 2;
    return SizedBox(
      width: s,
      height: s,
      child: GestureDetector(
        onPanUpdate: _onPanUpdate,
        onPanEnd: _onPanEnd,
        child: CustomPaint(
          size: Size(s, s),
          painter: _JoystickPainter(
            knobX: c + _dx * (c - widget.knobRadius),
            knobY: c + _dy * (c - widget.knobRadius),
            knobRadius: widget.knobRadius,
            baseRadius: c - 4,
          ),
        ),
      ),
    );
  }
}

class _JoystickPainter extends CustomPainter {
  _JoystickPainter({
    required this.knobX,
    required this.knobY,
    required this.knobRadius,
    required this.baseRadius,
  });

  final double knobX;
  final double knobY;
  final double knobRadius;
  final double baseRadius;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    canvas.drawCircle(
      center,
      baseRadius,
      Paint()
        ..color = const Color.fromRGBO(0, 0, 0, 0.5)
        ..style = PaintingStyle.fill,
    );
    canvas.drawCircle(
      center,
      baseRadius,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
    canvas.drawCircle(
      Offset(knobX, knobY),
      knobRadius,
      Paint()
        ..color = const Color.fromRGBO(255, 255, 255, 0.9)
        ..style = PaintingStyle.fill,
    );
    canvas.drawCircle(
      Offset(knobX, knobY),
      knobRadius,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
  }

  @override
  bool shouldRepaint(covariant _JoystickPainter oldDelegate) {
    return oldDelegate.knobX != knobX ||
        oldDelegate.knobY != knobY ||
        oldDelegate.knobRadius != knobRadius ||
        oldDelegate.baseRadius != baseRadius;
  }
}
