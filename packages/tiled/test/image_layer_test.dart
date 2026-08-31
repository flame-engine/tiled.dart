import 'dart:io';

import 'package:test/test.dart';
import 'package:tiled/tiled.dart';

void main() {
  late TiledMap map;
  setUp(() {
    return File('./test/fixtures/imagelayer.tmx').readAsString().then((xml) {
      map = TiledMap.parseTmx(xml);
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

  test('parses image layers from json', () {
    final map = TiledMap.parseJson('''
{
 "height":1, "width":1, "tileheight":16, "tilewidth":16,
 "orientation":"orthogonal", "renderorder":"right-down", "version":"1.8",
 "layers":[
  {
   "type":"imagelayer", "id":1, "name":"Background", "image":"bg.png",
   "imagewidth":64, "imageheight":32, "opacity":1, "visible":true,
   "x":0, "y":0
  }
 ],
 "tilesets":[]
}
''');
    final layer = map.layerByName('Background') as ImageLayer;
    expect(layer.image.source, equals('bg.png'));
    expect(layer.image.width, equals(64));
    expect(layer.image.height, equals(32));
  });
}
