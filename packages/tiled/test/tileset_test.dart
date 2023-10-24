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
      expect(tileset.properties.byName, equals(<String, Property>{}));
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

  group('Standalone Tileset with ObjectGroups', () {
    late Tileset tileset;
    setUp(() {
      return File('./test/fixtures/map_with_tile_collision.tsx')
          .readAsString()
          .then((xml) {
        final tilesetXml = XmlDocument.parse(xml).rootElement;
        tileset = Tileset.parse(XmlParser(tilesetXml));
      });
    });
    test(
      'non-null first objectgroup',
      () => expect(
        (tileset.tiles.first.objectGroup as ObjectGroup?) != null,
        true,
      ),
    );
    test(
      'first objectgroup object = ellipsis',
      () => expect(
        ((tileset.tiles.first.objectGroup as ObjectGroup?)!.objects.first)
            .isEllipse,
        true,
      ),
    );
    test(
      'second objectgroup object = rectangle',
      () => expect(
        (tileset.tiles.elementAt(1).objectGroup as ObjectGroup?)!
            .objects
            .first
            .isRectangle,
        true,
      ),
    );
  });
}
