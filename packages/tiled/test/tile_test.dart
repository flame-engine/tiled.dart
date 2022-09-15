import 'package:test/test.dart';
import 'package:tiled/tiled.dart';

void main() {
  group('Tile.emptyTile()', () {
    test('creates a tile with GID = -1', () {
      final tile = Tile(localId: -1);
      expect(tile.localId, equals(-1));
    });
  });

  group('Tile.isEmpty', () {
    test('returns true if gid == -1', () {
      final tile = Tile(localId: -1);
      expect(tile.isEmpty, isTrue);
    });

    test('returns false if gid != -1', () {
      final tile = Tile(localId: -1)..localId = 0;
      expect(tile.isEmpty, isFalse);
    });
  });

  test('Tile.properties is present', () {
    final tile = Tile(localId: -1);
    expect(tile.properties, isA<Map<String, Property>>());
  });
}
