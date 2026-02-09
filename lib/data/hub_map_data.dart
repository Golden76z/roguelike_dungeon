/// Hub map loaded from assets/data/hub_map.json.
/// Layers: floor (tile index), walls (0 = walkable, 1 = solid).
class HubMapData {
  const HubMapData({
    required this.width,
    required this.height,
    required this.tileSize,
    required this.wallGrid,
  });

  factory HubMapData.fromJson(Map<String, dynamic> json) {
    final layers = json['layers'] as Map<String, dynamic>? ?? {};
    final wallsRaw = layers['walls'] as List<dynamic>?;
    final width = (json['width'] as num?)?.toInt() ?? 20;
    final height = (json['height'] as num?)?.toInt() ?? 15;
    final tileSize = (json['tileSize'] as num?)?.toInt() ?? 32;

    List<List<int>> wallGrid = List.generate(height, (_) => List.filled(width, 0));
    if (wallsRaw != null) {
      for (var y = 0; y < height && y < wallsRaw.length; y++) {
        final row = wallsRaw[y] as List<dynamic>?;
        if (row != null) {
          for (var x = 0; x < width && x < row.length; x++) {
            wallGrid[y][x] = (row[x] as num?)?.toInt() ?? 0;
          }
        }
      }
    }

    return HubMapData(
      width: width,
      height: height,
      tileSize: tileSize,
      wallGrid: wallGrid,
    );
  }

  final int width;
  final int height;
  final int tileSize;
  final List<List<int>> wallGrid;

  bool isWall(int x, int y) {
    if (x < 0 || x >= width || y < 0 || y >= height) return true;
    return wallGrid[y][x] == 1;
  }
}
