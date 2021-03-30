import 'dart:math';
import 'dart:convert';
import 'dart:typed_data';
import 'package:xml/xml.dart';
import 'package:archive/archive.dart';
import 'tile_map.dart';
import 'tileset.dart';
import 'image.dart';
import 'layer.dart';
import 'object_group.dart';
import 'tsx_provider.dart';

class TileMapParser {
  TileMapParser();
  static XmlDocument parseXml(String input) => XmlDocument.parse(input);
  TileMap parse(String xml, {TsxProvider? tsx}) {
    final xmlElement = parseXml(xml).rootElement;

    if (xmlElement.name.local != 'map') {
      throw 'XML is not in TMX format';
    }

    final map = TileMap();
    map.tileWidth = int.parse(xmlElement.getAttribute('tilewidth')!);
    map.tileHeight = int.parse(xmlElement.getAttribute('tileheight')!);
    map.width = int.parse(xmlElement.getAttribute('width')!);
    map.height = int.parse(xmlElement.getAttribute('height')!);

    xmlElement.children.whereType<XmlElement>().forEach((XmlElement element) {
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

    map.properties = TileMapParser.parsePropertiesFromElement(xmlElement);

    return map;
  }

  static Image parseImage(XmlElement node) {
    return Image(
      node.getAttribute('source')!,
      int.parse(node.getAttribute('width')!),
      int.parse(node.getAttribute('height')!),
    );
  }

  static Map<String?, dynamic> parsePropertiesFromElement(XmlElement element) {
    return TileMapParser._parseProperties(
      TileMapParser._getPropertyNodes(element),
    );
  }

  static Map<String?, dynamic> _parseProperties(nodes) {
    final map = <String?, dynamic>{};

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
    final XmlElement? propertyNode =
        node.children.whereType<XmlElement?>().firstWhere(
              (element) => element!.name.local == 'properties',
              orElse: () => null,
            );
    if (propertyNode == null) {
      return [];
    }
    return propertyNode.findElements('property');
  }

  static List<Point> getPoints(XmlElement node) {
    // Format: points="0,0 -5,98 -49,42"
    final points = node.getAttribute('points')!.split(' ');
    return points.map((point) {
      final arr = point.split(',');
      final p = (str) => double.parse(str);
      return Point(p(arr.first), p(arr.last));
    }).toList();
  }

  static Uint8List Function(String) getDecoder(String encodingType) {
    switch (encodingType) {
      case 'base64':
        return _decodeBase64;
      default:
        throw 'Incompatible encoding found: $encodingType';
    }
  }

  static List<int> Function(List<int>)? getDecompressor(
    String compressionType,
  ) {
    switch (compressionType) {
      case 'zlib':
        return const ZLibDecoder().decodeBytes;
      case 'gzip':
        return GZipDecoder().decodeBytes;
      default:
        return null;
    }
  }
}
