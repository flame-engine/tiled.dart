import 'dart:math';

import 'package:test/test.dart';
import 'package:tmx/tmx.dart';
import 'dart:io';

main() {
  TileMapParser parser;
  TileMap map;
  setUp(() {
    parser = new TileMapParser();
    return new File('./test/fixtures/test.tmx').readAsString().then((xml) {
      map = parser.parse(xml);
    });
  });

  test('Parser.parse raises an error when the XML is not in TMX format', () {
    var wrongXml = '<xml></xml>';

    expect(() => parser.parse(wrongXml), throwsA('XML is not in TMX format'));
  });

  group('Parser.parse returns a populated Map that', () {
    test('has its tileWidth = 32', () => expect(map.tileWidth, equals(32)));
    test('has its tileHeight = 32', () => expect(map.tileHeight, equals(32)));
  });

  group('Parser.parse populates Map with tilesets', () {
    test('and Map.tilesets is the correct size', () {
      expect(map.tilesets.length, equals(1));
    });

    group('and the first tileset', () {
      var tileset;
      setUp(() => tileset = map.tilesets[0]);

      test('has its firstgid = 1', () => expect(tileset.firstgid, equals(1)));
      test('has its name = "basketball"',
          () => expect(tileset.name, equals('basketball')));
      test('has its tilewidth = 32', () => expect(tileset.width, equals(32)));
      test('has its tileheight = 32', () => expect(tileset.height, equals(32)));
      test('has its map = map', () => expect(tileset.map, equals(map)));
      test('has its image', () => expect(tileset.image, isNotNull));

      group('populates its first image correctly and', () {
        var image;
        setUp(() => image = tileset.image);

        test('has its width = 96', () => expect(image.width, equals(96)));
        test('has its height = 64', () => expect(image.height, equals(64)));
        test('has its source = "icons.png"',
            () => expect(image.source, equals('icons.png')));
      });

      group('populates its properties correctly and', () {
        var properties;
        setUp(() => properties = tileset.properties);
        test('has a key of "test_property" = "test_value"', () {
          expect(properties, equals({'test_property': 'test_value'}));
        });
      });

      group('populates its child tile properties correctly by', () {
        var tileProperties;
        setUp(() => tileProperties = tileset.tileProperties);

        test('inserting properties into tileProperties based on Tile GID', () {
          expect(tileProperties[1],
              equals({'tile_0_property_name': 'tile_0_property_value'}));
          expect(tileProperties[2],
              equals({'tile_1_property_name': 'tile_1_property_value'}));
        });
      });
    });
  });

  group('Parser.parse populates Map with layers', () {
    test('and Map.layers is the correct length',
        () => expect(map.layers.length, equals(1)));

    group('and the first layer', () {
      var layer;
      setUp(() => layer = map.layers[0]);

      test('has its name = "Tile Layer 1"',
          () => expect(layer.name, equals('Tile Layer 1')));
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
      return new File('./test/fixtures/objectgroup.tmx')
          .readAsString()
          .then((xml) {
        map = parser.parse(xml);
      });
    });

    test('and objectGroups is the correct length',
        () => expect(map.objectGroups.length, equals(2)));

    group('and the first objectGroup', () {
      var og;
      setUp(() => og = map.objectGroups[0]);

      test('has the right #map', () => expect(og.map, equals(map)));

      test('has the right #name',
          () => expect(og.name, equals('Test Object Layer 1')));
    });
  });

  group('Parser.parse populates Map with tileset and different image configs',
      () {
    setUp(() {
      return new File('./test/fixtures/map_images.tmx')
          .readAsString()
          .then((xml) {
        map = parser.parse(xml);
      });
    });

    test('and global tileset image', () {
      var tileset = map.tilesets[0];
      var tile1 = map.getTileByGID(1);
      expect(tileset.image.source, equals('icons.png'));
      expect(tile1.image.source, equals('icons.png'));
      expect(tile1.computeDrawRect(), equals(new Rectangle(0, 0, 32, 32)));
      expect(map.getTileByGID(2).computeDrawRect(),
          equals(new Rectangle(32, 0, 32, 32)));
      expect(map.getTileByGID(4).computeDrawRect(),
          equals(new Rectangle(0, 32, 32, 32)));
      expect(map.getTileByGID(5).computeDrawRect(),
          equals(new Rectangle(32, 32, 32, 32)));
    });

    test('and image per tile', () {
      var tileset = map.tilesets[1];
      var tile1 = map.getTileByGID(100);
      var tile2 = map.getTileByGID(101);
      expect(tileset.image, isNull);
      expect(tile1.image.source, equals('x.png'));
      expect(tile1.computeDrawRect(), equals(new Rectangle(0, 0, 272, 128)));
      expect(tile2.image.source, equals('y.png'));
      expect(tile2.computeDrawRect(), equals(new Rectangle(0, 0, 640, 1024)));
    });
  });

  group('Parser.parse with tsx provider', () {
    test('it loads external tsx', () {
      return new File('./test/fixtures/map_images.tmx')
          .readAsString()
          .then((xml) {
        map = new TileMapParser().parse(xml, tsx: new CustomTsxProvider());        
        expect(map.getTileset('external').image.source, equals('external.png'));
      });
    });
  });
}

class CustomTsxProvider extends TsxProvider {
  @override
  String getSource(String key) {
    return new File('./test/fixtures/tileset.tsx').readAsStringSync();
  }
}
