import 'dart:ui' show Canvas, Color, Paint, Rect;

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import 'package:flame/game.dart';
import 'package:roguelike_dungeon/data/player_stats.dart';
import 'package:roguelike_dungeon/services/services.dart';

/// Top-down hub/dungeon player. Movement, stats, combat. Works in hub (movement only) and dungeon.
class PlayerComponent extends PositionComponent
    with CollisionCallbacks, HasGameReference<FlameGame> {
  PlayerComponent({
    Vector2? position,
    PlayerStats? initialStats,
  })  : stats = initialStats ?? PlayerStats(maxHp: 100),
        super(
          position: position ?? Vector2.zero(),
          size: Vector2.all(Services.configLoader.gameConfig.tileSize * 0.8),
          anchor: Anchor.center,
        );

  final PlayerStats stats;
  final Vector2 _velocity = Vector2.zero();
  /// Last non-zero movement direction; used for attack spawn (default right).
  Vector2 lastFacing = Vector2(1, 0);
  static const double _speed = 120;
  bool _isDashing = false;
  double _attackCooldown = 0;
  static const double _attackCooldownDuration = 0.4;
  static const double _dashCooldownDuration = 1.2;
  double _dashCooldown = 0;

  Vector2 get velocity => _velocity;

  set movementDirection(Vector2 value) {
    if (value.length2 > 1) {
      value = value.normalized();
    }
    if (value.length2 > 0.01) lastFacing.setFrom(value.normalized());
    final speedMult = _isDashing ? 2.0 : 1.0;
    _velocity.setFrom(value * _speed * speedMult * stats.baseSpeed);
  }

  /// Call from game each frame to tick cooldowns.
  void tickCooldowns(double dt) {
    if (_attackCooldown > 0) _attackCooldown -= dt;
    if (_dashCooldown > 0) _dashCooldown -= dt;
    if (_isDashing) _isDashing = false;
  }

  bool get canAttack => _attackCooldown <= 0;
  bool get canDash => _dashCooldown <= 0;

  void performAttack() {
    if (!canAttack) return;
    _attackCooldown = _attackCooldownDuration;
    // Game will spawn attack hitbox; see DungeonGame.attack().
  }

  void performDash() {
    if (!canDash) return;
    _dashCooldown = _dashCooldownDuration;
    _isDashing = true;
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

  /// World position of attack spawn (center of player + offset in facing direction).
  Vector2 get attackSpawnPosition {
    final dist = (size.x / 2) + 14;
    return absolutePosition + lastFacing * dist;
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
    // Placeholder: green square (replace with sprite when art is ready).
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.x, size.y),
      Paint()..color = const Color(0xFF4CAF50),
    );
  }
}

/// Tag for wall hitboxes so player can identify them in onCollision.
class WallHitbox extends RectangleHitbox {
  WallHitbox({required super.size, super.position})
      : super(collisionType: CollisionType.passive);
}
