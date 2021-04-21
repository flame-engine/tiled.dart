import 'dart:io';

import 'package:test/test.dart';
import 'package:tiled/tiled.dart';

void main() {
  TiledMap mapIsoStaggeredJson;
  TiledMap mapIsoStaggeredTmx;

  setUp(() {
    return File('./test/fixtures/isometric_staggered_grass_and_water.json')
        .readAsString()
        .then((xml) {
      mapIsoStaggeredJson = TileMapParser.parseJson(xml);
    });
  });
  setUp(() {
    return File('./test/fixtures/isometric_staggered_grass_and_water.tmx')
        .readAsString()
        .then((xml) {
      mapIsoStaggeredTmx = TileMapParser.parseTmx(xml);
    });
  });

  group('Layer.tiles Json', () {
    Layer layer;
    setUp(() {
      layer = mapIsoStaggeredJson.getLayerByName('Tile Layer 1');
    });
    test('is expected to be infinite with chunks', () {
      expect(mapIsoStaggeredJson.infinite, isTrue);
      expect(layer.tileIDMatrix.length, equals(0));
      layer.tileIDMatrix.forEach((row) {
        expect(row.length, equals(0));
      });
      expect(layer.chunks.length, equals(8));
      expect(layer.chunks[0].tileIdMatrix.length, equals(16));
      layer.chunks[0].tileIdMatrix.forEach((row) {
        expect(row.length, equals(16));
      });
    });
  });

  group('Layer.tiles Tmx', () {
    Layer layer;
    setUp(() {
      layer = mapIsoStaggeredTmx.getLayerByName('Tile Layer 1');
    });
    test('is expected to be infinite with chunks', () {
      expect(mapIsoStaggeredTmx.infinite, isTrue);
      expect(layer.tileIDMatrix.length, equals(0));
      layer.tileIDMatrix.forEach((row) {
        expect(row.length, equals(0));
      });
      expect(layer.chunks.length, equals(8));
      expect(layer.chunks[0].tileIdMatrix.length, equals(16));
      layer.chunks[0].tileIdMatrix.forEach((row) {
        expect(row.length, equals(16));
      });
    });
  });
}
