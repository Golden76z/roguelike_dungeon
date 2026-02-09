import 'package:roguelike_dungeon/data/enemy_archetype.dart';

/// Boss definition for a milestone floor (5, 10, 15, 20, 25). Converts to [EnemyArchetype] for spawning.
class BossArchetype {
  const BossArchetype({
    required this.id,
    required this.floor,
    required this.hp,
    required this.damage,
    required this.speed,
    this.attackRange = 28,
    this.attackCooldown = 0.9,
    this.type = 'melee',
  });

  factory BossArchetype.fromJson(Map<String, dynamic> json) {
    return BossArchetype(
      id: json['id'] as String? ?? '',
      floor: (json['floor'] as num?)?.toInt() ?? 5,
      hp: (json['hp'] as num?)?.toDouble() ?? 100,
      damage: (json['damage'] as num?)?.toDouble() ?? 12,
      speed: (json['speed'] as num?)?.toDouble() ?? 50,
      attackRange: (json['attackRange'] as num?)?.toDouble() ?? 28,
      attackCooldown: (json['attackCooldown'] as num?)?.toDouble() ?? 0.9,
      type: json['type'] as String? ?? 'melee',
    );
  }

  final String id;
  /// Milestone floor (5, 10, 15, 20, 25).
  final int floor;
  final double hp;
  final double damage;
  final double speed;
  final double attackRange;
  final double attackCooldown;
  final String type;

  EnemyArchetype toEnemyArchetype() {
    return EnemyArchetype(
      id: id,
      type: type,
      hp: hp,
      damage: damage,
      speed: speed,
      floorMin: floor,
      floorMax: floor,
      attackRange: attackRange,
      attackCooldown: attackCooldown,
    );
  }
}
