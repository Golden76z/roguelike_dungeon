import 'dart:ui' show Canvas, Color, Paint, Rect;

import 'package:flame/components.dart';

import 'package:roguelike_dungeon/services/services.dart';

/// Chest in a lucky room. Placeholder: brown/gold square. Interact handled by [DungeonGame.tryInteract].
class ChestComponent extends PositionComponent {
  ChestComponent({required Vector2 position})
      : super(
          position: position,
          size: Vector2.all(
              Services.configLoader.gameConfig.tileSize * 1.2),
          anchor: Anchor.center,
        );

  bool _opened = false;
  bool get isOpened => _opened;

  void markOpened() {
    _opened = true;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final color = _opened
        ? const Color(0xFF5D4037)
        : const Color(0xFF8D6E63);
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.x, size.y),
      Paint()..color = color,
    );
  }
}
