import 'dart:math';

import 'package:test/test.dart';
import 'package:tiled/tiled.dart';
import 'dart:io';

void main() {
  final parser = TileMapJsonParser();
  MapJson map;
  setUp(() {
    return File('./test/fixtures/testcsv.json').readAsString().then((xml) {
      map = parser.parse(xml);
    });
  });


  // TODO Check Filetype?
  // test('Parser.parse raises an error when the XML is not in TMX format', () {
  //   const wrongXml = '<xml></xml>';
  //   expect(() => parser.parse(wrongXml), throwsA('XML is not in TMX format'));
  // });

  group('Parser.parse returns a populated Map that', () {
    test('has its tileWidth = 32', () => expect(map.tilewidth, equals(32)));
    test('has its tileHeight = 32', () => expect(map.tileheight, equals(32)));
  });

  group('Parser.parse populates Map with tilesets', () {
    test('and Map.tilesets is the correct size', () {
      expect(map.tilesets.length, equals(1));
    });

    group('and the first tileset', () {
      TilesetJson tileset;
      setUp(() => tileset = map.tilesets[0]);

      test('has its firstgid = 1', () => expect(tileset.firstgid, equals(1)));
      test('has its name = "testtileset"', () {
        expect(tileset.name, equals('testtileset'));
      });

      test('has its tilewidth = 32', () => expect(tileset.tilewidth, equals(32)));
      test('has its tileheight = 32', () => expect(tileset.tileheight, equals(32)));
     //TODO  test('has its map = map', () => expect(tileset.map, equals(map)));
      test('has its image', () => expect(tileset.image, isNotNull));


      //TODO Image is String in json
      // group('populates its first image correctly and', () {
      //   Image image;
      //   setUp(() => image = tileset.image);
      //
      //   test('has its width = 96', () => expect(image.width, equals(96)));
      //   test('has its height = 64', () => expect(image.height, equals(64)));
      //   test('has its source = "icons.png"', () {
      //     expect(image.source, equals('icons.png'));
      //   });
      // });

      //TODO Test tileset properties
      // group('populates its properties correctly and', () {
      //   Map<String, dynamic> properties;
      //   setUp(() => properties = tileset.properties);
      //   test('has a key of "test_property" = "test_value"', () {
      //     expect(properties, equals({'test_property': 'test_value'}));
      //   });
      // });

      // TODO Test tile properties
      // group('populates its child tile properties correctly by', () {
      //   Map<int, Map<String, dynamic>> tileProperties;
      //   setUp(() => tileProperties = tileset.tileProperties);
      //
      //   test('inserting properties into tileProperties based on Tile GID', () {
      //     expect(
      //       tileProperties[1],
      //       equals({'tile_0_property_name': 'tile_0_property_value'}),
      //     );
      //     expect(
      //       tileProperties[2],
      //       equals({'tile_1_property_name': 'tile_1_property_value'}),
      //     );
      //   });
      // });
    });
  });

  group('Parser.parse populates Map with layers', () {
    test('and Map.layers is the correct length', () {
      expect(map.layers.length, equals(2));
    });

    group('and the first layer', () {
      LayerJson layer;
      setUp(() => layer = map.layers[0]);

      test('has its name = "ground"', () {
        expect(layer.name, equals('ground'));
      });

      test('has its width  = 4', () => expect(layer.width, equals(4)));
      test('has its height = 4', () => expect(layer.height, equals(4)));
      //test('has its map = parent map', () => expect(layer.map, equals(map))); //TODO ?

      test('populates its tile matrix', () {
        expect(layer.data[0], equals(1)); //TODO Layer data ?
      });
    });
  });

  group('Parser.parse populates Map with objectgroups', () {
    setUp(() {
      return File('./test/fixtures/map.json').readAsString().then((xml) {
        map = parser.parse(xml);
      });
    });

    test('and objectGroups is the correct length', () {
      expect(map.layers.length, equals(2));
    });

    group('and the first objectGroup', () {
      LayerJson og;
      setUp(() => og = map.layers[1]);

      test('has the right #map', () => expect(og.type, equals("objectgroup")));

      test('has the right #name', () {
        expect(og.name, equals('people'));
      });
    });
  });

  // TODO Test imgs
  // group('Parser.parse fills Map with tileset & different img configs', () {
  //   setUp(() {
  //     return File('./test/fixtures/map_images.tmx').readAsString().then((xml) {
  //       map = parser.parse(xml);
  //     });
  //   });
  //
  //   test('and global tileset image', () {
  //     final tileset = map.getTileset('default');
  //     final tile1 = map.getTileByGID(tileset.firstgid);
  //     expect(tileset.image.source, equals('level1.png'));
  //     expect(tileset.images.length, equals(1));
  //     expect(tile1.image.source, equals('level1.png'));
  //     expect(tile1.computeDrawRect(), equals(const Rectangle(0, 0, 16, 16)));
  //     expect(
  //       map.getTileByGID(tileset.firstgid + 1).computeDrawRect(),
  //       equals(const Rectangle(16, 0, 16, 16)),
  //     );
  //     expect(
  //       map.getTileByGID(tileset.firstgid + 17).computeDrawRect(),
  //       equals(const Rectangle(0, 16, 16, 16)),
  //     );
  //     expect(
  //       map.getTileByGID(tileset.firstgid + 19).computeDrawRect(),
  //       equals(const Rectangle(32, 16, 16, 16)),
  //     );
  //   });
  //
  //   test('and image per tile', () {
  //     final tileset = map.getTileset('other');
  //     final tile1 = map.getTileByGID(tileset.firstgid);
  //     final tile2 = map.getTileByGID(tileset.firstgid + 1);
  //     expect(tileset.image, isNull);
  //     expect(tileset.images.length, equals(2));
  //     expect(tileset.images[0].source, equals('image1.png'));
  //     expect(tile1.image.source, equals('image1.png'));
  //     expect(tile1.computeDrawRect(), equals(const Rectangle(0, 0, 32, 32)));
  //     expect(tile2.image.source, equals('image2.png'));
  //     expect(tile2.computeDrawRect(), equals(const Rectangle(0, 0, 32, 32)));
  //   });
  // });

  // TODO Custom parser

  // group('Parser.parse with tsx provider', () {
  //   test('it loads external tsx', () {
  //     return File('./test/fixtures/map_images.tmx').readAsString().then((xml) {
  //       map = TileMapJsonParser().parse(xml, tsx: CustomTsxProvider());
  //       expect(map.getTileset('external').image.source, equals('level1.png'));
  //     });
  //   });
  // });
  //
  // group('Parser.parse with multiple layers', () {
  //   test('it has 2 layers', () {
  //     return File('./test/fixtures/map_images.tmx').readAsString().then((xml) {
  //       map = TileMapJsonParser().parse(xml, tsx: CustomTsxProvider());
  //       expect(map.layers.length, equals(2));
  //     });
  //   });
  // });
}

class CustomTsxProvider extends TsxProvider {
  @override
  String getSource(String key) {
    return File('./test/fixtures/tileset.tsx').readAsStringSync();
  }
}
