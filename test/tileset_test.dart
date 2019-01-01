import 'dart:io';
import 'package:xml/xml.dart';
import 'package:test/test.dart';
import 'package:tiled/tiled.dart';

void main() {
  group('Tileset defaults', () {
    var tileset;
    setUp(() => tileset = new Tileset(1));
    test('spacing == 0', () => expect(tileset.spacing, equals(0)));
    test('margin == 0', () => expect(tileset.margin, equals(0)));
    test('tileProperties == {}',
        () => expect(tileset.tileProperties, equals({})));
  });

  group('Tileset.fromXML', () {
    var tileset;
    setUp(() {
      return new File('./test/fixtures/map_with_spacing_margin.tmx')
          .readAsString()
          .then((xml) {
        var xmlRoot = parse(xml).rootElement;
        var tilesetXml = xmlRoot.findAllElements('tileset').first;
        tileset = new Tileset.fromXML(tilesetXml);
      });
    });
    test('spacing = 1', () => expect(tileset.spacing, equals(1)));
    test('margin = 2', () => expect(tileset.margin, equals(2)));
  });

}
