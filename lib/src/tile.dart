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

  Flips flips;

  Map<String, dynamic> properties = {};

  Image _image;

  set image(Image value) {
    _image = value;
  }

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

  Tile(this.tileId, this.tileset, {this.flips = const Flips.defaults()}) {
    width = tileset.width;
    height = tileset.height;
    spacing = tileset.spacing;
    margin = tileset.margin;
    gid = tileId + tileset.firstgid;
    properties = tileset.tileProperties[gid];

    properties ??= {};

    _image = tileset.tileImage[gid];
  }


  @override
  String toString() {
    return 'Tile{tileId: $tileId, tileset: ${tileset != null}, gid: $gid, width: $width, height: $height, spacing: $spacing, margin: $margin, flips: $flips, properties: $properties, _image: $_image, x: $x, y: $y, px: $px, py: $py}';
  }

  Tile.emptyTile() {
    gid = 0;
  }

  Rectangle computeDrawRect() {
    if (_image != null) {
      return Rectangle(0, 0, _image.width, _image.height);
    }
    final tilesPerRow = tileset.image.width ~/ (width + spacing);
    final row = tileId ~/ tilesPerRow;
    final column = tileId % tilesPerRow;
    final x = margin + (column * (width + spacing));
    final y = margin + (row * (height + spacing));
    return Rectangle(x, y, width + spacing, height + spacing);
  }
}
