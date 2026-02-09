import 'package:flame/components.dart';

import 'package:roguelike_dungeon/game/entities/player_component.dart';

/// Single wall tile in hub/dungeon. Passive collision for player push-back.
class WallComponent extends PositionComponent {
  WallComponent({required Vector2 position, required double tileSize})
      : super(
          position: position,
          size: Vector2.all(tileSize),
          anchor: Anchor.topLeft,
        );

  @override
  Future<void> onLoad() async {
    add(WallHitbox(
      size: size,
      position: Vector2.zero(),
    ));
  }
}
