import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';

import 'package:roguelike_dungeon/data/chest_reward.dart';
import 'package:roguelike_dungeon/data/floor_node.dart';
import 'package:roguelike_dungeon/game/dungeon/attack_hitbox_component.dart';
import 'package:roguelike_dungeon/game/dungeon/chest_component.dart';
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
  int _currentWaveForRoom = 1;
  int _waveCountForRoom = 1;
  bool _currentRoomIsCombatOrBoss = false;
  double _waveSpawnCooldown = 0;
  int _roomsSinceLucky = 4;
  bool _currentRoomHadChest = false;
  int _luckyKeys = 1;

  /// Lucky room keys (max 3). Consumed when opening chest.
  int get luckyKeys => _luckyKeys;

  /// Notifier: when non-null, UI should show 3-card reward choice with these options.
  final ValueNotifier<List<ChestReward>?> chestRewardChoiceNotifier =
      ValueNotifier<List<ChestReward>?>(null);

  /// Notifier: when non-null, UI should show 3-card boss reward choice.
  final ValueNotifier<List<ChestReward>?> bossRewardChoiceNotifier =
      ValueNotifier<List<ChestReward>?>(null);

  /// Rubys earned this run (from bosses). For Hunter Log later.
  int get rubysEarnedThisRun => _rubysEarnedThisRun;
  int _rubysEarnedThisRun = 0;

  /// Best floor reached this run. Updated when a boss is killed.
  int get bestFloorReached => _bestFloorReached;
  int _bestFloorReached = 1;

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

  /// Called from overlay (Interact). Returns true if chest was opened (UI shows reward choice).
  bool tryInteract() {
    final chests = world.children.whereType<ChestComponent>().toList();
    if (chests.isEmpty) return false;
    final chest = chests.first;
    if (chest.isOpened) return false;
    final dist = (chest.position - _player.position).length;
    if (dist > 60) return false;
    if (_luckyKeys <= 0) return false;
    _luckyKeys--;
    chest.markOpened();
    final pool = Services.configLoader.chestRewards;
    final chosen = <ChestReward>[];
    final indices = List.generate(pool.length, (i) => i)..shuffle(_random);
    for (var i = 0; i < 3 && i < indices.length; i++) {
      chosen.add(pool[indices[i]]);
    }
    if (chosen.isNotEmpty) chestRewardChoiceNotifier.value = chosen;
    return true;
  }

  /// Apply chosen chest reward to player. Call after user picks one of the 3 cards.
  void applyChestReward(ChestReward reward) {
    _applyRewardToPlayer(reward);
    chestRewardChoiceNotifier.value = null;
  }

  /// Apply chosen boss reward to player. Call after user picks one of the 3 cards.
  void applyBossReward(ChestReward reward) {
    _applyRewardToPlayer(reward);
    bossRewardChoiceNotifier.value = null;
  }

  void _applyRewardToPlayer(ChestReward reward) {
    switch (reward.type) {
      case 'max_hp':
        _player.stats.runMaxHpBonus += reward.value;
        _player.stats.heal(reward.value);
        break;
      case 'heal':
        _player.stats.heal(reward.value);
        break;
      case 'damage':
        _player.stats.baseDamage += reward.value;
        break;
      case 'speed':
        _player.stats.baseSpeed += reward.value;
        break;
      case 'armor':
        _player.stats.armor += reward.value;
        break;
      default:
        _player.stats.heal(reward.value);
    }
  }

  /// Called when a boss enemy dies. Grant rubys, show reward choice, update best floor.
  void onBossKilled() {
    _rubysEarnedThisRun += 1;
    if (_currentFloor > _bestFloorReached) _bestFloorReached = _currentFloor;
    final pool = Services.configLoader.chestRewards;
    final chosen = <ChestReward>[];
    final indices = List.generate(pool.length, (i) => i)..shuffle(_random);
    for (var i = 0; i < 3 && i < indices.length; i++) {
      chosen.add(pool[indices[i]]);
    }
    if (chosen.isNotEmpty) bossRewardChoiceNotifier.value = chosen;
  }

  bool _isBossAlive() {
    return world.children.whereType<EnemyComponent>().any((e) => e.isBoss && e.isAlive);
  }

  @override
  void update(double dt) {
    super.update(dt);
    _player.tickCooldowns(dt);
    playerHpNotifier.value = _player.stats.hp;
    playerMaxHpNotifier.value = _player.stats.effectiveMaxHp;

    if (_currentRoomIsCombatOrBoss && _waveSpawnCooldown <= 0) {
      final enemyCount = world.children.whereType<EnemyComponent>().length;
      if (enemyCount == 0 && _currentWaveForRoom < _waveCountForRoom) {
        _currentWaveForRoom++;
        final node = _floorNodes[_currentRoomIndex];
        final ts = Services.configLoader.gameConfig.tileSize.toDouble();
        _spawnEnemiesInRoom(node, ts, _currentWaveForRoom);
        _waveSpawnCooldown = 0.5;
      }
    }
    if (_waveSpawnCooldown > 0) _waveSpawnCooldown -= dt;
  }

  /// Called when player hits a door zone. Transition to connected room or next floor.
  void onDoorTriggered(String direction) {
    final node = _floorNodes[_currentRoomIndex];
    if (node.isBoss && _isBossAlive()) return;
    if (_currentRoomHadChest) _roomsSinceLucky = 0;
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
    await Services.configLoader.loadChestRewards();
    await Services.configLoader.loadBossArchetypes();
    _currentFloor = 1;
    _bestFloorReached = 1;
    _rubysEarnedThisRun = 0;
    _previousFloorHadLucky = false;
    _roomsSinceLucky = 4;
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
    world.removeAll(world.children.whereType<ChestComponent>());

    final room = DungeonRoomComponent(node: node);
    world.add(room);

    final config = Services.configLoader.gameConfig;
    final ts = config.tileSize.toDouble();
    final px = (node.definition.widthTiles * ts) / 2;
    final py = (node.definition.heightTiles * ts) / 2;
    _player = PlayerComponent(position: Vector2(px, py));
    world.add(_player);

    final tags = node.definition.tags;
    _currentRoomIsCombatOrBoss = tags.contains('combat') || tags.contains('boss');
    _currentWaveForRoom = 1;
    _waveCountForRoom = tags.contains('boss')
        ? 1
        : config.waveCountForFloor(_currentFloor);
    _waveSpawnCooldown = 0;

    final isLuckyRoom = node.isLucky && _roomsSinceLucky >= 4;
    if (isLuckyRoom) {
      _currentRoomHadChest = true;
      final cx = (node.definition.widthTiles * ts) / 2;
      final cy = (node.definition.heightTiles * ts) / 2;
      world.add(ChestComponent(position: Vector2(cx, cy)));
    } else {
      _currentRoomHadChest = false;
    }
    _roomsSinceLucky++;

    if (_currentRoomIsCombatOrBoss) {
      _spawnEnemiesInRoom(node, ts, 1);
    }
    camera.follow(_player, snap: true);
  }

  void _spawnEnemiesInRoom(FloorNode node, double tileSize, int wave) {
    final tags = node.definition.tags;
    final isCombat = tags.contains('combat');
    final isBoss = tags.contains('boss');
    if (!isCombat && !isBoss) return;

    final config = Services.configLoader.gameConfig;
    final roomW = node.definition.widthTiles * tileSize;
    final roomH = node.definition.heightTiles * tileSize;
    const margin = 2.0;
    final minX = margin * tileSize;
    final minY = margin * tileSize;
    final maxX = roomW - margin * tileSize;
    final maxY = roomH - margin * tileSize;
    if (maxX <= minX || maxY <= minY) return;

    final hpScale = config.hpScaleForFloor(_currentFloor);
    final damageScale = config.damageScaleForFloor(_currentFloor);

    if (isBoss) {
      final boss = Services.configLoader.getBossForFloor(_currentFloor);
      if (boss == null) return;
      final x = minX + _random.nextDouble() * (maxX - minX);
      final y = minY + _random.nextDouble() * (maxY - minY);
      world.add(EnemyComponent(
        position: Vector2(x, y),
        archetype: boss.toEnemyArchetype(),
        hpScale: hpScale,
        damageScale: damageScale,
        isBoss: true,
      ));
      return;
    }

    final archetypes = Services.configLoader.archetypesForFloor(_currentFloor);
    if (archetypes.isEmpty) return;

    final count = (wave + _currentFloor + _random.nextInt(2)).clamp(1, 10);
    for (var i = 0; i < count; i++) {
      final archetype = archetypes[_random.nextInt(archetypes.length)];
      final x = minX + _random.nextDouble() * (maxX - minX);
      final y = minY + _random.nextDouble() * (maxY - minY);
      world.add(EnemyComponent(
        position: Vector2(x, y),
        archetype: archetype,
        hpScale: hpScale,
        damageScale: damageScale,
      ));
    }
  }

  void _goToNextFloor() {
    final config = Services.configLoader.gameConfig;
    if (_currentFloor >= config.maxFloors) return; // Win / end run.
    _currentFloor++;
    _roomsSinceLucky = 4;
    final hadLucky =
        _floorNodes.any((n) => n.isLucky);
    _previousFloorHadLucky = hadLucky;
    _floorNodes = FloorGenerator(_random).generate(_currentFloor,
        previousFloorHadLucky: _previousFloorHadLucky);
    _loadRoom(0);
  }
}
