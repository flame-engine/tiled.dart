import 'package:test/test.dart';
import 'package:tiled/tiled.dart';

void main() {
  group('Tile.emptyTile()', () {
    test('creates a tile with GID = 0', () {
      final tile = Tile(0);
      expect(tile.gid, equals(0));
    });
  });

  group('Tile.isEmpty', () {
    // My inability to easily create stub methods has resulted in
    // reusing the emptyTile() constructor.
    test('returns true if gid == 0', () {
      final tile = Tile(0);
      expect(tile.isEmpty, isTrue);
    });

    test('returns false if gid != 0', () {
      final tile = Tile(0)..gid = 1;
      expect(tile.isEmpty, isFalse);
    });
  });

  test('Tile.properties is present', () {
    final tile = Tile(0);
    expect(tile.properties, isA<List>());
  });

  // TODO no default constructor on Tileset
  // test('Tile.properties queries Tileset.tileProperties correctly', () {
  //   final ts = Tileset(1)..tileProperties[1] = {'tile_property': 'tile_value'};
  //   final tile = Tile(0, ts);
  //
  //   expect(tile.properties, equals({'tile_property': 'tile_value'}));
  // });
  //
  // test('Tile.properties matches if Tileset.tileProperties if empty', () {
  //   final ts = Tileset(1);
  //   final tile = Tile(2, ts);
  //   expect(tile.properties, equals({}));
  // });
}
