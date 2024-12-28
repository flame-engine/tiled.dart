import 'dart:io';

import 'package:test/test.dart';
import 'package:tiled/tiled.dart';

void main() {
  late TiledMap map;
  setUp(() {
    return File('./test/fixtures/imagelayer.tmx').readAsString().then((xml) {
      map = TileMapParser.parseTmx(xml);
    });
  });

  group('Layer.fromXML', () {
    late ImageLayer imageLayer1;
    late ImageLayer imageLayer2;

    setUp(() {
      imageLayer1 = map.layerByName('Image Layer 1') as ImageLayer;
      imageLayer2 = map.layerByName('Image Layer 2') as ImageLayer;
    });

    test('sets name', () {
      expect(imageLayer1.name, equals('Image Layer 1'));
      expect(imageLayer2.name, equals('Image Layer 2'));
    });

    test('sets image', () {
      expect(imageLayer1.image.source, equals('image1.png'));
      expect(imageLayer2.image.source, equals('image2.png'));
    });

    test('sets class_', () {
      expect(imageLayer1.class_, equals('imageLayer1Class'));
      expect(imageLayer2.class_, equals(null));
    });

    test('sets repeatX and repeatY', () {
      expect(imageLayer1.repeatX, equals(true));
      expect(imageLayer1.repeatY, equals(false));

      expect(imageLayer2.repeatX, equals(false));
      expect(imageLayer2.repeatY, equals(true));
    });
  });
}
