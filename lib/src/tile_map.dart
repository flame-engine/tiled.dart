part of tmx;

class TileMap {
  int tileWidth;
  int tileHeight;

  List<Tileset> tilesets = new List<Tileset>();
  List<Layer> layers = new List<Layer>();

  // Retrieve a tile based on its GID
  // GID is 1-based
  // From offical documentation:
  // In order to find out from which tileset the tile is you need to find the
  // tileset with the highest firstgid that is still lower or equal than the gid.
  // The tilesets are always stored with increasing firstgids.
  // A GID of 0 is always an "empty" tile
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
}