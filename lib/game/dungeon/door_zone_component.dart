import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import 'package:roguelike_dungeon/game/dungeon/dungeon_game.dart';
import 'package:roguelike_dungeon/game/entities/player_component.dart';

/// Invisible zone at a room door; when player overlaps, triggers room transition.
class DoorZoneComponent extends PositionComponent
    with CollisionCallbacks, HasGameReference<DungeonGame> {
  DoorZoneComponent({
    required this.direction,
    required super.position,
    required super.size,
  }) : super(anchor: Anchor.topLeft);

  final String direction;

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
      game.onDoorTriggered(direction);
    }
  }
}
