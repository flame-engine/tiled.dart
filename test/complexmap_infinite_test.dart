import 'dart:io';

import 'package:test/test.dart';
import 'package:tiled/tiled.dart';

void main() {
  late TiledMap complexMapInfinite;

  setUp(() {
    return File('./test/fixtures/complexmap_infinite.tmx')
        .readAsString()
        .then((xml) {
      complexMapInfinite = TileMapParser.parseTmx(xml);
    });
  });

  group('Layer.tiles Json', () {
    late TileLayer layer;
    setUp(() {
      layer = complexMapInfinite.getLayerByName('top') as TileLayer;
    });
    test('is expected to be infinite with chunks', () {
      expect(complexMapInfinite.infinite, isTrue);
      expect(layer.tileData, isNull);
      expect(layer.chunks!.length, equals(9));
      expect(layer.chunks![0].tileData.length, equals(16));
      layer.chunks![0].tileData.forEach((row) {
        expect(row.length, equals(16));
      });
    });
  });
}
