import 'dart:io';

import 'package:test/test.dart';
import 'package:tiled/tiled.dart';

void main() {
  late TiledMap mapIsoStaggeredJson;
  late TiledMap mapIsoStaggeredTmx;

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
    late TileLayer layer;
    setUp(() {
      layer = mapIsoStaggeredJson.layerByName('Tile Layer 1') as TileLayer;
    });
    test('is expected to be infinite with chunks', () {
      expect(mapIsoStaggeredJson.infinite, isTrue);
      expect(layer.tileData, isNull);
      expect(layer.chunks!.length, equals(8));
      expect(layer.chunks![0].tileData.length, equals(16));
      layer.chunks![0].tileData.forEach((row) {
        expect(row.length, equals(16));
      });
    });
  });

  group('Layer.tiles Tmx', () {
    late TileLayer layer;
    setUp(() {
      layer = mapIsoStaggeredTmx.layerByName('Tile Layer 1') as TileLayer;
    });
    test('is expected to be infinite with chunks', () {
      expect(mapIsoStaggeredTmx.infinite, isTrue);
      expect(layer.tileData, isNull);
      expect(layer.chunks!.length, equals(8));
      expect(layer.chunks![0].tileData.length, equals(16));
      layer.chunks![0].tileData.forEach((row) {
        expect(row.length, equals(16));
      });
    });
  });
}
