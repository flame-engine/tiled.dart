import 'package:xml/xml.dart';
import 'tile_map_parser.dart';
import 'tile_map.dart';
import 'tmx_object.dart';
import 'node_dsl.dart';

class ObjectGroup {
  String name = "";
  String color = "";

  double opacity = 1.0;
  bool visible = true;

  TileMap? map;

  Map<String?, dynamic> properties = {};
  List<TmxObject> tmxObjects = [];

  ObjectGroup.fromXML(XmlElement element) {
    NodeDSL.on(element, (dsl) {
      name = dsl.strOr('name', name);
      color = dsl.strOr('color', color);
      opacity = dsl.doubleOr('opacity', opacity);
      visible = dsl.boolOr('visible', visible);
    });
    properties = TileMapParser.parsePropertiesFromElement(element);

    final objectNodes = element.children
        .whereType<XmlElement>()
        .where((node) => node.name.local == 'object');

    tmxObjects =
        objectNodes.map((objectNode) => TmxObject.fromXML(objectNode)).toList();
  }
}
