import 'dart:io';
import 'dart:ui';

import 'package:test/test.dart';
import 'package:tiled/src/parser.dart';
import 'package:tiled/tiled.dart';
import 'package:xml/xml.dart';

void main() {
  late TiledMap map;
  setUp(() {
    return File('./test/fixtures/test.tmx').readAsString().then((xml) {
      map = TileMapParser.parseTmx(xml);
    });
  });

  test('Parser.parse raises an error when the XML is empty', () {
    const wrongXml = '';
    expect(
      () => TileMapParser.parseTmx(wrongXml),
      throwsA(const TypeMatcher<XmlParserException>()),
    );
  });

  test('Parser.parse raises an error when the XML is not in TMX format', () {
    const wrongXml = '<xml></xml>';
    expect(
      () => TileMapParser.parseTmx(wrongXml),
      throwsA('XML is not in TMX format'),
    );
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
      late Tileset tileset;
      setUp(() => tileset = map.tilesets[0]);

      test('has its firstgid = 1', () => expect(tileset.firstGid, equals(1)));
      test('has its name = "basketball"', () {
        expect(tileset.name, equals('basketball'));
      });

      test('has its tilewidth = 32',
          () => expect(tileset.tileWidth, equals(32)));
      test('has its tileheight = 32',
          () => expect(tileset.tileHeight, equals(32)));
      // test('has its map = map', () => expect(tileset.map, equals(map)));
      test('has its image', () => expect(tileset.image, isNotNull));

      group('populates its first image correctly and', () {
        late TiledImage image;
        setUp(() => image = tileset.image!);

        test('has its width = 32', () => expect(image.width, equals(32)));
        test('has its height = 32', () => expect(image.height, equals(32)));
        test('has its source = "icons.png"', () {
          expect(image.source, equals('icons.png'));
        });
      });

      group('populates its properties correctly and', () {
        late List<Property> properties;
        setUp(() => properties = tileset.properties);
        test('has a key of "test_property" = "test_value"', () {
          expect(properties[0].name, equals('test_property'));
          expect(properties[0].value, equals('test_value'));
        });
      });

      group('populates its child tile properties correctly by', () {
        late List<Property> tile1Properties;
        late List<Property> tile2Properties;
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
      late TileLayer layer;
      setUp(() => layer = map.layers[0] as TileLayer);

      test('has its name = "Tile Layer 1"', () {
        expect(layer.name, equals('Tile Layer 1'));
      });

      test('has its width  = 10', () => expect(layer.width, equals(10)));
      test('has its height = 10', () => expect(layer.height, equals(10)));

      // This test is very simple. Theoretically, if this case works, they should all work.
      // It's a 10x10 matrix because anything smaller seems to default to gzip in Tiled (bug?).
      test('populates its tile matrix', () {
        List<int> getDataRow(int idx) {
          return layer.tileData![idx].map((e) => e.tile).toList();
        }

        expect(getDataRow(0), equals([1, 0, 0, 0, 0, 0, 0, 0, 0, 0]));
        expect(getDataRow(1), equals([0, 1, 0, 0, 0, 0, 0, 0, 0, 0]));
        expect(getDataRow(2), equals([0, 0, 1, 0, 0, 0, 0, 0, 0, 0]));
        expect(getDataRow(3), equals([0, 0, 0, 1, 0, 0, 0, 0, 0, 0]));
        expect(getDataRow(4), equals([0, 0, 0, 0, 1, 0, 0, 0, 0, 0]));
        expect(getDataRow(5), equals([0, 0, 0, 0, 0, 1, 0, 0, 0, 0]));
        expect(getDataRow(6), equals([0, 0, 0, 0, 0, 0, 1, 0, 0, 0]));
        expect(getDataRow(7), equals([0, 0, 0, 0, 0, 0, 0, 1, 0, 0]));
        expect(getDataRow(8), equals([0, 0, 0, 0, 0, 0, 0, 0, 1, 0]));
        expect(getDataRow(9), equals([0, 0, 0, 0, 0, 0, 0, 0, 0, 1]));
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
      expect(
          map.layers
              .where((element) => element.type == LayerType.objectGroup)
              .length,
          equals(2));
    });

    group('and the first objectGroup', () {
      late Layer og;
      setUp(() => og = map.layers
          .where((element) => element.type == LayerType.objectGroup)
          .toList()[0]);

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
      final tileset = map.getTilesetByName('default');
      expect(tileset.image!.source, equals('level1.png'));
      expect(
        tileset.computeDrawRect(Tile(localId: tileset.firstGid!)),
        equals(const Rect.fromLTWH(0, 0, 16, 16)),
      );
      expect(
        tileset.computeDrawRect(Tile(localId: tileset.firstGid! + 1)),
        equals(const Rect.fromLTWH(16, 0, 16, 16)),
      );
      expect(
        tileset.computeDrawRect(Tile(localId: tileset.firstGid! + 17)),
        equals(const Rect.fromLTWH(0, 16, 16, 16)),
      );
      expect(
        tileset.computeDrawRect(Tile(localId: tileset.firstGid! + 19)),
        equals(const Rect.fromLTWH(32, 16, 16, 16)),
      );
    });

    test('and image per tile', () {
      final tileset = map.getTilesetByName('other');
      expect(tileset.image, isNull);
      final tiledImages = map.getTiledImages();
      expect(tiledImages.length, equals(3));
      expect(
        tiledImages.map((e) => e.source),
        containsAll(['level1.png', 'image1.png', 'image2.png']),
      );

      final tile1 = map.getTileByGid(tileset.firstGid!);
      final tile2 = map.getTileByGid(tileset.firstGid! + 1);
      expect(tile1.image!.source, equals('image1.png'));
      expect(
        tileset.computeDrawRect(tile1),
        equals(const Rect.fromLTWH(0, 0, 32, 32)),
      );
      expect(tile2.image!.source, equals('image2.png'));
      expect(
        tileset.computeDrawRect(tile2),
        equals(const Rect.fromLTWH(0, 0, 32, 32)),
      );
    });
  });

  group('Parser.parse with tsx provider', () {
    test('it loads external tsx', () {
      return File('./test/fixtures/map_images.tmx').readAsString().then((xml) {
        map = TileMapParser.parseTmx(xml, tsx: CustomTsxProvider());
        expect(
          map.getTilesetByName('external').image!.source,
          equals('level1.png'),
        );
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
  Parser getSource(String key) {
    final xml = File('./test/fixtures/tileset.tsx').readAsStringSync();
    final node = XmlDocument.parse(xml).rootElement;
    return XmlParser(node);
  }
}
