import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'package:roguelike_dungeon/data/chest_reward.dart';
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
    _game.playerHpNotifier.dispose();
    _game.playerMaxHpNotifier.dispose();
    _game.chestRewardChoiceNotifier.dispose();
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
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      ValueListenableBuilder<double>(
                        valueListenable: _game.playerMaxHpNotifier,
                        builder: (context, maxHp, _) {
                          return ValueListenableBuilder<double>(
                            valueListenable: _game.playerHpNotifier,
                            builder: (context, hp, _) {
                              final ratio = maxHp > 0 ? (hp / maxHp).clamp(0.0, 1.0) : 0.0;
                              return SizedBox(
                                width: 120,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    Text(
                                      'HP ${hp.toInt()}/${maxHp.toInt()}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Keys: ${_game.luckyKeys}',
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 11,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(4),
                                      child: LinearProgressIndicator(
                                        value: ratio,
                                        minHeight: 8,
                                        backgroundColor: Colors.white24,
                                        valueColor: ratio > 0.25
                                            ? const AlwaysStoppedAnimation<Color>(Colors.red)
                                            : const AlwaysStoppedAnimation<Color>(Colors.redAccent),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SafeArea(
              child: Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 24, bottom: 32),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _ActionButton(
                        label: 'Interact',
                        onPressed: () => _game.tryInteract(),
                      ),
                      const SizedBox(width: 12),
                      _ActionButton(
                        label: 'Dash',
                        onPressed: () => _game.dash(),
                      ),
                      const SizedBox(width: 12),
                      _ActionButton(
                        label: 'Attack',
                        onPressed: () => _game.attack(),
                      ),
                    ],
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
            ValueListenableBuilder<List<ChestReward>?>(
              valueListenable: _game.chestRewardChoiceNotifier,
              builder: (context, rewards, _) {
                if (rewards == null || rewards.isEmpty) return const SizedBox.shrink();
                return Positioned.fill(
                  child: _RewardChoiceOverlay(
                    rewards: rewards,
                    onPick: (reward) {
                      _game.applyChestReward(reward);
                      setState(() {});
                    },
                  ),
                );
              },
            ),
          ],
        ],
      ),
    );
  }
}

class _RewardChoiceOverlay extends StatelessWidget {
  const _RewardChoiceOverlay({
    required this.rewards,
    required this.onPick,
  });

  final List<ChestReward> rewards;
  final void Function(ChestReward) onPick;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black54,
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Pick one reward',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: rewards.map((r) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: InkWell(
                    onTap: () => onPick(r),
                    child: Container(
                      width: 100,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      decoration: BoxDecoration(
                        color: Colors.white12,
                        border: Border.all(color: Colors.white38),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            r.label,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black54,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
