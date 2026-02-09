import 'package:roguelike_dungeon/data/room_definition.dart';

/// One node in the floor graph: a room instance with connections by exit direction.
class FloorNode {
  const FloorNode({
    required this.index,
    required this.definition,
    required this.neighbors,
    this.isStairUp = false,
    this.isBoss = false,
    this.isLucky = false,
  });

  final int index;
  final RoomDefinition definition;
  /// Exit direction -> neighbor node index (-1 if no exit).
  final Map<String, int> neighbors;
  final bool isStairUp;
  final bool isBoss;
  final bool isLucky;
}
