part of tilemap;

class TiledMap {
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
    var ts = tilesets.lastWhere((tileset) => tileset.gid <= gid);
    return new Tile(gid - (ts.gid - 1), ts);
  }

  // Returns a tileset based on its name
  Tileset getTileset(String name) {
    return tilesets.firstWhere((tileset) => tileset.name == name);
  }
}