import 'dart:async';
import 'dart:io';

import 'package:test/test.dart';
import 'package:tiled/tiled.dart';

void main() {
  late TiledMap mapTmx;
  late TiledMap mapTmxBase64Gzip;

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
      final layer = mapTmx.layers.whereType<TileLayer>().first;
      List<int> getDataRow(int idx) {
        return layer.tileData![idx].map((e) => e.tile).toList();
      }

      expect(getDataRow(0), equals([1, 0, 0, 0, 0, 0, 0, 0, 0, 0]));
      expect(getDataRow(1), equals([0, 1, 0, 0, 0, 0, 0, 0, 0, 0]));
      expect(getDataRow(2), equals([0, 0, 1, 0, 0, 0, 0, 0, 0, 0]));
      expect(getDataRow(3), equals([0, 0, 0, 1, 0, 0, 0, 0, 0, 0]));
      expect(getDataRow(4), equals([0, 0, 0, 0, 1, 0, 0, 0, 0, 0]));
      expect(getDataRow(5), equals([0, 0, 0, 0, 0, 1, 0, 0, 0, 0]));
      expect(getDataRow(6), equals([0, 0, 0, 0, 0, 0, 1, 0, 0, 0]));
      expect(getDataRow(7), equals([0, 0, 0, 0, 0, 0, 0, 1, 0, 0]));
      expect(getDataRow(8), equals([0, 0, 0, 0, 0, 0, 0, 0, 1, 0]));
      expect(getDataRow(9), equals([0, 0, 0, 0, 0, 0, 0, 0, 0, 1]));
    });
    test('supports zlib', () {
      final layer = mapTmxBase64Gzip.layers.whereType<TileLayer>().first;
      List<int> getDataRow(int idx) {
        return layer.tileData![idx].map((e) => e.tile).toList();
      }

      expect(getDataRow(0), equals([1, 0, 0, 0, 0, 0, 0, 0, 0, 0]));
      expect(getDataRow(1), equals([0, 1, 0, 0, 0, 0, 0, 0, 0, 0]));
      expect(getDataRow(2), equals([0, 0, 1, 0, 0, 0, 0, 0, 0, 0]));
      expect(getDataRow(3), equals([0, 0, 0, 1, 0, 0, 0, 0, 0, 0]));
      expect(getDataRow(4), equals([0, 0, 0, 0, 1, 0, 0, 0, 0, 0]));
      expect(getDataRow(5), equals([0, 0, 0, 0, 0, 1, 0, 0, 0, 0]));
      expect(getDataRow(6), equals([0, 0, 0, 0, 0, 0, 1, 0, 0, 0]));
      expect(getDataRow(7), equals([0, 0, 0, 0, 0, 0, 0, 1, 0, 0]));
      expect(getDataRow(8), equals([0, 0, 0, 0, 0, 0, 0, 0, 1, 0]));
      expect(getDataRow(9), equals([0, 0, 0, 0, 0, 0, 0, 0, 0, 1]));
    });
  });

  group('Layer.tiles', () {
    late TileLayer layer;

    setUp(() {
      layer = mapTmx.layers.whereType<TileLayer>().first;
    });

    test('is the expected size of 100', () {
      expect(layer.tileData!.length, equals(10));
      layer.tileData!.forEach((row) {
        expect(row.length, equals(10));
      });
    });
  });
}
