import 'dart:io';
import 'dart:math';

import 'package:test/test.dart';
import 'package:tiled/tiled.dart';
import 'package:xml/xml.dart';

void main() {
  group('Tile.emptyTile()', () {
    test('creates a tile with GID = -1', () {
      final tile = Tile(localId: -1);
      expect(tile.localId, equals(-1));
    });
  });

  group('Tile.isEmpty', () {
    test('returns true if gid == -1', () {
      final tile = Tile(localId: -1);
      expect(tile.isEmpty, isTrue);
    });

    test('returns false if gid != -1', () {
      final tile = Tile(localId: -1)..localId = 0;
      expect(tile.isEmpty, isFalse);
    });
  });

  test('Tile.properties is present', () {
    final tile = Tile(localId: -1);
    expect(tile.properties, isA<CustomProperties>());
  });

  group(
    'Tile.imageRect',
    () {
      late Tileset tileset1;
      late Tileset tileset2;

      setUp(() {
        final f1 = File('./test/fixtures/multi_image_tileset.tsx')
            .readAsString()
            .then((xml) {
          final tilesetXml = XmlDocument.parse(xml).rootElement;
          tileset1 = Tileset.parse(XmlParser(tilesetXml));
        });

        final f2 = File('./test/fixtures/tileid_over_tilecount.tsx')
            .readAsString()
            .then((xml) {
          final tilesetXml = XmlDocument.parse(xml).rootElement;
          tileset2 = Tileset.parse(XmlParser(tilesetXml));
        });

        return Future.wait([f1, f2]);
      });

      test('with image collections', () {
        final tile1 = tileset1.tiles.firstWhere((t) => t.localId == 0);
        final tile2 = tileset1.tiles.firstWhere((t) => t.localId == 1);

        expect(tile1.imageRect, const Rectangle(64, 96, 32, 32));
        expect(tile2.imageRect, const Rectangle(0, 0, 20, 20));
      });

      test(
        'with single image',
        () {
          final tile1 = tileset2.tiles.firstWhere((t) => t.localId == 58);
          final tile2 = tileset2.tiles.firstWhere((t) => t.localId == 106);
          final tile3 = tileset2.tiles.firstWhere((t) => t.localId == 129);
          final tile4 = tileset2.tiles.firstWhere((t) => t.localId == 11);

          expect(tile1.imageRect, const Rectangle(112, 48, 16, 16));
          expect(tile2.imageRect, const Rectangle(64, 96, 16, 16));
          expect(tile3.imageRect, const Rectangle(160, 112, 16, 16));
          expect(tile4.imageRect, const Rectangle(176, 0, 16, 16));
        },
      );
    },
  );
}
