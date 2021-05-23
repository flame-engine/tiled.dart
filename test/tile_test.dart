import 'package:test/test.dart';
import 'package:tiled/tiled.dart';

void main() {
  group('Tile.emptyTile()', () {
    test('creates a tile with GID = 0', () {
      final tile = Tile(localId: 0);
      expect(tile.localId, equals(0));
    });
  });

  group('Tile.isEmpty', () {
    test('returns true if gid == 0', () {
      final tile = Tile(localId: 0);
      expect(tile.isEmpty, isTrue);
    });

    test('returns false if gid != 0', () {
      final tile = Tile(localId: 0)..localId = 1;
      expect(tile.isEmpty, isFalse);
    });
  });

  test('Tile.properties is present', () {
    final tile = Tile(localId: 0);
    expect(tile.properties, isA<List>());
  });
}
