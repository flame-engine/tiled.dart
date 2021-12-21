import 'dart:io';
import 'package:test/test.dart';
import 'package:tiled/tiled.dart';
import 'package:xml/xml.dart';

void main() {
  group('Tileset defaults', () {
    late Tileset tileset;
    setUp(() {
      tileset = Tileset(
        firstGid: 1,
        name: 'Humans',
        tileWidth: 32,
        tileHeight: 64 * 32,
      );
    });
    test('spacing == 0', () => expect(tileset.spacing, equals(0)));
    test('margin == 0', () => expect(tileset.margin, equals(0)));
    test('tileProperties == {}', () {
      expect(tileset.properties, equals(<Property>[]));
    });
  });

  group('Tileset.fromXML', () {
    late Tileset tileset;
    setUp(() {
      return File('./test/fixtures/map_with_spacing_margin.tmx')
          .readAsString()
          .then((xml) {
        final xmlRoot = XmlDocument.parse(xml).rootElement;
        final tilesetXml = xmlRoot.findAllElements('tileset').first;
        tileset = Tileset.parse(XmlParser(tilesetXml));
      });
    });
    test('spacing = 1', () => expect(tileset.spacing, equals(1)));
    test('margin = 2', () => expect(tileset.margin, equals(2)));
  });
}
