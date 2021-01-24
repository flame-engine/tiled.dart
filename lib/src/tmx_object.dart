part of tiled;

class TmxObject {
  String name;
  String type;

  double x;
  double y;
  double width = 0;
  double height = 0;
  double rotation = 0;
  int gid;
  bool visible = true;

  bool isRectangle = false;
  bool isEllipse = false;
  bool isPolygon = false;
  bool isPolyline = false;

  List<Point> points = [];
  Map<String, dynamic> properties = {};

  TmxObject();

  @override
  String toString() {
    return 'TmxObject{name: $name, type: $type, x: $x, y: $y, width: $width, height: $height, rotation: $rotation, gid: $gid, visible: $visible, isRectangle: $isRectangle, isEllipse: $isEllipse, isPolygon: $isPolygon, isPolyline: $isPolyline, points: $points, properties: $properties}';
  }

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

    properties = TileMapParser._parsePropertiesFromElement(element);

    // TODO: it is implied by the spec that there are only two children to
    // an object node: an optional <properties /> and an optional <ellipse />,
    // <polygon />, or <polyline />
    final xmlElements = element.children
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
          points = TileMapParser._getPoints(node);
          break;
        case 'polyline':
          isPolyline = true;
          points = TileMapParser._getPoints(node);
          break;
      }
    } else {
      isRectangle = true;
    }
  }
}
