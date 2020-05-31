part of tiled;

class TileMapParser {
  TileMapParser();

  TileMap parse(String xml, {TsxProvider tsx}) {
    final xmlElement = _parseXml(xml).rootElement;

    if (xmlElement.name.local != 'map') {
      throw 'XML is not in TMX format';
    }

    final map = TileMap();
    map.tileWidth = int.parse(xmlElement.getAttribute('tilewidth'));
    map.tileHeight = int.parse(xmlElement.getAttribute('tileheight'));
    map.width = int.parse(xmlElement.getAttribute('width'));
    map.height = int.parse(xmlElement.getAttribute('height'));

    xmlElement.children.where((node) => node is XmlElement).cast<XmlElement>().forEach((XmlElement element) {
      switch (element.name.local) {
        case 'tileset':
          map.tilesets.add(Tileset.fromXML(element, tsx: tsx)..map = map);
          break;
        case 'layer':
          map.layers.add(Layer.fromXML(element)..map = map);
          break;
        case 'objectgroup':
          map.objectGroups.add(ObjectGroup.fromXML(element)..map = map);
          break;
      }
    });

    map.properties = TileMapParser._parsePropertiesFromElement(xmlElement);

    return map;
  }

  static Image _parseImage(XmlElement node) {
    return Image(
      node.getAttribute('source'),
      int.parse(node.getAttribute('width')),
      int.parse(node.getAttribute('height')),
    );
  }

  static Map<String, dynamic> _parsePropertiesFromElement(XmlElement element) {
    return TileMapParser._parseProperties(
      TileMapParser._getPropertyNodes(element),
    );
  }

  static Map<String, dynamic> _parseProperties(nodes) {
    final map = <String, dynamic>{};

    nodes.forEach((property) {
      final attrs = property.getAttribute;
      final value = attrs('value');
      final name = attrs('name');

      switch (attrs('type')) {
        case 'bool':
          map[name] = value == 'true';
          break;
        case 'int':
          map[name] = int.parse(value);
          break;
        case 'float':
          map[name] = double.parse(value);
          break;
        default: // for types file, color (returns ARGB), string
          map[name] = value;
          break;
      }
    });

    return map;
  }

  static Uint8List _decodeBase64(String input) {
    final sanitized = input.trim();
    return base64.decode(sanitized);
  }

  static Iterable<XmlElement> _getPropertyNodes(XmlElement node) {
    final propertyNode = node.children
        .where((node) => node is XmlElement)
        .cast<XmlElement>()
        .firstWhere((element) => element.name.local == 'properties', orElse: () => null);
    if (propertyNode == null) {
      return [];
    }
    return propertyNode.findElements('property');
  }

  static List<Point> _getPoints(XmlElement node) {
    // Format: points="0,0 -5,98 -49,42"
    final points = node.getAttribute('points').split(' ');
    return points.map((point) {
      final arr = point.split(',');
      final p = (str) => int.parse(str);
      return Point(p(arr.first), p(arr.last));
    }).toList();
  }

  static Uint8List Function(String) _getDecoder(String encodingType) {
    switch (encodingType) {
      case 'base64':
        return _decodeBase64;
      default:
        throw 'Incompatible encoding found: $encodingType';
    }
  }

  static List<int> Function(List<int>) _getDecompressor(String compressionType) {
    switch (compressionType) {
      case 'zlib':
        return ZLibDecoder().decodeBytes;
      case 'gzip':
        return GZipDecoder().decodeBytes;
      default:
        return null;
    }
  }
}
