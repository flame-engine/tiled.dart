import 'package:test/test.dart';
import 'package:tiled/tiled.dart';

void main() {
  //GID is 1-based
  group('Map.getTileByGID', () {
    late Tile tile;
    late TiledMap map;
    setUp(() {
      map = TiledMap(
        width: 24,
        height: 24,
        tileWidth: 8,
        tileHeight: 8,
        tilesets: [
          Tileset(
            name: 'TileSet_1',
            firstGid: 1,
            columns: 1,
            tileCount: 2,
            tiles: [
              Tile(localId: 0),
              Tile(localId: 1),
            ],
          ),
          Tileset(
            name: 'TileSet_2',
            firstGid: 3,
            columns: 1,
            tileCount: 2,
            tiles: [
              Tile(localId: 0),
              Tile(localId: 1),
            ],
          ),
          Tileset(
            name: 'TileSet_3',
            firstGid: 5,
            columns: 2,
            tileCount: 2,
            tiles: [
              Tile(localId: 0),
              Tile(
                localId: 2,
                properties: [
                  Property(
                    name: 'name',
                    type: PropertyType.string,
                    value: 'value',
                  ),
                ],
              ),
            ],
          ),
        ],
      );

      // TileSet_3 - Tile 2 => gid = 7
      tile = map.tileByGid(7);
    });

    test('returns an empty Tile if GID is 0', () {
      tile = map.tileByGid(0);
      expect(tile.isEmpty, isTrue);
    });

    group('returns a valid Tile for GID 4', () {
      test('with tileId = 2', () {
        expect(tile.localId, equals(2));
        expect(tile.properties.first.name, equals('name'));
      });
    });
  });

  group('Map.getTileByLocalID', () {
    late TiledMap map;
    final tileset = Tileset(
      name: 'Humans',
      firstGid: 1,
      columns: 32,
      tileCount: 64 * 32,
    );
    setUp(() {
      map = TiledMap(
        width: 100,
        height: 100,
        tileWidth: 16,
        tileHeight: 16,
        tilesets: [tileset],
      );
    });

    test('raises an ArgumentError if tileset is not present', () {
      expect(map.tileByGid(0).localId, equals(0));
    });

    group('returns a tile', () {
      late Tile tile;
      setUp(() => tile = map.tileByLocalId('Humans', 0));

      test('with the expected local tile ID', () {
        expect(tile.localId, equals(0));
      });
    });
  });

  group('Map.getTileByPhrase', () {
    late TiledMap map;
    final tileset = Tileset(
      name: 'Humans',
      firstGid: 1,
      columns: 32,
      tileCount: 64 * 32,
    );
    setUp(() {
      map = TiledMap(
        width: 100,
        height: 100,
        tileWidth: 16,
        tileHeight: 16,
        tilesets: [tileset],
      );
    });

    test('errors if tile phrase is not in the correct format', () {
      expect(
        () => map.tileByPhrase('Nonexistant Tile'),
        throwsArgumentError,
      );
    });

    test('errors if tileset is not present', () {
      expect(
        () => map.tileByPhrase('Nonexistant Tile|0'),
        throwsArgumentError,
      );
    });

    test('errors if tile id is not a parsable integer', () {
      expect(() => map.tileByPhrase('Humans|cupcake'), throwsArgumentError);
    });

    group('returns a tile', () {
      late Tile tile;
      setUp(() => tile = map.tileByPhrase('Humans|0'));

      test('with the expected local tile ID', () {
        expect(tile.localId, equals(0));
      });
    });
  });

  group('Map.getTileSet', () {
    late TiledMap map;
    final tileset = Tileset(
      name: 'Humans',
      firstGid: 1,
      columns: 32,
      tileCount: 64 * 32,
    );
    setUp(() {
      map = TiledMap(
        width: 100,
        height: 100,
        tileWidth: 16,
        tileHeight: 16,
        tilesets: [tileset],
      );
    });

    test('raises an ArgumentError if tileset is not present', () {
      expect(
        () => map.tilesetByName('Quackers'),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('returns the expected tileset', () {
      expect(map.tilesetByName('Humans'), equals(tileset));
    });
  });
}
