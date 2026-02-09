import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';

import 'package:roguelike_dungeon/game/entities/damageable.dart';

/// Short-lived hitbox that damages [Damageable] components on collision.
/// Spawn in front of player on attack; removed after first hit or timeout.
class AttackHitboxComponent extends PositionComponent
    with CollisionCallbacks, HasGameReference<FlameGame> {
  AttackHitboxComponent({
    required Vector2 position,
    required Vector2 size,
    required this.damage,
    this.lifetime = 0.15,
  }) : super(
          position: position,
          size: size,
          anchor: Anchor.center,
        );

  final double damage;
  final double lifetime;
  double _age = 0;

  @override
  Future<void> onLoad() async {
    add(RectangleHitbox(
      size: size,
      collisionType: CollisionType.active,
    ));
  }

  @override
  void update(double dt) {
    super.update(dt);
    _age += dt;
    if (_age >= lifetime) {
      removeFromParent();
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is! Damageable) return;
    final d = other as Damageable;
    if (d.isAlive) {
      d.takeDamage(damage);
      removeFromParent();
    }
  }
}
