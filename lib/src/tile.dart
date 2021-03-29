import 'dart:math';
import '../tiled.dart';
import 'tileset.dart';
import 'image.dart';
import 'flips.dart';

class Tile {
  // Tile IDs are 0-based, to conform with TMX documentation.
  int tileId = 0;
  Tileset tileset;

  // Tile global IDs aren't 1-based, but start from "1" (0 being an "null tile").
  int gid = 0;

  int width = 0;
  int height = 0;
  int spacing = 0;
  int margin = 0;

  Flips? flips;

  Map<String?, dynamic>? properties = {};

  Image? _image;

  Image? get image {
    if (_image == null) {
      return tileset.image;
    }
    return _image;
  }

  // Optional X / Y locations for the tile.
  int x = 0 , y = 0;
  int px = 0, py = 0;

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

  Tile.emptyTile() : tileset = Tileset(0);

  Rectangle computeDrawRect() {
    if (_image != null) {
      return Rectangle(0, 0, _image!.width, _image!.height);
    }
    final tilesPerRow = tileset.image!.width ~/ (width + spacing);
    final row = tileId ~/ tilesPerRow;
    final column = tileId % tilesPerRow;
    final x = margin + (column * (width + spacing));
    final y = margin + (row * (height + spacing));
    return Rectangle(x, y, width + spacing, height + spacing);
  }
}
