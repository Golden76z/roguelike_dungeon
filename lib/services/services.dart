import 'package:roguelike_dungeon/services/config_loader.dart';
import 'package:roguelike_dungeon/services/save_service.dart';

/// Simple service locator so scenes can access config, save, etc.
/// Register once (e.g. in main or app init), then read anywhere.
final class Services {
  Services._();

  static ConfigLoader? _configLoader;
  static SaveService? _saveService;

  static ConfigLoader get configLoader {
    final v = _configLoader;
    if (v == null) {
      _configLoader = ConfigLoader();
      return _configLoader!;
    }
    return v;
  }

  static SaveService get saveService {
    final v = _saveService;
    if (v == null) {
      _saveService = SaveService();
      return _saveService!;
    }
    return v;
  }

  /// Call during app startup to preload config so [configLoader.gameConfig] is ready.
  static Future<void> init() async {
    await configLoader.loadGameConfig();
  }
}
