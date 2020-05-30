part of tiled;

class Tile {
  // Tile IDs are 0-based, to conform with TMX documentation.
  int tileId;
  Tileset tileset;

  // Tile global IDs aren't 1-based, but start from "1" (0 being an "null tile").
  int gid;

  int width;
  int height;
  int spacing;
  int margin;

  bool flippedHorizontally;
  bool flippedVertically;
  bool flippedDiagonally;

  Map<String, dynamic> properties = {};

  Image _image;

  Image get image {
    if (_image == null) {
      return tileset.image;
    }
    return _image;
  }

  // Optional X / Y locations for the tile.
  int x, y;
  int px, py;

  bool get isEmpty {
    return gid == 0;
  }

  Tile(this.tileId, this.tileset, this.flippedHorizontally, this.flippedVertically, this.flippedDiagonally) {
    width = tileset.width;
    height = tileset.height;
    spacing = tileset.spacing;
    margin = tileset.margin;
    gid = tileId + tileset.firstgid;
    properties = tileset.tileProperties[gid];

    properties ??= {};

    _image = tileset.tileImage[gid];
  }

  Tile.emptyTile() {
    gid = 0;
  }

  Rectangle computeDrawRect() {
    if (_image != null) {
      return new Rectangle(0, 0, _image.width, _image.height);
    }
    var tilesPerRow = tileset.image.width ~/ (width + spacing);
    var row = tileId ~/ tilesPerRow;
    var column = tileId % tilesPerRow;
    var x = margin + (column * (width + spacing));
    var y = margin + (row * (height + spacing));
    return new Rectangle(x, y, width + spacing, height + spacing);
  }
}
