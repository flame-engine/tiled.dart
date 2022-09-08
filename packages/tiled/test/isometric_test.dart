import 'dart:io';

import 'package:test/test.dart';
import 'package:tiled/tiled.dart';

void main() {
  late TiledMap mapIso;

  setUp(() {
    return File('./test/fixtures/isometric_grass_and_water.tmx')
        .readAsString()
        .then((xml) {
      mapIso = TileMapParser.parseTmx(xml);
    });
  });

  group('Layer.tiles', () {
    late TileLayer layer;
    setUp(() {
      layer = mapIso.layerByName('Tile Layer 1') as TileLayer;
    });
    test('is the expected size of 25', () {
      expect(layer.tileData!.length, equals(25));
      layer.tileData!.forEach((row) {
        expect(row.length, equals(25));
      });
    });
  });
}
