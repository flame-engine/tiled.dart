part of tiled;

class ObjectGroup {
  String name;
  String color;

  double opacity = 1.0;
  bool visible = true;

  TileMap map;

  Map<String, dynamic> properties = {};
  List<TmxObject> tmxObjects = [];

  ObjectGroup();


  @override
  String toString() {
    return 'ObjectGroup{name: $name, color: $color, opacity: $opacity, visible: $visible, map: ${map != null}, properties: $properties, tmxObjects: $tmxObjects}';
  }

  ObjectGroup.fromXML(XmlElement element) {
    if (element == null) {
      throw 'arg "element" cannot be null';
    }

    NodeDSL.on(element, (dsl) {
      name = dsl.strOr('name', name);
      color = dsl.strOr('color', color);
      opacity = dsl.doubleOr('opacity', opacity);
      visible = dsl.boolOr('visible', visible);
    });

    properties = TileMapParser._parsePropertiesFromElement(element);

    final objectNodes = element.children
        .whereType<XmlElement>()
        .where((node) => node.name.local == 'object');

    tmxObjects =
        objectNodes.map((objectNode) => TmxObject.fromXML(objectNode)).toList();
  }
}
