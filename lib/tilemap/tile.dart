part of tilemap;

class Tile {
  // Tile IDs are 1-based
  int tileId;
  Tileset tileset;

  // Tile global IDs are 1-based
  int gid;

  int width;
  int height;

  // Optional X / Y locations for the tile.
  int x, y;

  bool get isEmpty { return gid == 0; }

  Tile(this.tileId, this.tileset) {
    width = tileset.width;
    height = tileset.height;
    gid = tileId + (tileset.gid - 1);
  }

  Tile.emptyTile() {
    gid = 0;
  }
}