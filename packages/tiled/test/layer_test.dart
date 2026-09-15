import 'dart:io';

import 'package:test/test.dart';
import 'package:tiled/tiled.dart';

void main() {
  late TiledMap mapTmx;
  late TiledMap mapTmxBase64Gzip;

  setUp(() {
    final f1 = File('./test/fixtures/test.tmx').readAsString().then((xml) {
      mapTmx = TiledMap.parseTmx(xml);
    });
    final f2 = File('./test/fixtures/test_base64_gzip.tmx').readAsString().then(
      (xml) {
        mapTmxBase64Gzip = TiledMap.parseTmx(xml);
      },
    );

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

    test('parsed colors', () {
      expect(layer.tintColorHex, equals('#ffaabb'));
      expect(
        layer.tintColor,
        equals(ColorData.hex(int.parse('0xffffaabb'))),
      );
    });
  });

  // JSON tile layers put GIDs in a `data` array (csv encoding by default).
  // That array used to be dropped during parse, leaving `data` and `tileData`
  // null.
  group('Layer.fromJSON', () {
    test('populates tile data from an uncompressed JSON array', () {
      final map = TiledMap.parseJson(
        File('./test/fixtures/json_csv_tilelayer.json').readAsStringSync(),
      );

      expect(map.layers, hasLength(1));

      final layer = map.layers.single as TileLayer;
      expect(layer.name, equals('Tile Layer 1'));
      expect(layer.width, equals(64));
      expect(layer.height, equals(6));
      expect(layer.encoding, equals(FileEncoding.csv));
      expect(layer.data, isNotNull);
      expect(layer.data, hasLength(64 * 6));
      expect(layer.tileData, isNotNull);
      expect(layer.tileData, hasLength(6));
      expect(layer.tileData!.first, hasLength(64));

      expect(layer.tileAt(46, 0)!.tile, equals(157));
      expect(layer.tileAt(50, 0)!.tile, equals(20));
      expect(layer.tileAt(0, 5)!.tile, equals(27));
      expect(layer.tileAt(63, 5)!.tile, equals(29));

      final flipped = layer.tileAt(13, 3)!;
      expect(flipped.tile, equals(104));
      expect(flipped.flips.horizontally, isTrue);
    });
  });
}
