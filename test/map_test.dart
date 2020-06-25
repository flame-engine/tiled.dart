import 'package:test/test.dart';
import 'package:tiled/tiled.dart' as tiled;

void main() {
  // GID is 1-based
  group('Map.getTileByGID', () {
    tiled.Tile tile;
    tiled.TileMap map;
    setUp(() {
      map = tiled.TileMap();
      // 2 tilesets:
      // 1 tileset with 1 tile
      // 1 tileset with 3 tiles
      // 1 tileset with 1 tile
      map.tilesets.add(tiled.Tileset(1));
      map.tilesets.add(tiled.Tileset(2)
        ..height = 64
        ..width = 32);
      map.tilesets.add(tiled.Tileset(5));
      // The last tile of the second tileset has a gid = 4
      tile = map.getTileByGID(4);
    });

    test('returns an empty Tile if GID is 0', () {
      tile = map.getTileByGID(0);
      expect(tile.isEmpty, isTrue);
    });

    group('returns a valid Tile for GID 4', () {
      test('with tileId = 2', () {
        expect(tile.tileId, equals(2));
      });

      test('with width = 32', () {
        expect(tile.width, equals(32));
      });

      test('with height = 64', () {
        expect(tile.height, equals(64));
      });

      test('with globalId = 4', () {
        expect(tile.gid, equals(4));
      });

      test('with x = null', () => expect(tile.x, isNull));
      test('with y = null', () => expect(tile.y, isNull));
    });
  });

  group('Map.getTileByLocalID', () {
    tiled.TileMap map;
    final tileset = tiled.Tileset(1)
      ..name = 'Humans'
      ..height = 64
      ..width = 32;
    setUp(() {
      map = tiled.TileMap();
      map.tilesets.add(tileset);
    });

    test('raises an ArgumentError if tileset is not present', () {
      expect(() => map.getTileByLocalID('Nonexistant Tile', 0),
          throwsA(isA<ArgumentError>()));
    });

    group('returns a tile', () {
      tiled.Tile tile;
      setUp(() => tile = map.getTileByLocalID('Humans', 0));

      test('with the expected Tileset',
          () => expect(tile.tileset, equals(tileset)));
      test('with the expected local tile ID',
          () => expect(tile.tileId, equals(0)));
    });
  });

  group('Map.getTileByPhrase', () {
    tiled.TileMap map;
    final tileset = tiled.Tileset(1)
      ..name = 'Humans'
      ..height = 64
      ..width = 32;
    setUp(() {
      map = tiled.TileMap();
      map.tilesets.add(tileset);
    });

    test('errors if tile phrase is not in the correct format', () {
      expect(
        () => map.getTileByPhrase('Nonexistant Tile'),
        throwsArgumentError,
      );
    });

    test('errors if tileset is not present', () {
      expect(
        () => map.getTileByPhrase('Nonexistant Tile|0'),
        throwsArgumentError,
      );
    });

    test('errors if tile id is not a parsable integer', () {
      expect(() => map.getTileByPhrase('Humans|cupcake'), throwsArgumentError);
    });

    group('returns a tile', () {
      tiled.Tile tile;
      setUp(() => tile = map.getTileByPhrase('Humans|0'));

      test('with the expected Tileset', () {
        expect(tile.tileset, equals(tileset));
      });

      test('with the expected local tile ID', () {
        expect(tile.tileId, equals(0));
      });
    });
  });

  group('Map.getTileset', () {
    tiled.TileMap map;
    final tileset = tiled.Tileset(1)..name = 'Humans';
    setUp(() {
      map = tiled.TileMap();
      map.tilesets.add(tileset);
    });

    test('raises an ArgumentError if tileset is not present', () {
      expect(() => map.getTileset('Quackers'), throwsA(isA<ArgumentError>()));
    });

    test('returns the expected tileset', () {
      expect(map.getTileset('Humans'), equals(tileset));
    });
  });
}
