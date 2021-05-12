import 'package:test/test.dart';
import 'package:tiled/tiled.dart';

/// Disabled this test, because of extensive use of default constructors.
/// Think of alternatives.
void main() {
  //GID is 1-based
  group('Map.getTileByGID', () {
    Tile tile;
    TiledMap map;
    setUp(() {
      map = TiledMap();
      final tileset1 = TileSet('TileSet_1', 1, 1, 2, [Tile(0), Tile(1)]);
      final tileset2 = TileSet('TileSet_2', 3, 1, 2, [Tile(0), Tile(1)]);
      final tileset3 = TileSet('TileSet_3', 5, 2, 2, [
        Tile(0),
        Tile(2)..properties.add(Property("name", "type", "value"))
      ]);

      map.tileSets.add(tileset1);
      map.tileSets.add(tileset2);
      map.tileSets.add(tileset3);

      // TileSet_3 - Tile 2 => gid = 7
      tile = map.getTileByGId(7);
    });

    test('returns an empty Tile if GID is 0', () {
      tile = map.getTileByGId(0);
      expect(tile.isEmpty, isTrue);
    });

    group('returns a valid Tile for GID 4', () {
      test('with tileId = 2', () {
        expect(tile.localId, equals(2));
        expect(tile.properties.first.name, equals("name"));
      });
    });
  });

  group('Map.getTileByLocalID', () {
    TiledMap map;
    final tileset = TileSet('Humans', 1, 32, 64 * 32, []);
    setUp(() {
      map = TiledMap();
      map.tileSets.add(tileset);
    });

    test('raises an ArgumentError if tileset is not present', () {
      expect(map.getTileByGId(0).localId, equals(0));
    });

    group('returns a tile', () {
      Tile tile;
      setUp(() => tile = map.getTileByLocalID('Humans', 0));

      test('with the expected local tile ID', () {
        expect(tile.localId, equals(0));
      });
    });
  });

  group('Map.getTileByPhrase', () {
    TiledMap map;
    final tileset = TileSet('Humans', 1, 32, 64 * 32, []);
    setUp(() {
      map = TiledMap();
      map.tileSets.add(tileset);
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
      Tile tile;
      setUp(() => tile = map.getTileByPhrase('Humans|0'));

      test('with the expected local tile ID', () {
        expect(tile.localId, equals(0));
      });
    });
  });

  group('Map.getTileSet', () {
    TiledMap map;
    final tileset = TileSet('Humans', 1, 32, 64 * 32, []);
    setUp(() {
      map = TiledMap();
      map.tileSets.add(tileset);
    });

    test('raises an ArgumentError if tileset is not present', () {
      expect(() => map.getTilesetByName('Quackers'),
          throwsA(isA<ArgumentError>()));
    });

    test('returns the expected tileset', () {
      expect(map.getTilesetByName('Humans'), equals(tileset));
    });
  });
}
