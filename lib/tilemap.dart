library tilemap;

import 'package:crypto/crypto.dart';
import 'package:xml/xml.dart';
import 'package:archive/archive.dart';

part 'tilemap/parser.dart';
part 'tilemap/tiled_map.dart';
part 'tilemap/tileset.dart';
part 'tilemap/image.dart';
part 'tilemap/layer.dart';
part 'tilemap/tile.dart';

class Tilemap {
  Tilemap();

  TiledMap loadMap(xml) {
    return new Parser().parse(xml);
  }
}