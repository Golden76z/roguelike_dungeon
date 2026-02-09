import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'package:roguelike_dungeon/game/roguelike_game.dart';

/// Hub world: single walkable map with shop, hunter log, character gallery,
/// best-floor display, dungeon door. For now shows Flame game placeholder.
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GameWidget(game: _game),
          // Temporary: back to menu for testing. Remove when hub has proper exit flow.
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
        ],
      ),
    );
  }
}
