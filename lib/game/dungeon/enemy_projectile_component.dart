import 'dart:ui' show Canvas, Color, Offset, Paint;

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import 'package:roguelike_dungeon/game/dungeon/dungeon_game.dart';
import 'package:roguelike_dungeon/game/entities/player_component.dart';

/// Projectile shot by ranged enemies. Damages player on hit; no friendly fire.
class EnemyProjectileComponent extends PositionComponent
    with CollisionCallbacks, HasGameReference<DungeonGame> {
  EnemyProjectileComponent({
    required Vector2 position,
    required this.direction,
    required this.speed,
    required this.damage,
    this.maxLifetime = 3.0,
  }) : super(
          position: position,
          size: Vector2.all(12),
          anchor: Anchor.center,
        );

  final Vector2 direction;
  final double speed;
  final double damage;
  final double maxLifetime;
  double _lifetime = 0;

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
    position.add(direction * speed * dt);
    _lifetime += dt;
    if (_lifetime >= maxLifetime) removeFromParent();
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is PlayerComponent && other.stats.isAlive) {
      game.damagePlayer(damage);
      removeFromParent();
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawCircle(
      Offset(size.x / 2, size.y / 2),
      size.x / 2,
      Paint()..color = const Color(0xFFFF9800),
    );
  }
}
