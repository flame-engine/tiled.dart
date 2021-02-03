import 'dart:io';

import 'package:test/test.dart';
import 'package:tiled/tiled.dart';

void main() {
  TiledMap complexMapInfinite;

  setUp(() {
    return File('./test/fixtures/complexmap_infinite.tmx').readAsString().then((xml) {
      complexMapInfinite = TileMapParser.parseTmx(xml);
    });
  });

  group('Layer.tiles Json', () {
    Layer layer;
    setUp(() {
      layer = complexMapInfinite.getLayerByName('top');
    });
    test('is expected to be infinite with chunks', () {
      expect(complexMapInfinite.infinite, isTrue);
      expect(layer.tileIDMatrix.length, equals(0));
      layer.tileIDMatrix.forEach((row) {
        expect(row.length, equals(0));
      });
      expect(layer.chunks.length, equals(9));
      expect(layer.chunks[0].tileIDMatrix.length, equals(16));
      layer.chunks[0].tileIDMatrix.forEach((row) {
        expect(row.length, equals(16));
      });

    });
  });
}
