/// Enemy archetype from JSON. Type (melee/ranged), stats, floor range, behavior flags.
class EnemyArchetype {
  const EnemyArchetype({
    required this.id,
    required this.type,
    required this.hp,
    required this.damage,
    required this.speed,
    this.floorMin = 1,
    this.floorMax = 25,
    this.attackRange = 24,
    this.attackCooldown = 1.0,
    this.projectileSpeed = 200,
    this.shootCooldown = 1.5,
    this.bombOnDeath = false,
    this.bombRadius = 40,
    this.bombDamage = 15,
  });

  factory EnemyArchetype.fromJson(Map<String, dynamic> json) {
    return EnemyArchetype(
      id: json['id'] as String? ?? '',
      type: json['type'] as String? ?? 'melee',
      hp: (json['hp'] as num?)?.toDouble() ?? 20,
      damage: (json['damage'] as num?)?.toDouble() ?? 5,
      speed: (json['speed'] as num?)?.toDouble() ?? 60,
      floorMin: (json['floorMin'] as num?)?.toInt() ?? 1,
      floorMax: (json['floorMax'] as num?)?.toInt() ?? 25,
      attackRange: (json['attackRange'] as num?)?.toDouble() ?? 24,
      attackCooldown: (json['attackCooldown'] as num?)?.toDouble() ?? 1.0,
      projectileSpeed: (json['projectileSpeed'] as num?)?.toDouble() ?? 200,
      shootCooldown: (json['shootCooldown'] as num?)?.toDouble() ?? 1.5,
      bombOnDeath: json['bombOnDeath'] as bool? ?? false,
      bombRadius: (json['bombRadius'] as num?)?.toDouble() ?? 40,
      bombDamage: (json['bombDamage'] as num?)?.toDouble() ?? 15,
    );
  }

  final String id;
  /// 'melee' or 'ranged'
  final String type;
  final double hp;
  final double damage;
  final double speed;
  final int floorMin;
  final int floorMax;
  final double attackRange;
  final double attackCooldown;
  final double projectileSpeed;
  final double shootCooldown;
  final bool bombOnDeath;
  final double bombRadius;
  final double bombDamage;

  bool get isMelee => type == 'melee';
  bool get isRanged => type == 'ranged';
}
