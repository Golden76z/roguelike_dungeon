import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'package:roguelike_dungeon/game/dungeon/dungeon_game.dart';
import 'package:roguelike_dungeon/ui/dungeon/map_overlay.dart';
import 'package:roguelike_dungeon/ui/widgets/virtual_joystick.dart';

/// Dungeon run: rooms, doors, map overlay. Entered from hub via dungeon door.
class DungeonScreen extends StatefulWidget {
  const DungeonScreen({super.key});

  @override
  State<DungeonScreen> createState() => _DungeonScreenState();
}

class _DungeonScreenState extends State<DungeonScreen> {
  late final DungeonGame _game;
  bool _mapVisible = false;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _game = DungeonGame();
    _game.startDungeon().then((_) {
      if (mounted) setState(() => _loading = false);
    });
  }

  @override
  void dispose() {
    _game.currentRoomNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          if (_loading)
            const Center(
              child: CircularProgressIndicator(color: Colors.white),
            )
          else
            GameWidget(game: _game),
          if (!_loading) ...[
            SafeArea(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 24),
                  child: VirtualJoystick(
                    onChanged: (dx, dy) =>
                        _game.setMovementDirection(dx, dy),
                  ),
                ),
              ),
            ),
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
            SafeArea(
              child: Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: IconButton(
                    icon: Icon(
                      _mapVisible ? Icons.map : Icons.map_outlined,
                      color: Colors.white,
                      size: 32,
                    ),
                    onPressed: () {
                      setState(() => _mapVisible = !_mapVisible);
                    },
                  ),
                ),
              ),
            ),
            if (_mapVisible)
              Positioned.fill(
                child: ValueListenableBuilder<int>(
                  valueListenable: _game.currentRoomNotifier,
                  builder: (context, value, child) => MapOverlay(game: _game),
                ),
              ),
          ],
        ],
      ),
    );
  }
}
