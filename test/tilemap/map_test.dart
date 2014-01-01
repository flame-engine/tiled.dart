import 'package:unittest/unittest.dart';
import 'package:citadel/tilemap.dart' as tmx;

main() {
  // GID is 1-based
  group('Map.getTileByGID', () {
    tmx.Tile tile;
    tmx.TiledMap map;
    setUp(() {
      map = new tmx.TiledMap();
      // 2 tilesets:
      // 1 tileset with 1 tile
      // 1 tileset with 3 tiles
      // 1 tileset with 1 tile
      map.tilesets.add(new tmx.Tileset(1));
      map.tilesets.add(new tmx.Tileset(2)..height = 64..width = 32);
      map.tilesets.add(new tmx.Tileset(5));
      // The last tile of the second tileset has a gid = 4
      tile =  map.getTileByGID(4);
    });

    test('returns an empty Tile if GID is 0', () {
      tile = map.getTileByGID(0);
      expect(tile.isEmpty, isTrue);
    });

    group('returns a valid Tile for GID 4', () {
      test('with tileId = 3', () {
        expect(tile.tileId, equals(3));
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

      test('with x = null', ()=> expect(tile.x, isNull));
      test('with y = null', ()=> expect(tile.y, isNull));
    });
  });

  group('Map.getTileset', () {
    tmx.TiledMap map;
    tmx.Tileset tileset = new tmx.Tileset(1)..name = 'Humans';
    setUp(() {
      map = new tmx.TiledMap();
      map.tilesets.add(tileset);
    });

    test('raises an exception if tileset is not present', () {
      expect( () => map.getTileset('Quackers'),
          throwsA(new isInstanceOf<StateError>()));
    });

    test('returns the expected tileset', () {
      expect(map.getTileset('Humans'), equals(tileset));
    });
  });
}