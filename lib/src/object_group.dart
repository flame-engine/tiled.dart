part of tmx;

class ObjectGroup {
  String name;
  String color;

  double opacity = 1;
  bool visible = true;

  TileMap map;

  Map<String, String> properties = {};
  List<TmxObject> tmxObjects = [];

  ObjectGroup.fromXML(XmlElement element) {
    if (element == null) { throw 'arg "element" cannot be null'; }

    NodeDSL.on(element, (dsl) {
      name = dsl.strOr('name', name);
      color = dsl.strOr('color', color);
      opacity = dsl.doubleOr('opacity', opacity);
      visible = dsl.boolOr('visible', visible);
    });

    properties = TileMapParser._parseProperties(TileMapParser._getPropertyNodes(element));

    var objectNodes = element.children
        .where((node) => node is XmlElement)
        .where((node) => node.name.local == 'object');
    tmxObjects = objectNodes.map((objectNode) =>  new TmxObject.fromXML(objectNode));
  }
}
