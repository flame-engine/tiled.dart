part of tmx;

class Tile {
  // Tile IDs are 0-based, to conform with TMX documentation.
  int tileId;
  Tileset tileset;

  // Tile global IDs aren't 1-based, but start from "1" (0 being an "null tile").
  int gid;

  int width;
  int height;

  Map<String, String> properties = new Map();
  Image _image;

  Image get image {
    if (_image == null) {
      return tileset.image;
    }
    return _image;
  }

  // Optional X / Y locations for the tile.
  int x, y;

  bool get isEmpty {
    return gid == 0;
  }

  Tile(this.tileId, this.tileset) {
    width = tileset.width;
    height = tileset.height;
    gid = tileId + tileset.firstgid;
    properties = tileset.tileProperties[gid];
    if (properties == null) {
      properties = {};
    }
    _image = tileset.tileImage[gid];
  }

  Tile.emptyTile() {
    gid = 0;
  }

  Rectangle computeDrawRect() {
    if (_image != null) {
      return new Rectangle(0, 0, _image.width, _image.height);
    }
    return null;
    // var tilesPerRow = tile.tileset.images[0].width / tile.width;
    // var row = (tile.tileId / tilesPerRow) as int;
    // var column = tile.tileId % tilesPerRow;
    // var x = column * tile.width;
    // var y = (row * tile.height) as double;
    // return new Rect.fromLTWH(x, y, tile.width as double, tile.height as double);
  }
}
