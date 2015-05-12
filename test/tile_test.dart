import 'package:test/test.dart';
import 'package:tmx/tmx.dart';

main() {
  group('Tile.emptyTile()', () {
    test('creates a tile with GID = 0', () {
      var tile = new Tile.emptyTile();
      expect(tile.gid, equals(0));
    });

    test('creates a tile with a null tileset', () {
      var tile = new Tile.emptyTile();
      expect(tile.tileset, isNull);
    });
  });

  group('Tile.isEmpty', () {
    // My inability to easily create stub methods has resulted in
    // reusing the emptyTile() constructor.
    test('returns true if gid == 0', () {
      var tile = new Tile.emptyTile();
      expect(tile.isEmpty, isTrue);
    });

    test('returns false if gid != 0', () {
      var tile = new Tile.emptyTile()..gid = 1;
      expect(tile.isEmpty, isFalse);
    });
  });

  test('Tile.properties is present', () {
    var tile = new Tile.emptyTile();
    expect(tile.properties, new isInstanceOf<Map>());
  });

  test('Tile.properties queries Tileset.tileProperties correctly', () {
    var ts = new Tileset(1)..tileProperties[1] = { 'tile_property': 'tile_value' };

    var tile = new Tile(0, ts);

    expect(tile.properties, equals({ 'tile_property': 'tile_value' }));
  });

  test('Tile.properties is an empty map if Tileset.tileProperties is empty for this tile', () {
    var ts = new Tileset(1);
    var tile = new Tile(2, ts);
    expect(tile.properties, equals({}));
  });
}
