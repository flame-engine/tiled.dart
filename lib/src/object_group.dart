part of tiled;

class ObjectGroup {
  String? name;
  String? color;

  double? opacity = 1.0;
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

    properties = TileMapParser._parsePropertiesFromElement(element);

    final Iterable<XmlElement> objectNodes = element.children
        .whereType<XmlElement>()
        .where((node) => node.name.local == 'object');

    tmxObjects =
        objectNodes.map((objectNode) => TmxObject.fromXML(objectNode)).toList();
  }
}
