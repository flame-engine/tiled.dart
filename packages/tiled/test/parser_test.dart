import 'dart:io';
import 'dart:math' show Rectangle;
import 'dart:ui';

import 'package:test/test.dart';
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

    test('and Map.backgroundColor is the correct', () {
      expect(map.backgroundColorHex, equals('#ccddaaff'));
      expect(
        map.backgroundColor,
        equals(Color(int.parse('0xccddaaff'))),
      );
    });

    group('and the first tileset', () {
      late Tileset tileset;
      setUp(() => tileset = map.tilesets[0]);

      test('has its firstgid = 1', () => expect(tileset.firstGid, equals(1)));
      test('has its name = "basketball"', () {
        expect(tileset.name, equals('basketball'));
      });

      test(
        'has its tilewidth = 32',
        () => expect(tileset.tileWidth, equals(32)),
      );
      test(
        'has its tileheight = 32',
        () => expect(tileset.tileHeight, equals(32)),
      );
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
        late CustomProperties properties;
        setUp(() => properties = tileset.properties);
        test('has a key of "test_property" = "test_value"', () {
          expect(properties.first.name, equals('string property'));
          expect(
            properties.getValue<String>('string property'),
            equals('test_value'),
          );
          expect(
            properties.getValue<String>('multiline string'),
            equals('Hello,\nWorld'),
          );
          expect(
            properties.getValue<int>('integer property'),
            equals(42),
          );
          expect(
            properties.getProperty<ColorProperty>('color property').hexValue,
            equals('#00112233'),
          );
          expect(
            properties.getValue<Color>('color property'),
            equals(const Color(0x00112233)),
          );
          expect(
            properties.getValue<double>('float property'),
            equals(1.56),
          );
          expect(
            properties.getValue<String>('file property'),
            equals('./icons.png'),
          );
          expect(
            properties.getValue<int>('object property'),
            equals(32),
          );
        });
      });

      group('populates its data correctly,', () {
        late Tile tile0;
        late Tile tile1;
        setUp(() {
          tile0 = tileset.tiles[0];
          tile1 = tileset.tiles[1];
        });

        test('type and class should be the same', () {
          expect(tile0.class_, equals('tile0Class'));
          expect(tile0.type, equals('tile0Class'));

          expect(tile1.class_, equals('tile1Type'));
          expect(tile1.type, equals('tile1Type'));
        });
      });

      group('populates its child tile properties correctly by', () {
        late CustomProperties tile1Properties;
        late CustomProperties tile2Properties;
        setUp(() {
          tile1Properties = tileset.tiles[0].properties;
          tile2Properties = tileset.tiles[1].properties;
        });

        test('inserting properties into tileProperties based on Tile GID', () {
          expect(
            tile1Properties.getValue<String>('tile_0_property_name'),
            equals('tile_0_property_value'),
          );
          expect(
            tile2Properties.getValue<String>('tile_1_property_name'),
            equals('tile_1_property_value'),
          );
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

      test('has a class_ value', () {
        expect(layer.class_, equals('layer1Class'));
      });

      test('has its width  = 10', () => expect(layer.width, equals(10)));
      test('has its height = 10', () => expect(layer.height, equals(10)));

      // This test is very simple. Theoretically, if this case works, they
      // should all work.
      // It's a 10x10 matrix because anything smaller seems to default to gzip
      // in Tiled (bug?).
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
        equals(2),
      );
    });

    group('and the first objectGroup', () {
      late Layer og;
      setUp(
        () => og = map.layers
            .where((element) => element.type == LayerType.objectGroup)
            .toList()[0],
      );

      test('has the right #name', () {
        expect(og.name, equals('Test Object Layer 1'));
      });

      test('has the right class_', () {
        expect(og.class_, equals('objectLayer1Class'));
      });
    });
  });

  group('Parser.parse fills Map with tileset & different img configs', () {
    setUp(() {
      return File('./test/fixtures/map_images.tmx').readAsString().then((xml) {
        map = TileMapParser.parseTmx(
          xml,
          tsxList: [CustomTsxProvider.parse('tileset.tsx')],
        );
      });
    });

    test('and global tileset image', () {
      final tileset = map.tilesetByName('default');
      expect(tileset.image!.source, equals('level1.png'));
      expect(
        tileset.computeDrawRect(Tile(localId: 0)),
        equals(const Rectangle(0, 0, 16, 16)),
      );
      expect(
        tileset.computeDrawRect(Tile(localId: 1)),
        equals(const Rectangle(16, 0, 16, 16)),
      );
      expect(
        tileset.computeDrawRect(Tile(localId: 17)),
        equals(const Rectangle(0, 16, 16, 16)),
      );
      expect(
        tileset.computeDrawRect(Tile(localId: 19)),
        equals(const Rectangle(32, 16, 16, 16)),
      );
    });

    test('and image per tile', () {
      final tileset = map.tilesetByName('other');
      expect(tileset.image, isNull);
      final tiledImages = map.tiledImages();
      expect(tiledImages.length, equals(3));
      expect(
        tiledImages.map((e) => e.source),
        containsAll(<String>['level1.png', 'image1.png', 'image2.png']),
      );

      final gid = tileset.firstGid!;

      final tile1 = map.tileByGid(gid)!;
      expect(tile1.image!.source, equals('image1.png'));
      expect(
        tileset.computeDrawRect(tile1),
        equals(const Rectangle(0, 0, 32, 32)),
      );

      final tile2 = map.tileByGid(gid + 1)!;
      expect(tile2.image!.source, equals('image2.png'));
      expect(
        tileset.computeDrawRect(tile2),
        equals(const Rectangle(0, 0, 32, 32)),
      );
    });
  });

  group('External tileset tile parsing', () {
    test('it parsed the first tile', () {
      return File('./test/fixtures/external_tileset_map.tmx')
          .readAsString()
          .then((xml) {
        final map = TileMapParser.parseTmx(
          xml,
          tsxList: [CustomTsxProvider.parse('tileid_over_tilecount.tsx')],
        );
        expect(map.tilesets[0].tileCount, 137);
        final tile = map.tileByGid(1)!;
        expect(tile.localId, 0);
        expect(tile.type, 'first_tile');
      });
    });
  });

  group('Parser.parse with tsx provider', () {
    test('it loads external tsx', () {
      return File('./test/fixtures/map_images.tmx').readAsString().then((xml) {
        map = TileMapParser.parseTmx(
          xml,
          tsxList: [CustomTsxProvider.parse('tileset.tsx')],
        );
        expect(
          map.tilesetByName('external').image!.source,
          equals('level1.png'),
        );
      });
    });
  });

  group('Parser.parse with multiple layers', () {
    test('it has 2 layers', () {
      return File('./test/fixtures/map_images.tmx').readAsString().then((xml) {
        map = TileMapParser.parseTmx(
          xml,
          tsxList: [CustomTsxProvider.parse('tileset.tsx')],
        );
        expect(map.layers.length, equals(2));
      });
    });
  });

  group('Map Parses Multiple Tilesets', () {
    late TiledMap map;
    setUp(() {
      return File('./test/fixtures/map_with_multiple_tilesets.tmx')
          .readAsString()
          .then((xml) {
        final tilemapXml = XmlDocument.parse(xml).rootElement;
        final tsxSourcePaths = tilemapXml.children
            .whereType<XmlElement>()
            .where((element) => element.name.local == 'tileset')
            .map((tsx) => tsx.getAttribute('source'));

        final tsxProviders = tsxSourcePaths
            .where((key) => key != null)
            .map((key) => CustomTsxProvider.parse(key!));

        map = TileMapParser.parseTmx(
          xml,
          tsxList: tsxProviders.isEmpty ? null : tsxProviders.toList(),
        );
        return;
      });
    });
    test(
      'correct number of tilests',
      () => expect(
        map.tilesets.length,
        3,
      ),
    );

    test('tilesets firstgid correct', () {
      expect(
        map.tilesets.first.firstGid,
        1,
      );

      expect(
        map.tilesets.last.firstGid,
        273,
      );
    });
    test('first tileset details correct', () {
      expect(
        map.tilesets.first.name,
        'level1',
      );

      expect(
        map.tilesets.first.tileCount,
        136,
      );
    });
    test('embedded tileset details correct', () {
      expect(
        map.tilesets[1].name,
        'level_embed',
      );
    });
    test('third tileset details correct', () {
      expect(
        map.tilesets.last.name,
        'level2',
      );

      expect(
        map.tilesets.last.tileCount,
        288,
      );
    });
  });
}

class CustomTsxProvider extends TsxProvider {
  final String _filename;
  final String data;

  CustomTsxProvider._(this.data, this._filename);

  factory CustomTsxProvider.parse(String filename) {
    final xml = File('./test/fixtures/$filename').readAsStringSync();
    return CustomTsxProvider._(xml, filename);
  }

  @override
  String get filename => _filename;

  @override
  Parser getSource(String key) {
    final node = XmlDocument.parse(data).rootElement;
    return XmlParser(node);
  }

  @override
  Parser? getCachedSource() {
    return getSource('');
  }
}
