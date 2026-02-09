import 'package:flame/collisions.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';

import 'package:roguelike_dungeon/game/entities/player_component.dart';
import 'package:roguelike_dungeon/game/hub/hub_map_component.dart';
import 'package:roguelike_dungeon/game/hub/interactable_zone.dart';
import 'package:roguelike_dungeon/services/services.dart';

/// Core Flame game. Hosts hub, dungeon, and overlays.
/// Hub: player, tilemap, interactables; camera follows player.
class RoguelikeGame extends FlameGame
    with HasCollisionDetection<Sweep<ShapeHitbox>> {
  RoguelikeGame() : super();

  late final PlayerComponent _player;
  final ValueNotifier<String?> currentInteractable = ValueNotifier<String?>(null);

  /// Called from overlay to move the player (virtual joystick).
  void setMovementDirection(double dx, double dy) {
    _player.movementDirection = Vector2(dx, dy);
  }

  /// Called by [InteractableZone] when player enters zone.
  void setNearInteractable(String id) {
    if (currentInteractable.value != id) {
      currentInteractable.value = id;
    }
  }

  /// Called by [InteractableZone] when player leaves zone.
  void clearNearInteractable(String id) {
    if (currentInteractable.value == id) {
      currentInteractable.value = null;
    }
  }

  /// Called when user presses Interact (e.g. button in overlay).
  /// Returns the id of the interactable so the UI can open the right screen/dialog.
  String? triggerInteract() {
    final id = currentInteractable.value;
    currentInteractable.value = null;
    return id;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final config = Services.configLoader.gameConfig;
    final tileSize = config.tileSize.toDouble();

    final hubMap = HubMapComponent();
    await hubMap.loadMap();
    world.add(hubMap);

    final mapWidth = hubMap.data.width * config.tileSize;
    final mapHeight = hubMap.data.height * config.tileSize;
    _player = PlayerComponent(
      position: Vector2(mapWidth / 2, mapHeight / 2),
    );
    world.add(_player);

    _addInteractableZones(tileSize, hubMap.data.width, hubMap.data.height);

    camera.follow(_player, snap: true);
  }

  void _addInteractableZones(double ts, int mapW, int mapH) {
    // 2x2 tile zones; (tx, ty) = top-left tile
    void addZone(String id, int tx, int ty) {
      world.add(InteractableZone(
        id: id,
        position: Vector2(tx * ts, ty * ts),
        size: Vector2(2 * ts, 2 * ts),
      ));
    }

    addZone('shop', 2, 4);
    addZone('hunter_log', 6, 4);
    addZone('character_gallery', 10, 4);
    addZone('best_floor', 14, 4);
    addZone('dungeon_door', 20, 8);
  }
}
