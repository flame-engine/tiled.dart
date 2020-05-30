part of tiled;

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
  List<Image> images = new List<Image>();
  Map<String, dynamic> properties = {};
  Map<int, Map<String, dynamic>> tileProperties = {};
  Map<int, Image> tileImage = new Map();

  Tileset(this.firstgid);

  Tileset.fromXML(XmlElement element, {TsxProvider tsx}) {
    _parseTilesetAttributes(element);
    element = _checkIfExtenalTsx(element, tsx);
    _parseTilesetAttributes(element);

    image = _findImage(element);
    _addImage(image);

    properties = TileMapParser._parsePropertiesFromElement(element);

    // Parse tile properties, if present.
    element.findElements('tile').forEach((XmlElement tileNode) {
      int tileId = int.parse(tileNode.getAttribute('id'));
      int tileGid = tileId + firstgid;
      tileProperties[tileGid] = TileMapParser._parsePropertiesFromElement(tileNode);
      var image = _findImage(tileNode);
      tileImage[tileGid] = image;
      _addImage(image);
    });
  }

  void _parseTilesetAttributes(XmlElement element) {
    NodeDSL.on(element, (dsl) {
      firstgid = dsl.intOr('firstgid', firstgid);
      name = dsl.strOr('name', name);
      width = dsl.intOr('tilewidth', width);
      height = dsl.intOr('tileheight', height);
      spacing = dsl.intOr('spacing', spacing);
      margin = dsl.intOr('margin', margin);
      source = dsl.strOr('source', source);
    });
  }

  _checkIfExtenalTsx(XmlElement element, TsxProvider tsx) {
    var filename = element.getAttribute('source');
    if (tsx != null && filename != null) {
      return _parseXml(tsx.getSource(filename)).rootElement;
    }
    return element;
  }

  Image _findImage(XmlElement element) {
    var list = element.findElements('image').map((XmlElement node) => TileMapParser._parseImage(node));
    if (list.length > 0) {
      return list.first;
    }
    return null;
  }

  void _addImage(image) {
    if (image != null) {
      images.add(image);
    }
  }
}
