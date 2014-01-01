part of tmx;

class TileMapParser {
  TileMapParser();

  TileMap parse(String xml) {
    var xmlElement = XML.parse(xml);

    if (xmlElement.name != 'map') {
      throw 'XML is not in TMX format';
    }

    var map = new TileMap();
    map.tileWidth = int.parse(xmlElement.attributes['tilewidth']);
    map.tileHeight = int.parse(xmlElement.attributes['tileheight']);

    xmlElement.children.forEach( (XmlElement node) {
      switch(node.name) {
        case 'tileset':
          map.tilesets.add(_parseTileset(node)..map = map);
          break;
        case 'layer':
          map.layers.add(_parseLayer(node)..map = map);
          break;
      }
    });

    return map;
  }

  static Tileset _parseTileset(XmlElement node) {
    var attrs = node.attributes;
    var ts = new Tileset(int.parse(attrs['firstgid']))
      ..name = attrs['name']
      ..width = int.parse(attrs['tilewidth'])
      ..height = int.parse(attrs['tileheight'])
      ..images.addAll(node.query('image').map((XmlElement node)=> _parseImage(node)))
      ..properties = _parseProperties(node.query('properties').queryAll('property'));

    // Parse tile properties, if present.
    node.queryAll('tile').forEach((XmlElement tileNode) {
      int tileId = int.parse(tileNode.attributes['id']);
      int tileGid = tileId + ts.gid;
      ts.tileProperties[tileGid] = _parseProperties(tileNode.query('properties').queryAll('property'));
    });

    return ts;
  }

  static Image _parseImage(XmlElement node) {
    var attrs = node.attributes;
    return new Image(attrs['source'], int.parse(attrs['width']), int.parse(attrs['height']));
  }

  static Map<String, String> _parseProperties(nodes) {
    var map = new Map();
    nodes.forEach( (property) {
      var attrs = property.attributes;
      map[attrs['name']] = attrs['value'];
    });

    return map;
  }

  static Layer _parseLayer(XmlElement node) {
    var attrs = node.attributes;
    var layer = new Layer(attrs['name'], int.parse(attrs['width']), int.parse(attrs['height']));

    var dataElement = node.query('data')[0];
    if (dataElement is XmlElement) {
      if (dataElement.attributes['encoding'] != 'base64' || dataElement.attributes['compression'] != 'zlib') {
        throw 'Incompatible data node found';
      }
      var decodedString = _decodeBase64(dataElement.text);
      var inflatedString = new ZLibDecoder().decode(decodedString);

      layer.assembleTileMatrix(inflatedString);
    }
    return layer;
  }

  // The following helpers are a bit ham-handed; they're extracted into separate methods, even though they call
  // 3rd party packages, so that I can swap out replacement implementations as they grow and mature.

  // Manual test: CryptoUtils.base65StringToBytes has the same output as
  // Ruby's Base64.decode64. This function is working as expected.
  // Can't be tested; Dart won't let you test private methods (LOL)
  static List<int> _decodeBase64(var input) {
    return CryptoUtils.base64StringToBytes(input);
  }
}