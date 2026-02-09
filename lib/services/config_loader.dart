import 'dart:convert';

import 'package:flutter/services.dart';

import 'package:roguelike_dungeon/data/game_config.dart';

/// Loads game configuration from assets/data/.
/// All content is data-driven via JSON/YAML; add new asset paths as needed.
class ConfigLoader {
  ConfigLoader();

  static const String _gameConfigPath = 'assets/data/game_config.json';

  GameConfig? _gameConfig;

  /// Cached game config; call [loadGameConfig] first (e.g. at app start or before hub).
  GameConfig get gameConfig {
    final c = _gameConfig;
    if (c == null) {
      throw StateError('Config not loaded. Call loadGameConfig() first.');
    }
    return c;
  }

  /// Loads [GameConfig] from assets. Safe to call multiple times; refreshes cache.
  Future<GameConfig> loadGameConfig() async {
    final raw = await rootBundle.loadString(_gameConfigPath);
    final map = jsonDecode(raw) as Map<String, dynamic>;
    _gameConfig = GameConfig.fromJson(map);
    return _gameConfig!;
  }
}
