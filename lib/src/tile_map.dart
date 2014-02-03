part of tmx;

class TileMap {
  int tileWidth;
  int tileHeight;

  List<Tileset> tilesets = new List<Tileset>();
  List<Layer> layers = new List<Layer>();

  /**
   * Retrieve a tile based on its GID
   *
   * GID is 1-based
   * From offical documentation:
   * In order to find out from which tileset the tile is you need to find the
   * tileset with the highest firstgid that is still lower or equal than the gid.
   * The tilesets are always stored with increasing firstgids.
   * A GID of 0 is always an "empty" tile
   */
  Tile getTileByGID(int gid) {
    if (gid == 0) { return new Tile.emptyTile(); }
    var ts = tilesets.lastWhere((tileset) => tileset.firstgid <= gid);
    return new Tile(gid - ts.firstgid, ts);
  }

  // Returns a tileset based on its name
  Tileset getTileset(String name) {
    return tilesets.firstWhere((tileset) => tileset.name == name,
      orElse: () => throw new ArgumentError('Tileset $name not found')
    );
  }

  /**
  * Looks up a tile by its tileset and local tile id.
  */
  Tile getTileByLocalID(String tilesetName, int localTileId) {
    var tileset = getTileset(tilesetName);
    return new Tile(localTileId, tileset);
  }

  /**
  * Looks up a tile by a 'tile phrase.'
  *
  * A tile phrase is simply a string with the tileset name and local tile id concated by the pipe character ('|').
  * It is a short-hand way of calling [getTileByLocalID], and exists to faciliate a specifying
  * a tile by its tileset and local tile ID without relying on a tile GID, which may change if tilesets are re-ordered.
  *
  * EX:
  *   // returns the first tile in the tileset 'trees'
  *   getTileByPhrase('Trees|0');
  *
  */
  Tile getTileByPhrase(String tilePhrase) {
    var split = tilePhrase.split('|');
    if (split.length != 2) { throw new ArgumentError("$tilePhrase not in the format of 'TilesetName|LocalTileID"); }

    var tilesetName = split.first;
    var tileId = int.parse(split.last,
      onError: (src) => throw new ArgumentError('Local tile ID $src is not an integer.') );

    return getTileByLocalID(tilesetName, tileId);
  }
}