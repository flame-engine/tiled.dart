library tilemap;

import 'package:crypto/crypto.dart';
import 'package:xml/xml.dart';
import 'package:archive/archive.dart';

part 'tilemap/tile_map_parser.dart';
part 'tilemap/tile_map.dart';
part 'tilemap/tileset.dart';
part 'tilemap/image.dart';
part 'tilemap/layer.dart';
part 'tilemap/tile.dart';

class Tilemap {
  Tilemap();

  TileMap loadMap(xml) {
    return new TileMapParser().parse(xml);
  }
}