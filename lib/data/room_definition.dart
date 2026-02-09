/// Single room preset from JSON. Defines dimensions and which doors exist.
class RoomDefinition {
  const RoomDefinition({
    required this.id,
    required this.widthTiles,
    required this.heightTiles,
    required this.doors,
    required this.tags,
    this.floorMin = 1,
    this.floorMax = 25,
    this.difficultyTier = 0,
  });

  factory RoomDefinition.fromJson(Map<String, dynamic> json) {
    final doorsRaw = json['doors'];
    final List<String> doors = doorsRaw is List<dynamic>
        ? (doorsRaw).map((e) => e.toString()).toList()
        : <String>[];
    final tagsRaw = json['tags'];
    final List<String> tags = tagsRaw is List<dynamic>
        ? (tagsRaw).map((e) => e.toString()).toList()
        : <String>[];

    return RoomDefinition(
      id: json['id'] as String? ?? '',
      widthTiles: (json['widthTiles'] as num?)?.toInt() ?? 10,
      heightTiles: (json['heightTiles'] as num?)?.toInt() ?? 8,
      doors: doors,
      tags: tags,
      floorMin: (json['floorMin'] as num?)?.toInt() ?? 1,
      floorMax: (json['floorMax'] as num?)?.toInt() ?? 25,
      difficultyTier: (json['difficultyTier'] as num?)?.toInt() ?? 0,
    );
  }

  final String id;
  final int widthTiles;
  final int heightTiles;
  /// Door directions: 'top', 'bottom', 'left', 'right'
  final List<String> doors;
  /// e.g. 'combat', 'lucky', 'boss', 'stair_up'
  final List<String> tags;
  final int floorMin;
  final int floorMax;
  final int difficultyTier;

  bool hasDoor(String direction) => doors.contains(direction);
}
