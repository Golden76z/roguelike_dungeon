import 'dart:ui' show Canvas, Color, Offset, Paint;

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import 'package:roguelike_dungeon/game/roguelike_game.dart';
import 'package:roguelike_dungeon/services/services.dart';

/// Top-down hub/dungeon player. Movement only in hub; receives velocity from
/// virtual joystick. Collides with walls.
class PlayerComponent extends PositionComponent
    with CollisionCallbacks, HasGameReference<RoguelikeGame> {
  PlayerComponent({Vector2? position})
      : super(
          position: position ?? Vector2.zero(),
          size: Vector2.all(Services.configLoader.gameConfig.tileSize * 0.8),
          anchor: Anchor.center,
        );

  final Vector2 _velocity = Vector2.zero();
  static const double _speed = 120;

  Vector2 get velocity => _velocity;

  set movementDirection(Vector2 value) {
    if (value.length2 > 1) {
      value = value.normalized();
    }
    _velocity.setFrom(value * _speed);
  }

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
    position += _velocity * dt;
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is WallHitbox) {
      _pushOutOfWall(intersectionPoints, other);
    }
  }

  void _pushOutOfWall(Set<Vector2> intersectionPoints, PositionComponent wall) {
    final wallRect = wall.toAbsoluteRect();
    final playerRect = toAbsoluteRect();
    if (!wallRect.overlaps(playerRect)) return;
    final overlapLeft = playerRect.right - wallRect.left;
    final overlapRight = wallRect.right - playerRect.left;
    final overlapTop = playerRect.bottom - wallRect.top;
    final overlapBottom = wallRect.bottom - playerRect.top;
    final minX = overlapLeft < overlapRight ? overlapLeft : -overlapRight;
    final minY = overlapTop < overlapBottom ? overlapTop : -overlapBottom;
    if (minX.abs() < minY.abs()) {
      position.x += minX;
    } else {
      position.y += minY;
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    // Placeholder: filled circle (replace with sprite later).
    canvas.drawCircle(
      Offset(size.x / 2, size.y / 2),
      size.x / 2,
      Paint()..color = const Color(0xFF4CAF50),
    );
  }
}

/// Tag for wall hitboxes so player can identify them in onCollision.
class WallHitbox extends RectangleHitbox {
  WallHitbox({required super.size, super.position})
      : super(collisionType: CollisionType.passive);
}
