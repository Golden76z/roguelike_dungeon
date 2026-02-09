/// Root game config loaded from assets/data/game_config.json.
/// All content and tuning live in JSON/YAML; this is the first sample.
class GameConfig {
  const GameConfig({
    required this.tileSize,
    required this.maxFloors,
    required this.bossEveryFloors,
  });

  factory GameConfig.fromJson(Map<String, dynamic> json) {
    return GameConfig(
      tileSize: (json['tileSize'] as num?)?.toInt() ?? 32,
      maxFloors: (json['maxFloors'] as num?)?.toInt() ?? 25,
      bossEveryFloors: (json['bossEveryFloors'] as num?)?.toInt() ?? 5,
    );
  }

  final int tileSize;
  final int maxFloors;
  final int bossEveryFloors;
}
