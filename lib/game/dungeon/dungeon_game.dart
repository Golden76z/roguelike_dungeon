import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';

import 'package:roguelike_dungeon/data/floor_node.dart';
import 'package:roguelike_dungeon/game/dungeon/dungeon_room_component.dart';
import 'package:roguelike_dungeon/game/entities/player_component.dart';
import 'package:roguelike_dungeon/game/rooms/floor_generator.dart';
import 'package:roguelike_dungeon/services/services.dart';

/// Dungeon run: one floor at a time, room-by-room. Camera follows player.
/// Map overlay reads [floorNodes] and [currentRoomIndex] to draw walls in white.
class DungeonGame extends FlameGame
    with HasCollisionDetection<Sweep<ShapeHitbox>> {
  DungeonGame() : super();

  final Random _random = Random();
  late final PlayerComponent _player;
  List<FloorNode> _floorNodes = [];
  int _currentRoomIndex = 0;
  int _currentFloor = 1;
  bool _previousFloorHadLucky = false;

  /// For map overlay: current floor's room graph.
  List<FloorNode> get floorNodes => _floorNodes;

  /// For map overlay: which room we're in.
  int get currentRoomIndex => _currentRoomIndex;

  /// Notifies when room changes so map overlay can rebuild.
  final ValueNotifier<int> currentRoomNotifier = ValueNotifier(0);

  int get currentFloor => _currentFloor;

  /// Called from overlay (virtual joystick).
  void setMovementDirection(double dx, double dy) {
    _player.movementDirection = Vector2(dx, dy);
  }

  /// Called when player hits a door zone. Transition to connected room or next floor.
  void onDoorTriggered(String direction) {
    final node = _floorNodes[_currentRoomIndex];
    final nextIndex = node.neighbors[direction];
    if (nextIndex != null && nextIndex >= 0 && nextIndex < _floorNodes.length) {
      _loadRoom(nextIndex);
      return;
    }
    if (node.isStairUp && direction == 'top') {
      _goToNextFloor();
    }
  }

  /// Load first floor and first room. Call after [ConfigLoader.loadRoomPresets].
  Future<void> startDungeon() async {
    await Services.configLoader.loadRoomPresets();
    _currentFloor = 1;
    _previousFloorHadLucky = false;
    _floorNodes = FloorGenerator(_random).generate(_currentFloor,
        previousFloorHadLucky: _previousFloorHadLucky);
    _currentRoomIndex = 0;
    await _loadRoom(0);
    camera.follow(_player, snap: true);
  }

  Future<void> _loadRoom(int roomIndex) async {
    _currentRoomIndex = roomIndex;
    currentRoomNotifier.value = roomIndex;
    final node = _floorNodes[roomIndex];

    world.removeAll(world.children.whereType<DungeonRoomComponent>());
    world.removeAll(world.children.whereType<PlayerComponent>());

    final room = DungeonRoomComponent(node: node);
    world.add(room);

    final config = Services.configLoader.gameConfig;
    final ts = config.tileSize.toDouble();
    final px = (node.definition.widthTiles * ts) / 2;
    final py = (node.definition.heightTiles * ts) / 2;
    _player = PlayerComponent(position: Vector2(px, py));
    world.add(_player);

    camera.follow(_player, snap: true);
  }

  void _goToNextFloor() {
    final config = Services.configLoader.gameConfig;
    if (_currentFloor >= config.maxFloors) return; // Win / end run.
    _currentFloor++;
    final hadLucky =
        _floorNodes.any((n) => n.isLucky);
    _previousFloorHadLucky = hadLucky;
    _floorNodes = FloorGenerator(_random).generate(_currentFloor,
        previousFloorHadLucky: _previousFloorHadLucky);
    _loadRoom(0);
  }
}
