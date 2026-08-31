import 'package:test/test.dart';
import 'package:tiled/tiled.dart';

import 'fixture_provider.dart';

void main() {
  const readFixture = FixtureProvider.read;

  List<TiledObject> objectsOf(TiledMap map) {
    return (map.layerByName('Objects') as ObjectGroup).objects;
  }

  void expectInherited(TiledMap map) {
    final objects = objectsOf(map);

    final inherited = objects[0];
    expect(inherited.name, equals('Templated'));
    expect(inherited.type, equals('enemy'));
    expect(inherited.gid, equals(5));
    expect(inherited.width, equals(16));
    expect(inherited.height, equals(16));
    expect(inherited.x, equals(32));
    expect(inherited.y, equals(48));
    expect(inherited.isRectangle, isTrue);
    expect(inherited.properties.getValue<int>('health'), equals(10));

    final overridden = objects[2];
    expect(overridden.name, equals('Overridden'));
    expect(overridden.type, equals('enemy'));
    expect(overridden.gid, equals(5));
    expect(overridden.width, equals(32));
    expect(overridden.height, equals(16));
    expect(overridden.properties.getValue<int>('health'), equals(3));
    expect(overridden.properties.getValue<double>('speed'), equals(1.5));

    final ownGid = objects[3];
    expect(ownGid.gid, equals(2));
    expect(ownGid.name, equals('Templated'));
  }

  group('Template inheritance', () {
    test('objects inherit unspecified values from their template in tmx', () {
      final map = TiledMap.parseTmx(
        readFixture('map_with_template.tmx'),
        providers: [FixtureProvider()],
      );
      expectInherited(map);
    });

    test('objects inherit unspecified values from their template in json', () {
      final map = TiledMap.parseJson(
        readFixture('map_with_template.json'),
        providers: [FixtureProvider()],
      );
      expectInherited(map);
    });

    test('objects without a resolved template keep their own values', () {
      final map = TiledMap.parseTmx(readFixture('map_with_template.tmx'));
      final objects = objectsOf(map);
      expect(objects[0].name, equals(''));
      expect(objects[0].gid, isNull);
      expect(objects[2].name, equals('Overridden'));
      expect(objects[2].properties.getValue<double>('speed'), equals(1.5));
    });

    test('inherited gids are translated to the tilesets of the map', () {
      final map = TiledMap.parseTmx(
        readFixture('map_with_template_no_tileset.tmx'),
        providers: [FixtureProvider()],
      );
      expect(map.tilesets.map((tileset) => tileset.name), [
        'other',
        'external',
      ]);
      final added = map.tilesets[1];
      expect(added.source, equals('tileset.tsx'));
      expect(added.firstGid, equals(3));
      expect(added.tileCount, equals(136));

      final objects = objectsOf(map);
      expect(objects[0].gid, equals(7));
      expect(map.tileByGid(7)!.localId, equals(4));

      final flipped = Gid.fromInt(objects[1].gid!);
      expect(flipped.tile, equals(7));
      expect(flipped.flips.horizontally, isTrue);
      expect(flipped.flips.vertically, isFalse);
    });

    test('the tileset of a template is only added once', () {
      final map = TiledMap.parseTmx(
        readFixture('map_with_template_no_tileset.tmx'),
        providers: [FixtureProvider()],
      );
      expect(map.tilesets, hasLength(2));
    });

    test('tilesets referenced from templates are resolved by path', () {
      final map = TiledMap.parseTmx(
        readFixture('map_nested.tmx'),
        providers: [FixtureProvider()],
      );
      final tileset = map.tilesetByName('nested');
      final template = (tileset.tiles.first.objectGroup! as ObjectGroup)
          .objects
          .single
          .template!;
      expect(template.tileSet!.source, equals('tilesets/nested_tileset.tsx'));
      expect(map.tilesets, hasLength(1));
    });
  });
}
