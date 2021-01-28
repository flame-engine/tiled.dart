import 'dart:async';
import 'dart:io';

import 'package:test/test.dart';
import 'package:tiled/tiled.dart';

void main() {
  TiledMap mapTmx;
  TiledMap mapTmxBase64Gzip;

  setUp(() {
    final f1 = File('./test/fixtures/test.tmx').readAsString().then((xml) {
      mapTmx = TileMapParser.parseTmx(xml);
    });
    final f2 =
        File('./test/fixtures/test_base64_gzip.tmx').readAsString().then((xml) {
          mapTmxBase64Gzip = TileMapParser.parseTmx(xml);
    });

    return Future.wait([f1, f2]);
  });

  group('Layer.fromXML', () {
    test('supports gzip', () {
      final layer = mapTmx.layers.where((element) => element.type == 'tilelayer').first;

      expect(layer.tileIDMatrix[0], equals([1, 0, 0, 0, 0, 0, 0, 0, 0, 0]));
      expect(layer.tileIDMatrix[1], equals([0, 1, 0, 0, 0, 0, 0, 0, 0, 0]));
      expect(layer.tileIDMatrix[2], equals([0, 0, 1, 0, 0, 0, 0, 0, 0, 0]));
      expect(layer.tileIDMatrix[3], equals([0, 0, 0, 1, 0, 0, 0, 0, 0, 0]));
      expect(layer.tileIDMatrix[4], equals([0, 0, 0, 0, 1, 0, 0, 0, 0, 0]));
      expect(layer.tileIDMatrix[5], equals([0, 0, 0, 0, 0, 1, 0, 0, 0, 0]));
      expect(layer.tileIDMatrix[6], equals([0, 0, 0, 0, 0, 0, 1, 0, 0, 0]));
      expect(layer.tileIDMatrix[7], equals([0, 0, 0, 0, 0, 0, 0, 1, 0, 0]));
      expect(layer.tileIDMatrix[8], equals([0, 0, 0, 0, 0, 0, 0, 0, 1, 0]));
      expect(layer.tileIDMatrix[9], equals([0, 0, 0, 0, 0, 0, 0, 0, 0, 1]));
    });
    test('supports zlib', () {
      final layer = mapTmxBase64Gzip.layers.where((element) => element.type == 'tilelayer').first;

      expect(layer.tileIDMatrix[0], equals([1, 0, 0, 0, 0, 0, 0, 0, 0, 0]));
      expect(layer.tileIDMatrix[1], equals([0, 1, 0, 0, 0, 0, 0, 0, 0, 0]));
      expect(layer.tileIDMatrix[2], equals([0, 0, 1, 0, 0, 0, 0, 0, 0, 0]));
      expect(layer.tileIDMatrix[3], equals([0, 0, 0, 1, 0, 0, 0, 0, 0, 0]));
      expect(layer.tileIDMatrix[4], equals([0, 0, 0, 0, 1, 0, 0, 0, 0, 0]));
      expect(layer.tileIDMatrix[5], equals([0, 0, 0, 0, 0, 1, 0, 0, 0, 0]));
      expect(layer.tileIDMatrix[6], equals([0, 0, 0, 0, 0, 0, 1, 0, 0, 0]));
      expect(layer.tileIDMatrix[7], equals([0, 0, 0, 0, 0, 0, 0, 1, 0, 0]));
      expect(layer.tileIDMatrix[8], equals([0, 0, 0, 0, 0, 0, 0, 0, 1, 0]));
      expect(layer.tileIDMatrix[9], equals([0, 0, 0, 0, 0, 0, 0, 0, 0, 1]));
    });
  });

  group('Layer.tiles', () {
    Layer layer;

    setUp(() {
      layer = mapTmx.layers.where((element) => element.type == 'tilelayer').first;
    });

    test('is the expected size of 100', () {
      expect(layer.tileIDMatrix.length, equals(10));
      layer.tileIDMatrix.forEach((row) {
        expect(row.length, equals(10));
      });
    });
  });
}
