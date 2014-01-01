import 'package:unittest/unittest.dart';
import 'package:citadel/tilemap.dart';

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
}