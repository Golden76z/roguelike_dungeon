/// Root game config loaded from assets/data/game_config.json.
/// All content and tuning live in JSON/YAML; floors, waves, and difficulty are driven from here.
class GameConfig {
  const GameConfig({
    required this.tileSize,
    required this.maxFloors,
    required this.bossEveryFloors,
    this.roomCountBase = 4,
    this.roomCountPer5Floors = 1,
    this.roomCountMax = 16,
    this.waveCountBase = 1,
    this.waveCountPer5Floors = 1,
    this.waveCountMax = 4,
    this.hpScalePerFloor = 0.05,
    this.damageScalePerFloor = 0.03,
  });

  factory GameConfig.fromJson(Map<String, dynamic> json) {
    return GameConfig(
      tileSize: (json['tileSize'] as num?)?.toInt() ?? 32,
      maxFloors: (json['maxFloors'] as num?)?.toInt() ?? 25,
      bossEveryFloors: (json['bossEveryFloors'] as num?)?.toInt() ?? 5,
      roomCountBase: (json['roomCountBase'] as num?)?.toInt() ?? 4,
      roomCountPer5Floors: (json['roomCountPer5Floors'] as num?)?.toInt() ?? 1,
      roomCountMax: (json['roomCountMax'] as num?)?.toInt() ?? 16,
      waveCountBase: (json['waveCountBase'] as num?)?.toInt() ?? 1,
      waveCountPer5Floors: (json['waveCountPer5Floors'] as num?)?.toInt() ?? 1,
      waveCountMax: (json['waveCountMax'] as num?)?.toInt() ?? 4,
      hpScalePerFloor: (json['hpScalePerFloor'] as num?)?.toDouble() ?? 0.05,
      damageScalePerFloor:
          (json['damageScalePerFloor'] as num?)?.toDouble() ?? 0.03,
    );
  }

  final int tileSize;
  final int maxFloors;
  final int bossEveryFloors;
  final int roomCountBase;
  final int roomCountPer5Floors;
  final int roomCountMax;
  final int waveCountBase;
  final int waveCountPer5Floors;
  final int waveCountMax;
  final double hpScalePerFloor;
  final double damageScalePerFloor;

  /// Number of rooms on this floor (increases with floor).
  int roomCountForFloor(int floor) {
    final extra = (floor / 5).floor() * roomCountPer5Floors;
    return (roomCountBase + extra).clamp(roomCountBase, roomCountMax);
  }

  /// Number of waves in combat rooms on this floor.
  int waveCountForFloor(int floor) {
    final extra = (floor / 5).floor() * waveCountPer5Floors;
    return (waveCountBase + extra).clamp(waveCountBase, waveCountMax);
  }

  /// HP multiplier for enemies on this floor (1.0 on floor 1).
  double hpScaleForFloor(int floor) {
    return 1.0 + (floor - 1) * hpScalePerFloor;
  }

  /// Damage multiplier for enemies on this floor (1.0 on floor 1).
  double damageScaleForFloor(int floor) {
    return 1.0 + (floor - 1) * damageScalePerFloor;
  }
}
