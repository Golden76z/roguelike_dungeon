import 'package:flutter/material.dart';

import 'package:roguelike_dungeon/data/floor_node.dart';
import 'package:roguelike_dungeon/game/dungeon/dungeon_game.dart';

/// Full-screen overlay: current floor map with walls in white. Input-transparent
/// so movement/combat controls pass through; close by tapping map icon again.
class MapOverlay extends StatelessWidget {
  const MapOverlay({
    super.key,
    required this.game,
  });

  final DungeonGame game;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: CustomPaint(
        painter: _MapOverlayPainter(
          nodes: game.floorNodes,
          currentIndex: game.currentRoomIndex,
        ),
        size: Size.infinite,
      ),
    );
  }
}

class _MapOverlayPainter extends CustomPainter {
  _MapOverlayPainter({required this.nodes, required this.currentIndex});

  final List<FloorNode> nodes;
  final int currentIndex;

  @override
  void paint(Canvas canvas, Size size) {
    if (nodes.isEmpty) return;

    final padding = 32.0;
    final availableW = size.width - padding * 2;
    final availableH = size.height - padding * 2;

    final n = nodes.length;
    final cols = _ceilSqrt(n);
    final rows = (n / cols).ceil();
    final cellW = availableW / cols;
    final cellH = availableH / rows;
    final scale = (cellW < cellH ? cellW : cellH) * 0.9;
    final offsetX = padding + (availableW - cols * scale) / 2;
    final offsetY = padding + (availableH - rows * scale) / 2;

    final wallPaint = Paint()
      ..color = const Color(0xFFFFFFFF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    final currentPaint = Paint()
      ..color = const Color(0x44FFFFFF)
      ..style = PaintingStyle.fill;
    final bgPaint = Paint()
      ..color = const Color(0xE0000000)
      ..style = PaintingStyle.fill;

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    for (var i = 0; i < n; i++) {
      final row = i ~/ cols;
      final col = i % cols;
      final x = offsetX + col * scale;
      final y = offsetY + row * scale;
      final rect = Rect.fromLTWH(x, y, scale, scale);

      if (i == currentIndex) {
        canvas.drawRect(rect, currentPaint);
      }
      canvas.drawRect(rect, wallPaint);
    }
  }

  int _ceilSqrt(int n) {
    if (n <= 0) return 0;
    var x = 1;
    while (x * x < n) {
      x++;
    }
    return x;
  }

  @override
  bool shouldRepaint(covariant _MapOverlayPainter old) {
    return old.nodes != nodes || old.currentIndex != currentIndex;
  }
}
