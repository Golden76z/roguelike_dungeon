import 'dart:math' show Random, sqrt;

import 'package:roguelike_dungeon/data/floor_node.dart';
import 'package:roguelike_dungeon/data/room_definition.dart';
import 'package:roguelike_dungeon/services/services.dart';

/// Generates a maze-like floor graph: near-square layout, stair up, lucky rules, boss every 5 floors.
class FloorGenerator {
  FloorGenerator(this._random);

  final Random _random;

  /// Number of rooms for a given floor (from config).
  static int roomCountForFloor(int floor) {
    return Services.configLoader.gameConfig.roomCountForFloor(floor);
  }

  /// Generate floor graph. [previousFloorHadLucky] for "at least one lucky if previous had none".
  List<FloorNode> generate(int floor, {bool previousFloorHadLucky = false}) {
    final config = Services.configLoader.gameConfig;
    final presets = Services.configLoader.roomPresets;
    final count = config.roomCountForFloor(floor);
    final isBossFloor = floor > 0 && floor % config.bossEveryFloors == 0;

    // Build grid dimensions (near-square): e.g. 4 -> 2x2, 6 -> 2x3, 9 -> 3x3.
    final cols = (sqrt(count).ceil()).clamp(2, 6);
    final rows = (count / cols).ceil().clamp(2, 6);
    final total = cols * rows;

    // Shuffle indices for room assignment; we'll assign types to positions.
    final indices = List.generate(total, (i) => i)..shuffle(_random);

    int stairIndex = indices[0];
    int bossIndex = -1;
    if (isBossFloor) bossIndex = indices[1];
    final luckyCount = _luckyCount(floor, previousFloorHadLucky);
    final luckyIndices = <int>{
      for (var i = 0; i < luckyCount && i + 2 < total; i++) indices[2 + i],
    };

    final nodes = <FloorNode>[];
    for (var i = 0; i < total; i++) {
      final row = i ~/ cols;
      final col = i % cols;
      final isStair = i == stairIndex;
      final isBoss = i == bossIndex;
      final isLucky = luckyIndices.contains(i);

      RoomDefinition def;
      if (isBoss) {
        def = presets.firstWhere(
          (p) => p.tags.contains('boss'),
          orElse: () => presets.firstWhere((p) => p.doors.isNotEmpty),
        );
      } else if (isStair) {
        def = presets.firstWhere(
          (p) => p.tags.contains('stair_up'),
          orElse: () => presets.firstWhere((p) => p.doors.isNotEmpty),
        );
      } else if (isLucky) {
        def = presets.firstWhere(
          (p) => p.tags.contains('lucky'),
          orElse: () => presets.firstWhere((p) => p.doors.isNotEmpty),
        );
      } else {
        final combat = presets
            .where((p) =>
                p.tags.contains('combat') &&
                floor >= p.floorMin &&
                floor <= p.floorMax)
            .toList();
        def = combat.isNotEmpty
            ? combat[_random.nextInt(combat.length)]
            : presets.firstWhere((p) => p.doors.isNotEmpty);
      }

      final neighbors = <String, int>{};
      if (col > 0) neighbors['left'] = i - 1;
      if (col < cols - 1) neighbors['right'] = i + 1;
      if (row > 0) neighbors['top'] = i - cols;
      if (row < rows - 1) neighbors['bottom'] = i + cols;

      nodes.add(FloorNode(
        index: i,
        definition: def,
        neighbors: neighbors,
        isStairUp: isStair,
        isBoss: isBoss,
        isLucky: isLucky,
      ));
    }

    return nodes;
  }

  /// Max 2 lucky per floor; at least 1 if previous had none.
  int _luckyCount(int floor, bool previousFloorHadLucky) {
    if (previousFloorHadLucky) return _random.nextInt(3); // 0, 1, or 2
    return 1 + _random.nextInt(2); // 1 or 2
  }
}
