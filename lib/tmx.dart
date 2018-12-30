library tmx;

import 'dart:math';

import 'dart:convert';
import 'package:xml/xml.dart';
import 'package:archive/archive.dart';

part 'src/tile_map_parser.dart';
part 'src/tile_map.dart';
part 'src/tileset.dart';
part 'src/image.dart';
part 'src/layer.dart';
part 'src/tile.dart';
part 'src/object_group.dart';
part 'src/tmx_object.dart';
part 'src/node_dsl.dart';

XmlDocument _parseXml(String input) => parse(input);
