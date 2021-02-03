import 'dart:io';

import 'package:test/test.dart';
import 'package:tiled/tiled.dart';

void main() {
  TiledMap mapIso;

  setUp(() {
    return File('./test/fixtures/isometric_grass_and_water.tmx').readAsString().then((xml) {
      mapIso = TileMapParser.parseTmx(xml);
    });
  });

  group('Layer.tiles', () {
    Layer layer;
    setUp(() {
      layer = mapIso.getLayerByName('Tile Layer 1');
    });
    test('is the expected size of 25', () {
      expect(layer.tileIDMatrix.length, equals(25));
      layer.tileIDMatrix.forEach((row) {
        expect(row.length, equals(25));
      });
    });
  });
}
