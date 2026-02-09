import 'dart:ui' show Canvas, Color, Paint, Rect;

import 'package:flame/components.dart';

import 'package:roguelike_dungeon/data/floor_node.dart';
import 'package:roguelike_dungeon/game/dungeon/door_zone_component.dart';
import 'package:roguelike_dungeon/game/dungeon/dungeon_game.dart';
import 'package:roguelike_dungeon/game/hub/wall_component.dart';
import 'package:roguelike_dungeon/services/services.dart';

/// One dungeon room: walls from room definition, door zones that trigger transition.
class DungeonRoomComponent extends PositionComponent
    with HasGameReference<DungeonGame> {
  DungeonRoomComponent({required this.node});

  final FloorNode node;

  late double _tileSize;
  late int _widthTiles;
  late int _heightTiles;

  @override
  Future<void> onLoad() async {
    final config = Services.configLoader.gameConfig;
    _tileSize = config.tileSize.toDouble();
    _widthTiles = node.definition.widthTiles;
    _heightTiles = node.definition.heightTiles;

    _addWalls();
    _addDoorZones();
  }

  void _addWalls() {
    final ts = _tileSize;
    // Border walls
    for (var x = 0; x < _widthTiles; x++) {
      add(WallComponent(position: Vector2(x * ts, 0), tileSize: ts));
      add(WallComponent(
          position: Vector2(x * ts, (_heightTiles - 1) * ts), tileSize: ts));
    }
    for (var y = 1; y < _heightTiles - 1; y++) {
      add(WallComponent(position: Vector2(0, y * ts), tileSize: ts));
      add(WallComponent(
          position: Vector2((_widthTiles - 1) * ts, y * ts), tileSize: ts));
    }
  }

  void _addDoorZones() {
    final ts = _tileSize;
    final doorWidth = ts * 2;
    final centerX = (_widthTiles * ts) / 2 - doorWidth / 2;

    if (node.definition.hasDoor('top')) {
      add(DoorZoneComponent(
        direction: 'top',
        position: Vector2(centerX, 0),
        size: Vector2(doorWidth, ts),
      ));
    }
    if (node.definition.hasDoor('bottom')) {
      add(DoorZoneComponent(
        direction: 'bottom',
        position: Vector2(centerX, (_heightTiles - 1) * ts),
        size: Vector2(doorWidth, ts),
      ));
    }
    if (node.definition.hasDoor('left')) {
      add(DoorZoneComponent(
        direction: 'left',
        position: Vector2(0, (_heightTiles * ts) / 2 - doorWidth / 2),
        size: Vector2(ts, doorWidth),
      ));
    }
    if (node.definition.hasDoor('right')) {
      add(DoorZoneComponent(
        direction: 'right',
        position: Vector2((_widthTiles - 1) * ts, (_heightTiles * ts) / 2 - doorWidth / 2),
        size: Vector2(ts, doorWidth),
      ));
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final ts = _tileSize;
    final floorPaint = Paint()..color = const Color(0xFF1a1a2e);
    for (var y = 1; y < _heightTiles - 1; y++) {
      for (var x = 1; x < _widthTiles - 1; x++) {
        canvas.drawRect(
          Rect.fromLTWH(x * ts, y * ts, ts, ts),
          floorPaint,
        );
      }
    }
  }

  double get widthPx => _widthTiles * _tileSize;
  double get heightPx => _heightTiles * _tileSize;
}
