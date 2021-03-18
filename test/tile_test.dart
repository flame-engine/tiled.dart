import 'package:test/test.dart';
import 'package:tiled/tiled.dart';

void main() {
  group('Tile.emptyTile()', () {
    test('creates a tile with GID = 0', () {
      final tile = Tile(0);
      expect(tile.localId, equals(0));
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
      final tile = Tile(0)..localId = 1;
      expect(tile.isEmpty, isFalse);
    });
  });

  test('Tile.properties is present', () {
    final tile = Tile(0);
    expect(tile.properties, isA<List>());
  });

  // TODO no default constructor on Tileset
  test('Tile.properties queries Tileset.tileProperties correctly', () {
    final tile = Tile(0)..properties.add(Property('tile_property', 'type', 'tile_value'));
    expect(tile.properties.first.name, equals('tile_property'));
    expect(tile.properties.first.type, equals('type'));
    expect(tile.properties.first.value, equals('tile_value'));
  });
}
