import 'dart:convert';

import 'package:flutter/services.dart';

import 'package:roguelike_dungeon/data/boss_archetype.dart';
import 'package:roguelike_dungeon/data/chest_reward.dart';
import 'package:roguelike_dungeon/data/enemy_archetype.dart';
import 'package:roguelike_dungeon/data/game_config.dart';
import 'package:roguelike_dungeon/data/room_definition.dart';

/// Loads game configuration from assets/data/.
/// All content is data-driven via JSON/YAML; add new asset paths as needed.
class ConfigLoader {
  ConfigLoader();

  static const String _gameConfigPath = 'assets/data/game_config.json';
  static const String _roomPresetsPath = 'assets/data/room_presets.json';
  static const String _enemyArchetypesPath = 'assets/data/enemy_archetypes.json';
  static const String _chestRewardsPath = 'assets/data/chest_rewards.json';
  static const String _bossArchetypesPath = 'assets/data/boss_archetypes.json';

  GameConfig? _gameConfig;
  List<RoomDefinition>? _roomPresets;
  List<EnemyArchetype>? _enemyArchetypes;
  List<ChestReward>? _chestRewards;
  List<BossArchetype>? _bossArchetypes;

  /// Cached game config; call [loadGameConfig] first (e.g. at app start or before hub).
  GameConfig get gameConfig {
    final c = _gameConfig;
    if (c == null) {
      throw StateError('Config not loaded. Call loadGameConfig() first.');
    }
    return c;
  }

  /// Cached room presets; call [loadRoomPresets] first before generating floors.
  List<RoomDefinition> get roomPresets {
    final p = _roomPresets;
    if (p == null) {
      throw StateError('Room presets not loaded. Call loadRoomPresets() first.');
    }
    return p;
  }

  /// Cached enemy archetypes; call [loadEnemyArchetypes] first before spawning.
  List<EnemyArchetype> get enemyArchetypes {
    final e = _enemyArchetypes;
    if (e == null) {
      throw StateError(
          'Enemy archetypes not loaded. Call loadEnemyArchetypes() first.');
    }
    return e;
  }

  /// Loads [GameConfig] from assets. Safe to call multiple times; refreshes cache.
  Future<GameConfig> loadGameConfig() async {
    final raw = await rootBundle.loadString(_gameConfigPath);
    final map = jsonDecode(raw) as Map<String, dynamic>;
    _gameConfig = GameConfig.fromJson(map);
    return _gameConfig!;
  }

  /// Loads room presets from assets/data/room_presets.json.
  Future<List<RoomDefinition>> loadRoomPresets() async {
    final raw = await rootBundle.loadString(_roomPresetsPath);
    final map = jsonDecode(raw) as Map<String, dynamic>;
    final list = map['presets'] as List<dynamic>? ?? [];
    _roomPresets = list
        .map((e) => RoomDefinition.fromJson(e as Map<String, dynamic>))
        .toList();
    return _roomPresets!;
  }

  /// Loads enemy archetypes from assets/data/enemy_archetypes.json.
  Future<List<EnemyArchetype>> loadEnemyArchetypes() async {
    final raw = await rootBundle.loadString(_enemyArchetypesPath);
    final map = jsonDecode(raw) as Map<String, dynamic>;
    final list = map['archetypes'] as List<dynamic>? ?? [];
    _enemyArchetypes = list
        .map((e) => EnemyArchetype.fromJson(e as Map<String, dynamic>))
        .toList();
    return _enemyArchetypes!;
  }

  /// Cached chest reward pool; call [loadChestRewards] before opening chests.
  List<ChestReward> get chestRewards {
    final r = _chestRewards;
    if (r == null) {
      throw StateError(
          'Chest rewards not loaded. Call loadChestRewards() first.');
    }
    return r;
  }

  /// Archetypes valid for the given floor (floorMin <= floor <= floorMax).
  List<EnemyArchetype> archetypesForFloor(int floor) {
    return enemyArchetypes
        .where((a) => floor >= a.floorMin && floor <= a.floorMax)
        .toList();
  }

  /// Loads chest reward pool from assets/data/chest_rewards.json.
  Future<List<ChestReward>> loadChestRewards() async {
    final raw = await rootBundle.loadString(_chestRewardsPath);
    final map = jsonDecode(raw) as Map<String, dynamic>;
    final list = map['rewards'] as List<dynamic>? ?? [];
    _chestRewards = list
        .map((e) => ChestReward.fromJson(e as Map<String, dynamic>))
        .toList();
    return _chestRewards!;
  }

  /// Cached boss archetypes; call [loadBossArchetypes] before spawning boss rooms.
  List<BossArchetype> get bossArchetypes {
    final b = _bossArchetypes;
    if (b == null) {
      throw StateError(
          'Boss archetypes not loaded. Call loadBossArchetypes() first.');
    }
    return b;
  }

  /// Loads boss archetypes from assets/data/boss_archetypes.json.
  Future<List<BossArchetype>> loadBossArchetypes() async {
    final raw = await rootBundle.loadString(_bossArchetypesPath);
    final map = jsonDecode(raw) as Map<String, dynamic>;
    final list = map['bosses'] as List<dynamic>? ?? [];
    _bossArchetypes = list
        .map((e) => BossArchetype.fromJson(e as Map<String, dynamic>))
        .toList();
    return _bossArchetypes!;
  }

  /// Boss for milestone floor (5, 10, 15, 20, 25). Falls back to first boss if none match.
  BossArchetype? getBossForFloor(int floor) {
    final match = bossArchetypes.where((b) => b.floor == floor).toList();
    if (match.isNotEmpty) return match.first;
    return bossArchetypes.isNotEmpty ? bossArchetypes.first : null;
  }
}
