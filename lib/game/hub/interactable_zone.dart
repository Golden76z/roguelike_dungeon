import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import 'package:roguelike_dungeon/game/entities/player_component.dart';
import 'package:roguelike_dungeon/game/roguelike_game.dart';

/// Invisible zone in hub: when player overlaps, sets [RoguelikeGame.currentInteractable].
/// Does not block movement (sensor-style: we use [CollisionType.passive] and player is active).
class InteractableZone extends PositionComponent
    with CollisionCallbacks, HasGameReference<RoguelikeGame> {
  InteractableZone({
    required this.id,
    required Vector2 position,
    required Vector2 size,
  }) : super(
          position: position,
          size: size,
          anchor: Anchor.topLeft,
        );

  final String id;

  @override
  Future<void> onLoad() async {
    add(RectangleHitbox(
      size: size,
      position: Vector2.zero(),
      collisionType: CollisionType.passive,
    ));
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is PlayerComponent) {
      game.setNearInteractable(id);
    }
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);
    if (other is PlayerComponent) {
      game.clearNearInteractable(id);
    }
  }
}
