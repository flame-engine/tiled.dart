import 'package:xml/xml.dart';
import 'tile_map_parser.dart';
import 'tile_map.dart';
import 'image.dart';
import 'node_dsl.dart';
import 'tsx_provider.dart';

class Tileset {
  int firstgid = 0;
  int width = 0;
  int height = 0;
  int spacing = 0;
  int margin = 0;
  String name = "";
  String source = "";

  late TileMap map;

  late Image? image;
  late List<Image> images = [];
  Map<String?, dynamic> properties = {};
  Map<int, Map<String?, dynamic>> tileProperties = {};
  Map<int, Image?> tileImage = {};

  Tileset(this.firstgid);

  Tileset.fromXML(XmlElement element, {TsxProvider? tsx}) {
    _parseTilesetAttributes(element);
    element = _checkIfExtenalTsx(element, tsx);
    _parseTilesetAttributes(element);

    image = _findImage(element);
    _addImage(image);

    properties = TileMapParser.parsePropertiesFromElement(element);

    // Parse tile properties, if present.
    element.findElements('tile').forEach((XmlElement tileNode) {
      final tileId = int.parse(tileNode.getAttribute('id')!);
      final tileGid = tileId + firstgid;
      tileProperties[tileGid] =
          TileMapParser.parsePropertiesFromElement(tileNode);
      final image = _findImage(tileNode);
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

  XmlElement _checkIfExtenalTsx(XmlElement element, TsxProvider? tsx) {
    final filename = element.getAttribute('source');
    if (tsx != null && filename != null) {
      return TileMapParser.parseXml(tsx.getSource(filename)).rootElement;
    }
    return element;
  }

  Image? _findImage(XmlElement element) {
    final list = element
        .findElements('image')
        .map((XmlElement node) => TileMapParser.parseImage(node));
      if (list.isNotEmpty) {
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
