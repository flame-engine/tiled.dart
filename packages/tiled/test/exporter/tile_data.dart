import 'dart:math';

import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';
import 'package:tiled/tiled.dart';

void main() {
  late List<int> testData;

  setUp(() {
    testData = List.generate(1000, (index) => Random().nextInt(1 << 32));
  });

  group('base64', () {
    void encodeDecode(List<int> testData, Compression? compression) {
      final encoder = ExportTileData(
        data: testData,
        encoding: FileEncoding.base64,
        compression: compression,
      );

      final encoded = encoder.encodeBase64();
      final unencoded = Layer.parseLayerData(
        JsonParser({'data': encoded}),
        FileEncoding.base64,
        compression,
      );

      expect(unencoded, orderedEquals(testData));
    }

    test('base64-uncompressed', () => encodeDecode(testData, null));
    test('base64-gzip', () => encodeDecode(testData, Compression.gzip));
    test('base64-zlib', () => encodeDecode(testData, Compression.zlib));
  });

  test('csv', () {
    final encoder = ExportTileData(
      data: testData,
      encoding: FileEncoding.csv,
      compression: null,
    );

    final encoded = encoder.encodeCsv();
    final unencoded = Layer.parseLayerData(
      JsonParser({'data': encoded}),
      FileEncoding.csv,
      null,
    );

    expect(unencoded, orderedEquals(testData));
  });
}
