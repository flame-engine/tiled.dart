import 'dart:io';
import 'package:xml/xml.dart';
import 'package:test/test.dart';
import 'package:tiled/tiled.dart';

void main() {
  group('Tileset defaults', () {
    Tileset tileset;
    setUp(() => tileset = Tileset(1));
    test('spacing == 0', () => expect(tileset.spacing, equals(0)));
    test('margin == 0', () => expect(tileset.margin, equals(0)));
    test('tileProperties == {}', () {
      expect(tileset.tileProperties, equals({}));
    });
  });

  group('Tileset.fromXML', () {
    Tileset tileset;
    setUp(() {
      return File('./test/fixtures/map_with_spacing_margin.tmx')
          .readAsString()
          .then((xml) {
        final xmlRoot = XmlDocument.parse(xml).rootElement;
        final tilesetXml = xmlRoot.findAllElements('tileset').first;
        tileset = Tileset.fromXml(tilesetXml);
      });
    });
    test('spacing = 1', () => expect(tileset.spacing, equals(1)));
    test('margin = 2', () => expect(tileset.margin, equals(2)));
  });
}
