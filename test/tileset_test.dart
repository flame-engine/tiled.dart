import 'dart:io';
import 'package:xml/xml.dart';
import 'package:test/test.dart';
import 'package:tiled/tiled.dart';

void main() {
  group('Tileset defaults', () {
    TileSet tileset;
    setUp(() => tileset = TileSet('Humans', 1, 32, 64 * 32, []));
    test('spacing == 0', () => expect(tileset.spacing, equals(0)));
    test('margin == 0', () => expect(tileset.margin, equals(0)));
    test('tileProperties == {}', () {
      expect(tileset.properties, equals([]));
    });
  });

  group('Tileset.fromXML', () {
    TileSet tileset;
    setUp(() {
      return File('./test/fixtures/map_with_spacing_margin.tmx')
          .readAsString()
          .then((xml) {
        final xmlRoot = XmlDocument.parse(xml).rootElement;
        final tilesetXml = xmlRoot.findAllElements('tileset').first;
        tileset = TileSet.fromXml(tilesetXml);
      });
    });
    test('spacing = 1', () => expect(tileset.spacing, equals(1)));
    test('margin = 2', () => expect(tileset.margin, equals(2)));
  });
}
