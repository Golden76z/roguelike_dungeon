import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'package:roguelike_dungeon/game/roguelike_game.dart';
import 'package:roguelike_dungeon/ui/widgets/virtual_joystick.dart';

/// Hub world: single walkable map with shop, hunter log, character gallery,
/// best-floor display, dungeon door. Virtual joystick + interact overlay.
class HubScreen extends StatefulWidget {
  const HubScreen({super.key});

  @override
  State<HubScreen> createState() => _HubScreenState();
}

class _HubScreenState extends State<HubScreen> {
  late final RoguelikeGame _game;

  @override
  void initState() {
    super.initState();
    _game = RoguelikeGame();
  }

  @override
  void dispose() {
    _game.currentInteractable.dispose();
    super.dispose();
  }

  void _onInteract() {
    final id = _game.triggerInteract();
    if (id == null || !mounted) return;
    // Stub: show dialog or navigate. Chapter 10/4 will open real UIs.
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Interact: $id'),
        content: Text('Placeholder for $id. Will open shop / hunter log / etc.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GameWidget(game: _game),
          // Back to menu (temporary for testing).
          SafeArea(
            child: Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ),
          ),
          // Virtual joystick (left) + Interact button (right).
          SafeArea(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 24),
                child: VirtualJoystick(
                  onChanged: (dx, dy) => _game.setMovementDirection(dx, dy),
                ),
              ),
            ),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ValueListenableBuilder<String?>(
                      valueListenable: _game.currentInteractable,
                      builder: (context, value, _) {
                        if (value == null) return const SizedBox.shrink();
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(
                            'Press to interact',
                            style: TextStyle(
                              color: Colors.white,
                              shadows: [
                                Shadow(color: Colors.black, offset: Offset(1, 1)),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(
                      width: 64,
                      height: 64,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black87,
                          foregroundColor: Colors.white,
                          shape: const CircleBorder(),
                          side: const BorderSide(color: Colors.white, width: 2),
                        ),
                        onPressed: _onInteract,
                        child: const Text('E', style: TextStyle(fontSize: 20)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
