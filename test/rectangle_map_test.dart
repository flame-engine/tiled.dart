import 'dart:io';

import 'package:test/test.dart';
import 'package:tiled/tiled.dart';

void main() {
  late TiledMap map;

  setUp(() {
    return File('./test/fixtures/rectangle.tmx').readAsString().then((xml) {
      map = TileMapParser.parseTmx(xml);
    });
  });

  group('rectangle', () {
    test('rectangle map works from layer', () {
      final layer = map.layerByName('Tile Layer 1') as TileLayer;

      expect(layer.tileData![1].last.flips.vertically, equals(true));
      expect(layer.tileData![1].last.flips.diagonally, equals(true));

      List<int> getDataRow(int idx) {
        return layer.tileData![idx].map((e) => e.tile).toList();
      }

      expect(getDataRow(0), equals([1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]));
      expect(getDataRow(1), equals([0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1]));
      expect(getDataRow(2), equals([0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0]));
      expect(getDataRow(3), equals([0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0]));
      expect(getDataRow(4), equals([0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0]));
      expect(getDataRow(5), equals([0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0]));
      expect(getDataRow(6), equals([0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0]));
      expect(getDataRow(7), equals([0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0]));
      expect(getDataRow(8), equals([0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0]));
      expect(getDataRow(9), equals([0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0]));
    });

    test('rectangle map works from map', () {
      final layer = map.layers.first as TileLayer;
      expect(layer.tileData![0][0].tile, equals(1));
      expect(layer.tileData![1].last.flips.vertically, equals(true));
    });
  });
}
