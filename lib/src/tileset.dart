part of tmx;

class Tileset {
  int firstgid;
  int width;
  int height;
  int spacing = 0;
  int margin = 0;
  String name;
  String source;

  TileMap map;

  Image image;
  Map<String, String> properties = new Map<String, String>();
  Map<int, Map<String, String>> tileProperties = new Map();
  Map<int, Image> tileImage = new Map();

  Tileset(this.firstgid);

  Tileset.fromXML(XmlElement element, {TsxProvider tsx}) {
    element = _findTilesetElement(element, tsx);

    NodeDSL.on(element, (dsl) {
      firstgid = dsl.intOr('firstgid', firstgid);
      name = dsl.strOr('name', name);
      width = dsl.intOr('tilewidth', width);
      height = dsl.intOr('tileheight', height);
      spacing = dsl.intOr('spacing', spacing);
      margin = dsl.intOr('margin', margin);
      source = dsl.strOr('source', source);
    });

    image = _findImage(element);

    properties = TileMapParser._parseProperties(
        TileMapParser._getPropertyNodes(element));

    // Parse tile properties, if present.
    element.findElements('tile').forEach((XmlElement tileNode) {
      int tileId = int.parse(tileNode.getAttribute('id'));
      int tileGid = tileId + firstgid;
      tileProperties[tileGid] = TileMapParser._parseProperties(
          TileMapParser._getPropertyNodes(tileNode));
      tileImage[tileGid] = _findImage(tileNode);
    });
  }

  _findTilesetElement(XmlElement element, TsxProvider tsx) {
    var filename = element.getAttribute('source');
    if (tsx != null && filename != null) {
      return _parseXml(tsx.getSource(filename)).rootElement;
    }
    return element;
  }

  Image _findImage(XmlElement element) {
    var list = element
        .findElements('image')
        .map((XmlElement node) => TileMapParser._parseImage(node));
    if (list.length > 0) {
      return list.first;
    }
    return null;
  }
}
