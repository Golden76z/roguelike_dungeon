import 'package:flame/components.dart';

import 'package:roguelike_dungeon/game/dungeon/dungeon_game.dart';
import 'package:roguelike_dungeon/game/entities/enemy_component.dart';

/// Short-lived damage zone (e.g. bomb-on-death). After a short delay, damages
/// all Damageables and the player in radius; then removes itself.
class ExplosionDamageComponent extends PositionComponent
    with HasGameReference<DungeonGame> {
  ExplosionDamageComponent({
    required Vector2 position,
    required this.radius,
    required this.damage,
    this.delay = 0.05,
  }) : super(
          position: position,
          anchor: Anchor.center,
        );

  final double radius;
  final double damage;
  final double delay;
  double _age = 0;
  bool _applied = false;

  @override
  void update(double dt) {
    super.update(dt);
    _age += dt;
    if (_age >= delay && !_applied) {
      _applied = true;
      final center = absolutePosition;
      final player = game.player;
      if (player != null &&
          player.stats.isAlive &&
          (player.position - center).length <= radius) {
        game.damagePlayer(damage);
      }
      for (final c in game.world.children) {
        if (c is EnemyComponent &&
            c.isAlive &&
            (c.position - center).length <= radius) {
          c.takeDamage(damage);
        }
      }
      removeFromParent();
    }
  }
}
