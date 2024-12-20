// ignore_for_file: avoid_print

import 'dart:io';

import 'package:test/test.dart';
import 'package:tiled/tiled.dart';

void main() {
  group('Gid overflow tests', () {
    late TiledMap map;
    setUp(() {
      return File('./test/fixtures/testoverflow_csv.tmx').readAsString().then(
        (mapString) {
          return TiledMap.fromString(mapString, TsxProvider.parse).then(
            (parsedMap) {
              map = parsedMap;
            },
          );
        },
      );
    });

    test('Make sure gids are in a reasonable range', () {
      final layer = map.layers[0] as TileLayer;
      final data = layer.data!;
      for (var i = 0; i < data.length; i += 1) {
        final gidInt = data[i];
        final gid = Gid.fromInt(gidInt);
        if (gid.tile > 100) {
          final before = gidInt.toRadixString(2).padLeft(32, '0');
          final after = gid.tile.toRadixString(2).padLeft(32, '0');
          print('Before: $before');
          print(' After: $after');
          print('Tile Location: ${i % 16}, ${i ~/ 16}');
          fail('Tile id out of expected range.');
        }
      }
    });
  });
}
