import 'dart:io';
import 'dart:math' as math;

import 'package:test/test.dart';
import 'package:tiled/tiled.dart';
import 'package:xml/xml.dart';

void main() {
  TiledMap map;
  setUp(() {
    return File('./test/fixtures/test.tmx').readAsString().then((xml) {
      map = TileMapParser.parseTmx(xml);
    });
  });

  test('Parser.parse raises an error when the XML is empty', () {
    const wrongXml = '';
    expect(() => TileMapParser.parseTmx(wrongXml), throwsA('XML is empty'));
  });

  test('Parser.parse raises an error when the XML is null', () {
    const wrongXml = null;
    expect(() => TileMapParser.parseTmx(wrongXml), throwsA('XML is empty'));
  });

  test('Parser.parse raises an error when the XML is not in TMX format', () {
    const wrongXml = '<xml></xml>';
    expect(() => TileMapParser.parseTmx(wrongXml), throwsA('XML is not in TMX format'));
  });

  group('Parser.parse returns a populated Map that', () {
    test('has its tileWidth = 32', () => expect(map.tileWidth, equals(32)));
    test('has its tileHeight = 32', () => expect(map.tileHeight, equals(32)));
  });

  group('Parser.parse populates Map with tilesets', () {
    test('and Map.tilesets is the correct size', () {
      expect(map.tileSets.length, equals(1));
    });

    group('and the first tileset', () {
      TileSet tileset;
      setUp(() => tileset = map.tileSets[0]);

      test('has its firstgid = 1', () => expect(tileset.firstGId, equals(1)));
      test('has its name = "basketball"', () {
        expect(tileset.name, equals('basketball'));
      });

      test('has its tilewidth = 32', () => expect(tileset.tileWidth, equals(32)));
      test('has its tileheight = 32', () => expect(tileset.tileHeight, equals(32)));
      // test('has its map = map', () => expect(tileset.map, equals(map)));
      test('has its image', () => expect(tileset.image, isNotNull));

      group('populates its first image correctly and', () {
        TiledImage image;
        setUp(() => image = tileset.image);

        test('has its width = 32', () => expect(image.width, equals(32)));
        test('has its height = 32', () => expect(image.height, equals(32)));
        test('has its source = "icons.png"', () {
          expect(image.source, equals('icons.png'));
        });
      });

      group('populates its properties correctly and', () {
        List<Property> properties;
        setUp(() => properties = tileset.properties);
        test('has a key of "test_property" = "test_value"', () {
          expect(properties[0].name, equals('test_property'));
          expect(properties[0].value, equals('test_value'));
        });
      });

      group('populates its child tile properties correctly by', () {
        List<Property> tile1Properties;
        List<Property> tile2Properties;
        setUp(() {
          tile1Properties = tileset.tiles[0].properties;
          tile2Properties = tileset.tiles[1].properties;
        });

        test('inserting properties into tileProperties based on Tile GID', () {
          expect(tile1Properties[0].name, equals('tile_0_property_name'));
          expect(tile1Properties[0].value, equals('tile_0_property_value'));
          expect(tile2Properties[0].name, equals('tile_1_property_name'));
          expect(tile2Properties[0].value, equals('tile_1_property_value'));
        });
      });
    });
  });

  group('Parser.parse populates Map with layers', () {
    test('and Map.layers is the correct length', () {
      expect(map.layers.length, equals(1));
    });

    group('and the first layer', () {
      Layer layer;
      setUp(() => layer = map.layers[0]);

      test('has its name = "Tile Layer 1"', () {
        expect(layer.name, equals('Tile Layer 1'));
      });

      test('has its width  = 10', () => expect(layer.width, equals(10)));
      test('has its height = 10', () => expect(layer.height, equals(10)));

      // This test is very simple. Theoretically, if this case works, they should all work.
      // It's a 10x10 matrix because anything smaller seems to default to gzip in Tiled (bug?).
      test('populates its tile matrix', () {
        expect(layer.tileIDMatrix[0], equals([1, 0, 0, 0, 0, 0, 0, 0, 0, 0]));
        expect(layer.tileIDMatrix[1], equals([0, 1, 0, 0, 0, 0, 0, 0, 0, 0]));
        expect(layer.tileIDMatrix[2], equals([0, 0, 1, 0, 0, 0, 0, 0, 0, 0]));
        expect(layer.tileIDMatrix[3], equals([0, 0, 0, 1, 0, 0, 0, 0, 0, 0]));
        expect(layer.tileIDMatrix[4], equals([0, 0, 0, 0, 1, 0, 0, 0, 0, 0]));
        expect(layer.tileIDMatrix[5], equals([0, 0, 0, 0, 0, 1, 0, 0, 0, 0]));
        expect(layer.tileIDMatrix[6], equals([0, 0, 0, 0, 0, 0, 1, 0, 0, 0]));
        expect(layer.tileIDMatrix[7], equals([0, 0, 0, 0, 0, 0, 0, 1, 0, 0]));
        expect(layer.tileIDMatrix[8], equals([0, 0, 0, 0, 0, 0, 0, 0, 1, 0]));
        expect(layer.tileIDMatrix[9], equals([0, 0, 0, 0, 0, 0, 0, 0, 0, 1]));
      });
    });
  });

  group('Parser.parse populates Map with objectgroups', () {
    setUp(() {
      return File('./test/fixtures/objectgroup.tmx').readAsString().then((xml) {
        map = TileMapParser.parseTmx(xml);
      });
    });

    test('and objectGroups is the correct length', () {
      expect(map.layers.where((element) => element.type == LayerType.objectlayer).length, equals(2));
    });

    group('and the first objectGroup', () {
      Layer og;
      setUp(() => og = map.layers.where((element) => element.type == LayerType.objectlayer).toList()[0]);

      test('has the right #name', () {
        expect(og.name, equals('Test Object Layer 1'));
      });
    });
  });

  group('Parser.parse fills Map with tileset & different img configs', () {
    setUp(() {
      return File('./test/fixtures/map_images.tmx').readAsString().then((xml) {
        map = TileMapParser.parseTmx(xml, tsx: CustomTsxProvider());
      });
    });

    test('and global tileset image', () {
      final TileSet tileset = map.getTilesetByName('default');
      expect(tileset.image.source, equals('level1.png'));
      final Tile tile1 = map.getTileByGId(tileset.firstGId);
      // TODO drawRect???
      // expect(tileset.computeDrawRect(tile1), equals(const math.Rectangle(0, 0, 16, 16)));
      // expect(
      //   tileset.computeDrawRect(map.getTileByGId(tileset.firstGId + 1)),
      //   equals(const math.Rectangle(16, 0, 16, 16)),
      // );
      // expect(
      //   tileset.computeDrawRect(map.getTileByGId(tileset.firstGId + 17)),
      //   equals(const math.Rectangle(0, 16, 16, 16)),
      // );
      // expect(
      //   tileset.computeDrawRect(map.getTileByGId(tileset.firstGId + 19)),
      //   equals(const math.Rectangle(32, 16, 16, 16)),
      // );
    });

    test('and image per tile', () {
      final TileSet tileset = map.getTilesetByName('other');
      // final Tile tile1 = map.getTileByGID(tileset.firstgid);
      // final Tile tile2 = map.getTileByGID(tileset.firstgid + 1);
      expect(tileset.image, isNull);
      final tiledImages = map.getTiledImages();
      expect(tiledImages.length, equals(3));
      expect(tiledImages[0].source, equals('level1.png'));
      expect(tiledImages[1].source, equals('image1.png'));
      expect(tiledImages[2].source, equals('image2.png'));
      // TODO drawRect???
      // expect(tile1.image.source, equals('image1.png'));
      // expect(tile1.computeDrawRect(), equals(math.Rectangle(0, 0, 32, 32)));
      // expect(tile2.image.source, equals('image2.png'));
      // expect(tile2.computeDrawRect(), equals(math.Rectangle(0, 0, 32, 32)));
    });
  });

  group('Parser.parse with tsx provider', () {
    test('it loads external tsx', () {
      return File('./test/fixtures/map_images.tmx').readAsString().then((xml) {
        map = TileMapParser.parseTmx(xml, tsx: CustomTsxProvider());
        expect(map.getTilesetByName('external').image.source, equals('level1.png'));
      });
    });
  });

  group('Parser.parse with multiple layers', () {
    test('it has 2 layers', () {
      return File('./test/fixtures/map_images.tmx').readAsString().then((xml) {
        map = TileMapParser.parseTmx(xml, tsx: CustomTsxProvider());
        expect(map.layers.length, equals(2));
      });
    });
  });
}

class CustomTsxProvider extends TsxProvider {
  @override
  XmlNode getSource(String key) {
    final String xml = File('./test/fixtures/tileset.tsx').readAsStringSync();
    return XmlDocument.parse(xml).rootElement;
  }
}
