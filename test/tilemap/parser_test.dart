import 'package:unittest/unittest.dart';
import 'package:citadel/tilemap.dart';
import 'dart:io';

main() {
  var inflateZlib = (List<int> bytes) => new ZLibDecoder().convert(bytes);
  var parser = new Parser(inflateZlib);
  var map;
  // Urgh. var xml = File.read(/* ... */); >:/
  setUp( () {
    return new File('../fixtures/test.tmx').readAsString().then((xml) {
      map = parser.parse(xml);
    });
  });

  test('Parser.parse raises an error when the XML is not in TMX format', () {
    var wrongXml = '<xml></xml>';

    expect( ()=> parser.parse(wrongXml),
        throwsA('XML is not in TMX format'));
  });

  test('Parser.parse returns a Map object', () {
    expect(map, new isInstanceOf<TiledMap>());
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
      setUp( ()=> tileset = map.tilesets[0] );

      test('has its firstgid = 1', ()=> expect(tileset.gid, equals(1)) );
      test('has its name = "basketball"', ()=> expect(tileset.name, equals('basketball')));
      test('has its tilewidth = 32', ()=> expect(tileset.width, equals(32)));
      test('has its tileheight = 32', ()=> expect(tileset.height, equals(32)));
      test('has its map = map', ()=> expect(tileset.map, equals(map)));
      test('has its images.length = 1', ()=> expect(tileset.images.length, equals(1)));

      group('populates its first image correctly and', () {
        var image;
        setUp( ()=> image = tileset.images[0]);

        test('has its width = 96', ()=> expect(image.width, equals(96)));
        test('has its height = 64', ()=> expect(image.height, equals(64)));
        test('has its source = "../icons/obj/basketball.png"', ()=> expect(image.source, equals('../icons/obj/basketball.png')));
      });

      group('populates its properties correctly and', () {
        var properties;
        setUp( () => properties = tileset.properties);
        test('has a key of "test_property" = "test_value"', () {
          expect(properties, equals({ 'test_property': 'test_value'}));
        });
      });
    });

  });

  group('Parser.parse populates Map with layers', () {
    test('and Map.layers is the correct length', ()=> expect(map.layers.length, equals(1)));

    group('and the first layer', () {
      var layer;
      setUp( ()=> layer = map.layers[0] );

      test('has its name = "Tile Layer 1"', ()=> expect(layer.name, equals('Tile Layer 1')));
      test('has its width  = 10', ()=> expect(layer.width, equals(10)));
      test('has its height = 10', ()=> expect(layer.height, equals(10)));
      test('has its map = parent map', ()=> expect(layer.map, equals(map)));

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
}



