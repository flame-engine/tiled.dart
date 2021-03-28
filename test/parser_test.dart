import 'dart:math';

import 'package:test/test.dart';
import 'package:tiled/tiled.dart';
import 'dart:io';

void main() {
  final parser = TileMapParser();
  TileMap? map;
  setUp(() {
    return File('./test/fixtures/test.tmx').readAsString().then((xml) {
      map = parser.parse(xml);
    });
  });

  test('Parser.parse raises an error when the XML is not in TMX format', () {
    const wrongXml = '<xml></xml>';
    expect(() => parser.parse(wrongXml), throwsA('XML is not in TMX format'));
  });

  group('Parser.parse returns a populated Map that', () {
    test('has its tileWidth = 32', () => expect(map!.tileWidth, equals(32)));
    test('has its tileHeight = 32', () => expect(map!.tileHeight, equals(32)));
  });

  group('Parser.parse populates Map with tilesets', () {
    test('and Map.tilesets is the correct size', () {
      expect(map!.tilesets.length, equals(1));
    });

    group('and the first tileset', () {
      late Tileset tileset;
      setUp(() => tileset = map!.tilesets[0]);

      test('has its firstgid = 1', () => expect(tileset.firstgid, equals(1)));
      test('has its name = "basketball"', () {
        expect(tileset.name, equals('basketball'));
      });

      test('has its tilewidth = 32', () => expect(tileset.width, equals(32)));
      test('has its tileheight = 32', () => expect(tileset.height, equals(32)));
      test('has its map = map', () => expect(tileset.map, equals(map)));
      test('has its image', () => expect(tileset.image, isNotNull));

      group('populates its first image correctly and', () {
        Image? image;
        setUp(() => image = tileset.image);

        test('has its width = 96', () => expect(image!.width, equals(96)));
        test('has its height = 64', () => expect(image!.height, equals(64)));
        test('has its source = "icons.png"', () {
          expect(image!.source, equals('icons.png'));
        });
      });

      group('populates its properties correctly and', () {
        late Map<String?, dynamic> properties;
        setUp(() => properties = tileset.properties);
        test('has a key of "test_property" = "test_value"', () {
          expect(properties, equals({'test_property': 'test_value'}));
        });
      });

      group('populates its child tile properties correctly by', () {
        late Map<int, Map<String?, dynamic>> tileProperties;
        setUp(() => tileProperties = tileset.tileProperties);

        test('inserting properties into tileProperties based on Tile GID', () {
          expect(
            tileProperties[1],
            equals({'tile_0_property_name': 'tile_0_property_value'}),
          );
          expect(
            tileProperties[2],
            equals({'tile_1_property_name': 'tile_1_property_value'}),
          );
        });
      });
    });
  });

  group('Parser.parse populates Map with layers', () {
    test('and Map.layers is the correct length', () {
      expect(map!.layers.length, equals(1));
    });

    group('and the first layer', () {
      late Layer layer;
      setUp(() => layer = map!.layers[0]);

      test('has its name = "Tile Layer 1"', () {
        expect(layer.name, equals('Tile Layer 1'));
      });

      test('has its width  = 10', () => expect(layer.width, equals(10)));
      test('has its height = 10', () => expect(layer.height, equals(10)));
      test('has its map = parent map', () => expect(layer.map, equals(map)));

      // This test is very simple. Theoretically, if this case works, they should all work.
      // It's a 10x10 matrix because anything smaller seems to default to gzip in Tiled (bug?).
      test('populates its tile matrix', () {
        expect(layer.tileMatrix[0], equals([1, 0, 0, 0, 0, 0, 0, 0, 0, 0]));
        expect(layer.tileMatrix[1], equals([0, 1, 0, 0, 0, 0, 0, 0, 0, 0]));
        expect(layer.tileMatrix[2], equals([0, 0, 1, 0, 0, 0, 0, 0, 0, 0]));
        expect(layer.tileMatrix[3], equals([0, 0, 0, 1, 0, 0, 0, 0, 0, 0]));
        expect(layer.tileMatrix[4], equals([0, 0, 0, 0, 1, 0, 0, 0, 0, 0]));
        expect(layer.tileMatrix[5], equals([0, 0, 0, 0, 0, 1, 0, 0, 0, 0]));
        expect(layer.tileMatrix[6], equals([0, 0, 0, 0, 0, 0, 1, 0, 0, 0]));
        expect(layer.tileMatrix[7], equals([0, 0, 0, 0, 0, 0, 0, 1, 0, 0]));
        expect(layer.tileMatrix[8], equals([0, 0, 0, 0, 0, 0, 0, 0, 1, 0]));
        expect(layer.tileMatrix[9], equals([0, 0, 0, 0, 0, 0, 0, 0, 0, 1]));
      });
    });
  });

  group('Parser.parse populates Map with objectgroups', () {
    setUp(() {
      return File('./test/fixtures/objectgroup.tmx').readAsString().then((xml) {
        map = parser.parse(xml);
      });
    });

    test('and objectGroups is the correct length', () {
      expect(map!.objectGroups.length, equals(2));
    });

    group('and the first objectGroup', () {
      late ObjectGroup og;
      setUp(() => og = map!.objectGroups[0]);

      test('has the right #map', () => expect(og.map, equals(map)));

      test('has the right #name', () {
        expect(og.name, equals('Test Object Layer 1'));
      });
    });
  });

  group('Parser.parse fills Map with tileset & different img configs', () {
    setUp(() {
      return File('./test/fixtures/map_images.tmx').readAsString().then((xml) {
        map = parser.parse(xml);
      });
    });

    test('and global tileset image', () {
      final tileset = map!.getTileset('default');
      final tile1 = map!.getTileByGID(tileset.firstgid);
      expect(tileset.image!.source, equals('level1.png'));
      expect(tileset.images.length, equals(1));
      expect(tile1.image!.source, equals('level1.png'));
      expect(tile1.computeDrawRect(), equals(const Rectangle(0, 0, 16, 16)));
      expect(
        map!.getTileByGID(tileset.firstgid! + 1).computeDrawRect(),
        equals(const Rectangle(16, 0, 16, 16)),
      );
      expect(
        map!.getTileByGID(tileset.firstgid! + 17).computeDrawRect(),
        equals(const Rectangle(0, 16, 16, 16)),
      );
      expect(
        map!.getTileByGID(tileset.firstgid! + 19).computeDrawRect(),
        equals(const Rectangle(32, 16, 16, 16)),
      );
    });

    test('and image per tile', () {
      final tileset = map!.getTileset('other');
      final tile1 = map!.getTileByGID(tileset.firstgid);
      final tile2 = map!.getTileByGID(tileset.firstgid! + 1);
      expect(tileset.image, isNull);
      expect(tileset.images.length, equals(2));
      expect(tileset.images[0].source, equals('image1.png'));
      expect(tile1.image!.source, equals('image1.png'));
      expect(tile1.computeDrawRect(), equals(const Rectangle(0, 0, 32, 32)));
      expect(tile2.image!.source, equals('image2.png'));
      expect(tile2.computeDrawRect(), equals(const Rectangle(0, 0, 32, 32)));
    });
  });

  group('Parser.parse with tsx provider', () {
    test('it loads external tsx', () {
      return File('./test/fixtures/map_images.tmx').readAsString().then((xml) {
        map = TileMapParser().parse(xml, tsx: CustomTsxProvider());
        expect(map!.getTileset('external').image!.source, equals('level1.png'));
      });
    });
  });

  group('Parser.parse with multiple layers', () {
    test('it has 2 layers', () {
      return File('./test/fixtures/map_images.tmx').readAsString().then((xml) {
        map = TileMapParser().parse(xml, tsx: CustomTsxProvider());
        expect(map!.layers.length, equals(2));
      });
    });
  });
}

class CustomTsxProvider extends TsxProvider {
  @override
  String getSource(String key) {
    return File('./test/fixtures/tileset.tsx').readAsStringSync();
  }
}
