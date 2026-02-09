import 'dart:convert';

import 'dart:ui' show Canvas, Color, Paint, Rect;

import 'package:flame/components.dart';
import 'package:flutter/services.dart';

import 'package:roguelike_dungeon/data/hub_map_data.dart';
import 'package:roguelike_dungeon/game/hub/wall_component.dart';

/// Hub tilemap (32×32): draws floor and walls, adds collision for walls.
/// Loads from assets/data/hub_map.json.
class HubMapComponent extends PositionComponent {
  HubMapComponent() : super(position: Vector2.zero(), anchor: Anchor.topLeft);

  HubMapData? _data;
  static const String _path = 'assets/data/hub_map.json';

  HubMapData get data {
    final d = _data;
    if (d == null) throw StateError('Hub map not loaded. Call loadMap() first.');
    return d;
  }

  Future<void> loadMap() async {
    final raw = await rootBundle.loadString(_path);
    final map = jsonDecode(raw) as Map<String, dynamic>;
    _data = HubMapData.fromJson(map);
    _addWalls();
  }

  void _addWalls() {
    final d = data;
    final ts = d.tileSize.toDouble();
    for (var y = 0; y < d.height; y++) {
      for (var x = 0; x < d.width; x++) {
        if (d.isWall(x, y)) {
          add(WallComponent(
            position: Vector2(x * ts, y * ts),
            tileSize: ts,
          ));
        }
      }
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final d = _data;
    if (d == null) return;
    final ts = d.tileSize.toDouble();
    final floorPaint = Paint()..color = const Color(0xFF2D2D2D);
    final wallPaint = Paint()..color = const Color(0xFF5D5D5D);
    for (var y = 0; y < d.height; y++) {
      for (var x = 0; x < d.width; x++) {
        final rect = Rect.fromLTWH(x * ts, y * ts, ts, ts);
        canvas.drawRect(rect, d.isWall(x, y) ? wallPaint : floorPaint);
      }
    }
  }
}
