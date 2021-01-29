import 'package:test/test.dart';
import 'package:tiled/tiled.dart';
import 'dart:io';

void main() {
  TiledMap map;

  setUp(() {
    return File('./test/fixtures/rectangle.tmx').readAsString().then((xml) {
      map = TileMapParser.parseTmx(xml);
    });
  });

  group('rectangle', () {
    test('rectangle map works from layer', () {
      final layer = map.getLayerByName('Tile Layer 1');

      expect(layer.tileIDMatrix[0], equals([1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]));
      expect(layer.tileIDMatrix[1], equals([0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1]));
      expect(layer.tileFlips[1].last.vertically, equals(true));
      expect(layer.tileFlips[1].last.diagonally, equals(true));
      expect(layer.tileIDMatrix[2], equals([0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0]));
      expect(layer.tileIDMatrix[3], equals([0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0]));
      expect(layer.tileIDMatrix[4], equals([0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0]));
      expect(layer.tileIDMatrix[5], equals([0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0]));
      expect(layer.tileIDMatrix[6], equals([0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0]));
      expect(layer.tileIDMatrix[7], equals([0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0]));
      expect(layer.tileIDMatrix[8], equals([0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0]));
      expect(layer.tileIDMatrix[9], equals([0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0]));
    });

    test('rectangle map works from map', () {
      final layer = map.layers.first;
      expect(layer.tileIDMatrix[0][0], equals(1));
      expect(layer.tileFlips[1].last.vertically, equals(true));
    });
  });
}
