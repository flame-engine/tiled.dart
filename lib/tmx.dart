library tmx;

import 'package:crypto/crypto.dart';
import 'package:xml/xml.dart';
import 'package:archive/archive.dart';

part 'src/tile_map_parser.dart';
part 'src/tile_map.dart';
part 'src/tileset.dart';
part 'src/image.dart';
part 'src/layer.dart';
part 'src/tile.dart';

XmlDocument _parseXml(String input) => parse(input);