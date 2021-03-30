import 'package:test/test.dart';
import 'package:tiled/tiled.dart';
import 'package:xml/xml.dart';
import 'dart:io';

void main() {
  late XmlElement xmlRoot;

  setUp(() {
    return File('./test/fixtures/rectangle.tmx').readAsString().then((xml) {
      xmlRoot = XmlDocument.parse(xml).rootElement;
    });
  });

  group('rectangle', () {
    test('rectangle map works from layer', () {
      final layerNode = xmlRoot.findAllElements('layer').first;
      final layer = Layer.fromXML(layerNode);

      expect(layer.tileMatrix[0], equals([1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]));
      expect(layer.tileMatrix[1], equals([0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1]));
      final flip = layer.tileFlips[1].last;
      expect(flip.vertically, equals(true));
      expect(flip.diagonally, equals(true));
      expect(layer.tileMatrix[2], equals([0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0]));
      expect(layer.tileMatrix[3], equals([0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0]));
      expect(layer.tileMatrix[4], equals([0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0]));
      expect(layer.tileMatrix[5], equals([0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0]));
      expect(layer.tileMatrix[6], equals([0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0]));
      expect(layer.tileMatrix[7], equals([0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0]));
      expect(layer.tileMatrix[8], equals([0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0]));
      expect(layer.tileMatrix[9], equals([0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0]));
    });

    test('rectangle map works from map', () {
      final TileMapParser parser = TileMapParser();
      final TileMap map = parser.parse(xmlRoot.toString());
      final layer = map.layers.first;

      expect(layer.tiles[0][0].tileId, equals(0));
      expect(layer.tiles[1].last.flips!.vertically, equals(true));
    });
  });
}
