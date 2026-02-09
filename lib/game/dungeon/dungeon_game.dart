import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';

import 'package:roguelike_dungeon/data/floor_node.dart';
import 'package:roguelike_dungeon/game/dungeon/attack_hitbox_component.dart';
import 'package:roguelike_dungeon/game/dungeon/dungeon_room_component.dart';
import 'package:roguelike_dungeon/game/dungeon/enemy_projectile_component.dart';
import 'package:roguelike_dungeon/game/dungeon/explosion_damage_component.dart';
import 'package:roguelike_dungeon/game/entities/enemy_component.dart';
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

  /// For health UI. Updated each frame from player stats.
  final ValueNotifier<double> playerHpNotifier = ValueNotifier(100);
  final ValueNotifier<double> playerMaxHpNotifier = ValueNotifier(100);

  int get currentFloor => _currentFloor;

  /// For enemies and projectiles. Null if not in dungeon.
  PlayerComponent? get player => _player;

  /// Called when an enemy or hazard damages the player.
  void damagePlayer(double amount) {
    _player.stats.takeDamage(amount);
  }

  /// Called from overlay (virtual joystick).
  void setMovementDirection(double dx, double dy) {
    _player.movementDirection = Vector2(dx, dy);
  }

  /// Called from overlay (attack button). Spawns melee hitbox in front of player.
  void attack() {
    if (!_player.canAttack) return;
    _player.performAttack();
    final pos = _player.attackSpawnPosition;
    const hitboxSize = 28.0;
    world.add(AttackHitboxComponent(
      position: pos,
      size: Vector2.all(hitboxSize),
      damage: _player.stats.baseDamage,
    ));
  }

  /// Called from overlay (dash button).
  void dash() {
    _player.performDash();
  }

  @override
  void update(double dt) {
    super.update(dt);
    _player.tickCooldowns(dt);
    playerHpNotifier.value = _player.stats.hp;
    playerMaxHpNotifier.value = _player.stats.maxHp;
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
    await Services.configLoader.loadEnemyArchetypes();
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
    world.removeAll(world.children.whereType<EnemyComponent>());
    world.removeAll(world.children.whereType<EnemyProjectileComponent>());
    world.removeAll(world.children.whereType<ExplosionDamageComponent>());

    final room = DungeonRoomComponent(node: node);
    world.add(room);

    final config = Services.configLoader.gameConfig;
    final ts = config.tileSize.toDouble();
    final px = (node.definition.widthTiles * ts) / 2;
    final py = (node.definition.heightTiles * ts) / 2;
    _player = PlayerComponent(position: Vector2(px, py));
    world.add(_player);

    _spawnEnemiesInRoom(node, ts);
    camera.follow(_player, snap: true);
  }

  void _spawnEnemiesInRoom(FloorNode node, double tileSize) {
    final tags = node.definition.tags;
    final isCombat = tags.contains('combat');
    final isBoss = tags.contains('boss');
    if (!isCombat && !isBoss) return;

    final archetypes = Services.configLoader.archetypesForFloor(_currentFloor);
    if (archetypes.isEmpty) return;

    final roomW = node.definition.widthTiles * tileSize;
    final roomH = node.definition.heightTiles * tileSize;
    const margin = 2.0;
    final minX = margin * tileSize;
    final minY = margin * tileSize;
    final maxX = roomW - margin * tileSize;
    final maxY = roomH - margin * tileSize;
    if (maxX <= minX || maxY <= minY) return;

    final count = isBoss
        ? 1
        : (1 + _currentFloor + _random.nextInt(2)).clamp(1, 8);
    for (var i = 0; i < count; i++) {
      final archetype = archetypes[_random.nextInt(archetypes.length)];
      final x = minX + _random.nextDouble() * (maxX - minX);
      final y = minY + _random.nextDouble() * (maxY - minY);
      world.add(EnemyComponent(
        position: Vector2(x, y),
        archetype: archetype,
      ));
    }
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
