import 'dart:math';
import 'package:xml/xml.dart';
import 'tile_map_parser.dart';
import 'node_dsl.dart';

class TmxObject {
  String name = "";
  String type = "";

  double x = 0;
  double y = 0;
  double width = 0;
  double height = 0;
  double rotation = 0;
  int gid = 0;
  bool visible = true;

  bool isRectangle = false;
  bool isEllipse = false;
  bool isPolygon = false;
  bool isPolyline = false;

  List<Point> points = [];
  Map<String?, dynamic> properties = {};

  TmxObject.fromXML(XmlElement element) {
    if (element == null) {
      throw 'arg "element" cannot be null';
    }

    NodeDSL.on(element, (dsl) {
      name = dsl.strOr('name', name);
      type = dsl.strOr('type', type);
      x = dsl.doubleOr('x', x);
      y = dsl.doubleOr('y', y);
      width = dsl.doubleOr('width', width);
      height = dsl.doubleOr('height', height);
      rotation = dsl.doubleOr('rotation', rotation);
      gid = dsl.intOr('gid', gid);
      visible = dsl.boolOr('visible', visible);
    });

    properties = TileMapParser.parsePropertiesFromElement(element);

    // TODO: it is implied by the spec that there are only two children to
    // an object node: an optional <properties /> and an optional <ellipse />,
    // <polygon />, or <polyline />
    final Iterable<XmlElement> xmlElements = element.children
        .whereType<XmlElement>()
        .where((node) => node.name.local != 'properties');

    if (xmlElements.isNotEmpty) {
      final node = xmlElements.first;

      switch (node.name.local) {
        case 'ellipse':
          isEllipse = true;
          break;
        case 'polygon':
          isPolygon = true;
          points = TileMapParser.getPoints(node);
          break;
        case 'polyline':
          isPolyline = true;
          points = TileMapParser.getPoints(node);
          break;
      }
    } else {
      isRectangle = true;
    }
  }
}
