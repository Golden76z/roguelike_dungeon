/// Player stats for a run. Supports flat damage, crits, armor, resistances, status effects.
class PlayerStats {
  PlayerStats({
    required this.maxHp,
    this.baseDamage = 10,
    this.baseSpeed = 1,
    this.armor = 0,
    this.critChance = 0.1,
    this.critMultiplier = 1.5,
  }) : hp = maxHp;

  double hp;
  final double maxHp;
  /// Run-time bonus (e.g. from chest/boss rewards). Effective max = maxHp + runMaxHpBonus.
  double runMaxHpBonus = 0;
  double get effectiveMaxHp => maxHp + runMaxHpBonus;
  double baseDamage;
  double baseSpeed;
  double armor;
  double critChance;
  double critMultiplier;

  final List<StatusEffectInstance> statusEffects = [];

  bool get isAlive => hp > 0;

  /// Apply damage; returns actual damage after armor. [canCrit] for crit roll.
  double takeDamage(double amount, {bool canCrit = true}) {
    if (amount <= 0) return 0;
    final crit = canCrit && _rollCrit();
    final raw = crit ? amount * critMultiplier : amount;
    final reduced = (raw - armor).clamp(0.0, double.infinity).toDouble();
    hp = (hp - reduced).clamp(0.0, effectiveMaxHp);
    return reduced;
  }

  bool _rollCrit() {
    return critChance > 0 && _random.nextDouble() < critChance;
  }

  void heal(double amount) {
    hp = (hp + amount).clamp(0.0, effectiveMaxHp);
  }

  static final _random = _Random();
}

class _Random {
  int _seed = DateTime.now().millisecondsSinceEpoch;
  double nextDouble() {
    _seed = (1103515245 * _seed + 12345) & 0x7fffffff;
    return _seed / 0x7fffffff;
  }
}

/// Status effect (poison, burn, slow) with optional duration/damage.
enum StatusEffectType { poison, burn, slow }

class StatusEffectInstance {
  StatusEffectInstance({
    required this.type,
    this.durationSeconds = 3,
    this.damagePerSecond = 0,
    this.speedMultiplier = 1,
  });

  final StatusEffectType type;
  double durationSeconds;
  final double damagePerSecond;
  final double speedMultiplier;
}
