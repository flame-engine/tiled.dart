part of tmx;

class TileMapParser {
  TileMapParser();

  TileMap parse(String xml) {
    var xmlElement = _parseXml(xml).rootElement;

    if (xmlElement.name.local != 'map') {
      throw 'XML is not in TMX format';
    }

    var map = new TileMap();
    map.tileWidth = int.parse(xmlElement.getAttribute('tilewidth'));
    map.tileHeight = int.parse(xmlElement.getAttribute('tileheight'));

    xmlElement.children.where((node) => node is XmlElement).forEach( (XmlElement node) {
      switch(node.name.local) {
        case 'tileset':
          map.tilesets.add(new Tileset.fromXML(node)..map = map);
          break;
        case 'layer':
          map.layers.add(new Layer.fromXML(node)..map = map);
          break;
        case 'objectgroup':
          map.objectGroups.add(new ObjectGroup.fromXML(node)..map = map);
          break;
      }
    });

    return map;
  }

  static Image _parseImage(XmlElement node) {
    var attrs = node.getAttribute;
    return new Image(attrs('source'), int.parse(attrs('width')), int.parse(attrs('height')));
  }

  static Map<String, String> _parseProperties(nodes) {
    var map = new Map();
    nodes.forEach( (property) {
      var attrs = property.getAttribute;
      map[attrs('name')] = attrs('value');
    });

    return map;
  }

  // The following helpers are a bit ham-handed; they're extracted into separate methods, even though they call
  // 3rd party packages, so that I can swap out replacement implementations as they grow and mature.

  // Manual test: CryptoUtils.base65StringToBytes has the same output as
  // Ruby's Base64.decode64. This function is working as expected.
  // Can't be tested; Dart won't let you test private methods (LOL)
  static List<int> _decodeBase64(String input) {
    var sanitized = input.trim();
    return CryptoUtils.base64StringToBytes(sanitized);
  }

  static Iterable<XmlElement> _getPropertyNodes(XmlElement node) {
    var propertyNode = node.children
        .where((node) => node is XmlElement)
        .firstWhere((node) => node.name.local == 'properties', orElse: () => null);
    if (propertyNode == null) { return []; }
    return propertyNode.findElements('property');
  }

  static List<Point> _getPoints(XmlElement node) {
    // Format: points="0,0 -5,98 -49,42"
    var points = node.getAttribute('points').split(' ');
    return points.map((point) {
      var arr = point.split(',');
      var p = (str) => int.parse(str);
      return new Point(p(arr.first), p(arr.last));
    }).toList();
  }

  static Function _getDecoder(String encodingType) {
    switch(encodingType) {
      case 'base64':
        return _decodeBase64;
      default:
        throw 'Incompatible encoding found: $encodingType';
    }

  }

  static Function _getDecompressor(String compressionType) {
    switch(compressionType) {
      case 'zlib':
        return new ZLibDecoder().decodeBytes;
      case 'gzip':
        return new GZipDecoder().decodeBytes;
      default:
        throw 'Incompatible compression type found: $compressionType';
    }
  }
}
