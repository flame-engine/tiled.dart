import 'package:test/test.dart';
import 'package:tiled/tiled.dart';
import 'package:xml/xml.dart';
import 'dart:async';
import 'dart:io';

main() {
  XmlElement xmlRoot, xmlRoot_base64_gzip;

  // Urgh. var xml = File.read(/* ... */); >:/
  setUp( () {
    Future f1 = new File('./test/fixtures/test.tmx').readAsString().then((xml) {
      xmlRoot = parse(xml).rootElement;
    });
    Future f2 = new File('./test/fixtures/test_base64_gzip.tmx').readAsString().then((xml) {
      xmlRoot_base64_gzip = parse(xml).rootElement;
    });

    return Future.wait([f1, f2]);
  });

  group('Layer.fromXML', () {
    test('supports gzip', () {
      XmlNode layerNode = xmlRoot_base64_gzip.findAllElements('layer').first;
      Layer layer = new Layer.fromXML(layerNode);

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
    test('supports zlib', () {
      XmlNode layerNode = xmlRoot.findAllElements('layer').first;
      Layer layer = Layer.fromXML(layerNode);

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

  group('Layer.tiles', () {
    TileMap map;
    Layer layer;

    setUp(() {
      map = TileMapParser().parse(xmlRoot.toString());
      layer = map.layers.first;
    });


    test('is the expected size of 100', () {
      expect(layer.tiles.length, equals(10));
      layer.tiles.forEach((row) {
        expect(row.length, equals(10));
      });
    });

    test('calculates the x and y correctly for every tile', () {
      List<List<int>> coords = [];
      layer.tiles.forEach((row) => row.forEach((tile) => coords.add([tile.x, tile.y])));

      // Tileset is 32x32 in test.tmx, and the map is 10x10.
      List<List<int>> expectedCoords = [];
      for(int x = 0; x < 10; x++) {
        for(int y = 0; y < 10; y++) {
          expectedCoords.add([x, y]);
        }
      }

      expect(coords, equals(expectedCoords));
    });
  });
}
