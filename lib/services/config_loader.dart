import 'dart:convert';

import 'package:flutter/services.dart';

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

  GameConfig? _gameConfig;
  List<RoomDefinition>? _roomPresets;
  List<EnemyArchetype>? _enemyArchetypes;

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

  /// Archetypes valid for the given floor (floorMin <= floor <= floorMax).
  List<EnemyArchetype> archetypesForFloor(int floor) {
    return enemyArchetypes
        .where((a) => floor >= a.floorMin && floor <= a.floorMax)
        .toList();
  }
}
