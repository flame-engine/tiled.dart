import 'dart:io';

import 'package:test/test.dart';
import 'package:tiled/tiled.dart';

import 'fixture_provider.dart';

void main() {
  const readFixture = FixtureProvider.read;

  void expectTemplatesResolved(TiledMap map) {
    final objects = (map.layers[1] as ObjectGroup).objects;

    final templated = objects[0];
    expect(templated.templatePath, startsWith('object_template.'));
    final template = templated.template!;
    expect(template.object!.name, equals('Templated'));
    expect(template.object!.type, equals('enemy'));
    expect(template.object!.gid, equals(5));
    expect(template.object!.properties.getValue<int>('health'), equals(10));
    expect(template.tileSet!.source, equals('tileset.tsx'));
    expect(template.tileSet!.name, equals('external'));

    final plain = objects[1];
    expect(plain.templatePath, isNull);
    expect(plain.template, isNull);

    final tilesetWithTemplate = map.tilesetByName('with_template');
    final tileObjects =
        (tilesetWithTemplate.tiles.first.objectGroup! as ObjectGroup).objects;
    expect(tileObjects.single.template!.object!.name, equals('Templated'));
  }

  group('ParserProvider', () {
    test('the first provider that can provide a path is used', () {
      final first = FixtureProvider(files: {'tileset.tsx'});
      final second = FixtureProvider();

      TiledMap.parseTmx(
        readFixture('map_images.tmx'),
        providers: [first, second],
      );
      expect(first.requestedPaths, equals(['tileset.tsx']));
      expect(second.requestedPaths, isEmpty);

      TiledMap.parseTmx(
        readFixture('map_images.tmx'),
        providers: [second, first],
      );
      expect(first.requestedPaths, equals(['tileset.tsx']));
      expect(second.requestedPaths, equals(['tileset.tsx']));
    });

    test('providers that can not provide a path are skipped', () {
      final other = FixtureProvider(files: {'other.tsx'});
      final map = TiledMap.parseTmx(
        readFixture('map_images.tmx'),
        providers: [other, FixtureProvider()],
      );
      expect(other.requestedPaths, isEmpty);
      expect(map.tilesetByName('external').source, equals('tileset.tsx'));
    });

    test('external tilesets stay unresolved without a matching provider', () {
      final map = TiledMap.parseTmx(readFixture('map_images.tmx'));
      final tileset = map.tilesets.first;
      expect(tileset.source, equals('tileset.tsx'));
      expect(tileset.name, isNull);
      expect(tileset.tiles, isEmpty);
    });

    test('external tilesets provide their version and type', () {
      final map = TiledMap.parseTmx(
        readFixture('map_images.tmx'),
        providers: [FixtureProvider()],
      );
      final tileset = map.tilesetByName('external');
      expect(tileset.version, equals('1.2'));
      expect(tileset.type, equals(TilesetType.tileset));
    });

    test('external tilesets are resolved for json maps', () {
      final map = TiledMap.parseJson(
        readFixture('map_with_template.json'),
        providers: [FixtureProvider()],
      );
      expect(map.tilesets.length, equals(2));
      expect(map.tilesetByName('external').tileCount, equals(136));
    });

    test('templates are resolved for tmx maps', () {
      final map = TiledMap.parseTmx(
        readFixture('map_with_template.tmx'),
        providers: [FixtureProvider()],
      );
      expectTemplatesResolved(map);
    });

    test('templates are resolved for json maps', () {
      final map = TiledMap.parseJson(
        readFixture('map_with_template.json'),
        providers: [FixtureProvider()],
      );
      expectTemplatesResolved(map);
    });

    test('templates stay unresolved without a matching provider', () {
      final map = TiledMap.parseTmx(readFixture('map_with_template.tmx'));
      final templated = (map.layers[1] as ObjectGroup).objects.first;
      expect(templated.templatePath, equals('object_template.tx'));
      expect(templated.template, isNull);
    });

    test('every external file is requested at most once per map', () {
      final provider = FixtureProvider();
      TiledMap.parseTmx(
        readFixture('map_with_template.tmx'),
        providers: [provider],
      );
      expect(
        provider.requestedPaths,
        unorderedEquals([
          'tileset.tsx',
          'tileset_with_template.tsx',
          'object_template.tx',
        ]),
      );
    });

    test('paths in external files are resolved relative to that file', () {
      final provider = FixtureProvider();
      final map = TiledMap.parseTmx(
        readFixture('map_nested.tmx'),
        providers: [provider],
      );
      expect(
        provider.requestedPaths,
        equals([
          'tilesets/nested_tileset.tsx',
          'tilesets/templates/nested_template.tx',
        ]),
      );
      final tileset = map.tilesetByName('nested');
      final tileObjects =
          (tileset.tiles.first.objectGroup! as ObjectGroup).objects;
      expect(tileObjects.single.template!.object!.name, equals('Nested'));
    });

    test('cyclic references are left unresolved instead of recursing', () {
      final map = TiledMap.parseTmx(
        readFixture('map_nested.tmx'),
        providers: [FixtureProvider()],
      );
      final tileset = map.tilesetByName('nested');
      final tileObjects =
          (tileset.tiles.first.objectGroup! as ObjectGroup).objects;
      final templateTileset = tileObjects.single.template!.tileSet!;
      expect(templateTileset.source, equals('tilesets/nested_tileset.tsx'));
      expect(templateTileset.name, isNull);
    });

    test('objects outside of templates require an id', () {
      expect(
        () => TiledMap.parseTmx(readFixture('map_without_object_id.tmx')),
        throwsA(isA<ParsingException>()),
      );
    });
  });

  group('TiledMap.fromString', () {
    Future<String> Function(String) recordingLoader(List<String> loaded) {
      return (path) async {
        loaded.add(path);
        return readFixture(path);
      };
    }

    test('loads every referenced file exactly once for tmx maps', () async {
      final loaded = <String>[];
      final map = await TiledMap.fromString(
        readFixture('map_with_template.tmx'),
        recordingLoader(loaded),
      );
      expect(
        loaded,
        unorderedEquals([
          'tileset.tsx',
          'tileset_with_template.tsx',
          'object_template.tx',
        ]),
      );
      expectTemplatesResolved(map);
    });

    test('loads every referenced file exactly once for json maps', () async {
      final loaded = <String>[];
      final map = await TiledMap.fromString(
        readFixture('map_with_template.json'),
        recordingLoader(loaded),
      );
      expect(
        loaded,
        unorderedEquals([
          'tileset.tsx',
          'tileset_with_template.tsx',
          'object_template.tj',
          'object_template.tx',
        ]),
      );
      expectTemplatesResolved(map);
    });

    test('does not load anything for maps without external files', () async {
      final loaded = <String>[];
      final map = await TiledMap.fromString(
        readFixture('test.tmx'),
        recordingLoader(loaded),
      );
      expect(loaded, isEmpty);
      expect(map.tilesets, isNotEmpty);
    });

    test('loads files referenced from nested directories', () async {
      final loaded = <String>[];
      final map = await TiledMap.fromString(
        readFixture('map_nested.tmx'),
        recordingLoader(loaded),
      );
      expect(
        loaded,
        equals([
          'tilesets/nested_tileset.tsx',
          'tilesets/templates/nested_template.tx',
        ]),
      );
      expect(map.tilesetByName('nested').tiles, hasLength(1));
    });

    test('rejects xml that is not a map', () {
      expect(
        TiledMap.fromString(readFixture('tileset.tsx'), (path) async => ''),
        throwsA(equals('XML is not in TMX format')),
      );
    });

    test('propagates errors from the loader', () {
      expect(
        TiledMap.fromString(
          readFixture('map_images.tmx'),
          (path) async => throw FileSystemException('Missing $path'),
        ),
        throwsA(isA<FileSystemException>()),
      );
    });
  });
}
