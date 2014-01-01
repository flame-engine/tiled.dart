part of tilemap;

class Layer {
  static const int FLIPPED_HORIZONTALLY_FLAG = 0x80000000;
  static const int FLIPPED_VERTICALLY_FLAG   = 0x40000000;
  static const int FLIPPED_DIAGONALLY_FLAG   = 0x20000000;

  String name;
  int width;
  int height;

  TiledMap map;
  List<List<int>> tileMatrix;

  List<Tile> _tiles;
  List<Tile> get tiles {
    if (_tiles == null) { _recalculateTiles(); }
    return _tiles;

  }

  Layer(this.name, this.width, this.height);

  // TMX data format documented here: https://github.com/bjorn/tiled/wiki/TMX-Map-Format#data
  assembleTileMatrix(var bytes) {
    tileMatrix = new List<List<int>>(height);

    var tileIndex = 0;
    for(var y = 0; y < height; ++y) {
      tileMatrix[y] = new List<int>(width);
      for(var x = 0; x < width; ++x) {


        var globalTileId = bytes[tileIndex] |
            bytes[tileIndex + 1] << 8 |
            bytes[tileIndex + 2] << 16 |
            bytes[tileIndex + 3] << 24;

        tileIndex += 4;

        // Read out the flags
        var flipped_horizontally = (globalTileId & FLIPPED_HORIZONTALLY_FLAG);
        var flipped_vertically = (globalTileId & FLIPPED_VERTICALLY_FLAG);
        var flipped_diagonally = (globalTileId & FLIPPED_DIAGONALLY_FLAG);

        // Clear the flags

        globalTileId &= ~(FLIPPED_HORIZONTALLY_FLAG |
            FLIPPED_VERTICALLY_FLAG |
            FLIPPED_DIAGONALLY_FLAG);

        tileMatrix[y][x] = globalTileId;
      }
    }
  }

  _recalculateTiles() {
    var x, y = 0;
    _tiles = new List<Tile>();
    tileMatrix.forEach( (List<int> row) {
      x = 0;
      row.forEach((int tileId) {
        var tile = map.getTileByGID(tileId)
            ..x = x
            ..y = y;
        _tiles.add(tile);

        x += map.tileWidth;
      });
      y += map.tileHeight;
    });
  }
}