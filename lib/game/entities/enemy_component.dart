import 'dart:ui' show Canvas, Color, Paint, Rect;

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import 'package:roguelike_dungeon/data/enemy_archetype.dart';
import 'package:roguelike_dungeon/game/dungeon/dungeon_game.dart';
import 'package:roguelike_dungeon/game/entities/damageable.dart';
import 'package:roguelike_dungeon/game/entities/player_component.dart';
import 'package:roguelike_dungeon/game/dungeon/enemy_projectile_component.dart';
import 'package:roguelike_dungeon/game/dungeon/explosion_damage_component.dart';
import 'package:roguelike_dungeon/services/services.dart';

/// Enemy that chases player, implements [Damageable]. Melee attacks or shoots projectiles.
class EnemyComponent extends PositionComponent
    with CollisionCallbacks, HasGameReference<DungeonGame>
    implements Damageable {
  EnemyComponent({
    required Vector2 position,
    required this.archetype,
    this.hpScale = 1.0,
    this.damageScale = 1.0,
    this.isBoss = false,
  })  : _maxHp = archetype.hp * (hpScale),
        _hp = archetype.hp * (hpScale),
        super(
          position: position,
          size: Vector2.all(
              Services.configLoader.gameConfig.tileSize * (isBoss ? 1.2 : 0.7)),
          anchor: Anchor.center,
        );

  final EnemyArchetype archetype;
  final double hpScale;
  final double damageScale;
  final bool isBoss;
  final double _maxHp;
  double _hp;
  double _attackCooldown = 0;
  double _shootCooldown = 0;

  double get effectiveDamage => archetype.damage * damageScale;

  @override
  bool get isAlive => _hp > 0;

  @override
  void takeDamage(double amount) {
    if (amount <= 0) return;
    _hp = (_hp - amount).clamp(0.0, _maxHp);
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
    if (!isAlive) {
      _onDeath();
      return;
    }
    final player = game.player;
    if (player == null || !player.stats.isAlive) return;

    _attackCooldown -= dt;
    _shootCooldown -= dt;

    final toPlayer = player.position - position;
    final dist = toPlayer.length;

    if (archetype.isRanged) {
      if (dist <= archetype.attackRange && _shootCooldown <= 0) {
        _shoot(player.position);
        _shootCooldown = archetype.shootCooldown;
      }
      // Move toward player but keep distance
      if (dist > archetype.attackRange * 0.7 && dist < 400) {
        final dir = toPlayer.normalized();
        position.add(dir * archetype.speed * dt);
      } else if (dist < archetype.attackRange * 0.5) {
        final dir = (-toPlayer).normalized();
        position.add(dir * archetype.speed * dt);
      }
    } else {
      if (dist <= archetype.attackRange && _attackCooldown <= 0) {
        game.damagePlayer(effectiveDamage);
        _attackCooldown = archetype.attackCooldown;
      }
      if (dist > archetype.attackRange) {
        final dir = toPlayer.normalized();
        position.add(dir * archetype.speed * dt);
      }
    }
  }

  void _shoot(Vector2 targetPosition) {
    final dir = (targetPosition - position).normalized();
    game.world.add(EnemyProjectileComponent(
      position: position.clone(),
      direction: dir,
      speed: archetype.projectileSpeed,
      damage: effectiveDamage,
    ));
  }

  void _onDeath() {
    if (isBoss) {
      game.onBossKilled();
    }
    if (archetype.bombOnDeath) {
      game.world.add(ExplosionDamageComponent(
        position: position.clone(),
        radius: archetype.bombRadius,
        damage: archetype.bombDamage * damageScale,
      ));
    }
    removeFromParent();
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is WallHitbox) {
      _pushOutOfWall(other);
    }
  }

  void _pushOutOfWall(PositionComponent wall) {
    final wallRect = wall.toAbsoluteRect();
    final myRect = toAbsoluteRect();
    if (!wallRect.overlaps(myRect)) return;
    final overlapLeft = myRect.right - wallRect.left;
    final overlapRight = wallRect.right - myRect.left;
    final overlapTop = myRect.bottom - wallRect.top;
    final overlapBottom = wallRect.bottom - myRect.top;
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
    final color = isBoss
        ? const Color(0xFF7B1FA2)
        : archetype.isRanged
            ? const Color(0xFFE57373)
            : const Color(0xFFD32F2F);
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.x, size.y),
      Paint()..color = color,
    );
  }
}
