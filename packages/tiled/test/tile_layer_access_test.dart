import 'dart:math';

import 'package:test/test.dart';
import 'package:tiled/tiled.dart';

void main() {
  group('TileLayer finite', () {
    late TileLayer layer;

    setUp(() {
      layer = TileLayer(
        name: 'finite',
        width: 2,
        height: 2,
        data: [1, 2, 3, 4],
      );
    });

    test('contentBounds matches width and height', () {
      expect(layer.contentBounds, const Rectangle(0, 0, 2, 2));
    });

    test('tileAt reads world coordinates', () {
      expect(layer.tileAt(0, 0)!.tile, 1);
      expect(layer.tileAt(1, 0)!.tile, 2);
      expect(layer.tileAt(0, 1)!.tile, 3);
      expect(layer.tileAt(1, 1)!.tile, 4);
      expect(layer.tileAt(-1, 0), isNull);
      expect(layer.tileAt(2, 0), isNull);
    });

    test('setTileAt updates an existing cell', () {
      expect(
        layer.setTileAt(1, 0, const Gid(9, Flips.defaults())),
        isTrue,
      );
      expect(layer.tileAt(1, 0)!.tile, 9);
      expect(
        layer.setTileAt(1, 0, const Gid(9, Flips.defaults())),
        isFalse,
      );
      expect(layer.setTileAt(5, 5, const Gid(1, Flips.defaults())), isFalse);
    });

    test('setTileAt treats flip changes as a change', () {
      const flippedH = Gid(
        1,
        Flips(
          horizontally: true,
          vertically: false,
          diagonally: false,
          antiDiagonally: false,
        ),
      );
      expect(layer.setTileAt(0, 0, flippedH), isTrue);
      expect(layer.tileAt(0, 0)!.tile, 1);
      expect(layer.tileAt(0, 0)!.flips.horizontally, isTrue);

      const flippedAnti = Gid(
        1,
        Flips(
          horizontally: true,
          vertically: false,
          diagonally: false,
          antiDiagonally: true,
        ),
      );
      expect(layer.setTileAt(0, 0, flippedAnti), isTrue);
      expect(layer.tileAt(0, 0)!.flips.antiDiagonally, isTrue);
    });

    test('forEachTile visits every cell', () {
      final visited = <(int, int, int)>[];
      layer.forEachTile((x, y, gid) {
        visited.add((x, y, gid.tile));
      });
      expect(visited, [(0, 0, 1), (1, 0, 2), (0, 1, 3), (1, 1, 4)]);
    });
  });

  group('TileLayer infinite chunks', () {
    late TileLayer layer;

    setUp(() {
      final data = List<int>.filled(16 * 16, 0);
      data[0] = 7;
      data[1] = 8;
      layer = TileLayer(
        name: 'infinite',
        width: 16,
        height: 16,
        chunks: [
          Chunk(data: data, x: -16, y: -8, width: 16, height: 16),
          Chunk(
            data: List<int>.filled(16 * 16, 0)..[0] = 3,
            x: 0,
            y: -8,
            width: 16,
            height: 16,
          ),
        ],
      );
    });

    test('contentBounds unions all chunks', () {
      expect(layer.contentBounds, const Rectangle(-16, -8, 32, 16));
    });

    test('tileAt uses chunk world coordinates', () {
      expect(layer.tileAt(-16, -8)!.tile, 7);
      expect(layer.tileAt(-15, -8)!.tile, 8);
      expect(layer.tileAt(0, -8)!.tile, 3);
      expect(layer.tileAt(0, 0)!.tile, 0);
      expect(layer.tileAt(-17, -8), isNull);
    });

    test('setTileAt updates a chunk cell', () {
      expect(
        layer.setTileAt(-16, -8, const Gid(11, Flips.defaults())),
        isTrue,
      );
      expect(layer.tileAt(-16, -8)!.tile, 11);
      expect(
        layer.setTileAt(32, 32, const Gid(1, Flips.defaults())),
        isFalse,
      );
    });

    test('forEachTile uses world coordinates', () {
      var found = 0;
      layer.forEachTile((x, y, gid) {
        if (gid.tile == 7) {
          expect((x, y), (-16, -8));
          found++;
        }
      });
      expect(found, 1);
    });
  });

  test('empty infinite layer has no contentBounds', () {
    final layer = TileLayer(
      name: 'empty',
      width: 16,
      height: 16,
      chunks: [],
    );
    expect(layer.tileData, isNull);
    expect(layer.contentBounds, isNull);
    expect(layer.tileAt(0, 0), isNull);
  });
}
