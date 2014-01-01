library tilemap;

import 'package:crypto/crypto.dart';
import 'package:xml/xml.dart';

part 'tilemap/parser.dart';
part 'tilemap/tiled_map.dart';
part 'tilemap/tileset.dart';
part 'tilemap/image.dart';
part 'tilemap/layer.dart';
part 'tilemap/tile.dart';

typedef List<int> DecompressionFunction(List<int> input);

class Tilemap {
  DecompressionFunction decompressor;
  Tilemap(this.decompressor);

  TiledMap loadMap(xml) {
    return new Parser(decompressor).parse(xml);
  }
}