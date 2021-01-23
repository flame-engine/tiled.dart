part of tiled;

class TileMap {
  int tileWidth;
  int tileHeight;
  int width;
  int height;
  List<Tileset> tilesets = [];
  List<Layer> layers = [];
  List<ObjectGroup> objectGroups = [];
  Map<String, dynamic> properties = {};


  @override
  String toString() {
    return 'TileMap{tileWidth: $tileWidth, tileHeight: $tileHeight, width: $width, height: $height, tilesets: $tilesets, layers: $layers, objectGroups: $objectGroups, properties: $properties}';
  }

  /// Retrieve a tile based on its GID
  ///
  /// GID is 1-based
  /// From offical documentation:
  /// In order to find out from which tileset the tile is you need to find the
  /// tileset with the highest firstgid that is still lower or equal than the gid.
  /// The tilesets are always stored with increasing firstgids.
  /// A GID of 0 is always an "empty" tile
  Tile getTileByGID(int gid) {
    if (gid == 0) {
      return Tile.emptyTile();
    }
    final ts = tilesets.lastWhere((tileset) => tileset.firstgid <= gid);
    return Tile(gid - ts.firstgid, ts);
  }

  // Returns a tileset based on its name
  Tileset getTileset(String name) {
    return tilesets.firstWhere(
      (tileset) => tileset.name == name,
      orElse: () => throw ArgumentError('Tileset $name not found'),
    );
  }

  /// Looks up a tile by its tileset and local tile id.
  Tile getTileByLocalID(String tilesetName, int localTileId) {
    final tileset = getTileset(tilesetName);
    return Tile(localTileId, tileset);
  }

  /// Looks up a tile by a 'tile phrase.'
  ///
  /// A tile phrase is simply a string with the tileset name and local tile id concated by the pipe character ('|').
  /// It is a short-hand way of calling [getTileByLocalID], and exists to faciliate a specifying
  /// a tile by its tileset and local tile ID without relying on a tile GID, which may change if tilesets are re-ordered.
  ///
  /// EX:
  ///   // returns the first tile in the tileset 'trees'
  ///   getTileByPhrase('Trees|0');
  Tile getTileByPhrase(String tilePhrase) {
    final split = tilePhrase.split('|');
    if (split.length != 2) {
      throw ArgumentError(
        '$tilePhrase not in the format of "TilesetName|LocalTileID"',
      );
    }

    final tilesetName = split.first;
    final tileId = int.tryParse(split.last);
    if (tileId == null) {
      throw ArgumentError('Local tile ID ${split.last} is not an integer.');
    }

    return getTileByLocalID(tilesetName, tileId);
  }
}
