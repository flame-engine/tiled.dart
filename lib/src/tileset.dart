part of tmx;

class Tileset {
  int firstgid;
  int width;
  int height;
  int spacing = 0;
  int margin = 0;
  String name;

  TileMap map;

  // List<Image> images = new List<Image>();
  Image image;
  Map<String, String> properties = new Map<String, String>();
  Map<int, Map<String, String>> tileProperties = new Map();
  Map<int, Image> tileImage = new Map();

  Tileset(this.firstgid);

  Tileset.fromXML(XmlElement element) {
    NodeDSL.on(element, (dsl) {
      firstgid = dsl.intOr('firstgid', firstgid);
      name = dsl.strOr('name', name);
      width = dsl.intOr('tilewidth', width);
      height = dsl.intOr('tileheight', height);
      spacing = dsl.intOr('spacing', spacing);
      margin = dsl.intOr('margin', margin);
    });

    image = findImage(element);

    properties = TileMapParser._parseProperties(
        TileMapParser._getPropertyNodes(element));

    // Parse tile properties, if present.
    element.findElements('tile').forEach((XmlElement tileNode) {
      int tileId = int.parse(tileNode.getAttribute('id'));
      int tileGid = tileId + firstgid;
      tileProperties[tileGid] = TileMapParser._parseProperties(
          TileMapParser._getPropertyNodes(tileNode));
      tileImage[tileGid] = findImage(tileNode);
    });
  }

  Image findImage(XmlElement element) {
    var list = element
        .findElements('image')
        .map((XmlElement node) => TileMapParser._parseImage(node));
    if (list.length > 0) {
      return list.first;
    }
    return null;
  }
}
