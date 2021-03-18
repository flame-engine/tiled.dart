import 'dart:io';

import 'package:test/test.dart';
import 'package:tiled/tiled.dart';

void main() {
  TiledMap oldmap;
  setUp(() {
    return File('./test/fixtures/test_old.tmx').readAsString().then((xml) {
      oldmap = TileMapParser.parseTmx(xml);
    });
  });

  TiledMap map;
  setUp(() {
    return File('./test/fixtures/testcsv.json').readAsString().then((xml) {
      map = TileMapParser.parseJson(xml);
    });
  });

  TiledMap map2;
  setUp(() {
    return File('./test/fixtures/testzlib.json').readAsString().then((xml) {
      map2 = TileMapParser.parseJson(xml);
    });
  });


  TiledMap map3;
  setUp(() {
    return File('./test/fixtures/testgzip.json').readAsString().then((xml) {
      map3 = TileMapParser.parseJson(xml);
    });
  });


  TiledMap map4;
  setUp(() {
    return File('./test/fixtures/testbase64only.json').readAsString().then((xml) {
      map4 = TileMapParser.parseJson(xml);
    });
  });

  TiledMap tilemap;
  setUp(() {
    return File('./test/fixtures/test.tmx').readAsString().then((xml) {
      tilemap = TileMapParser.parseTmx(xml);
    });
  });

  TiledMap tilemapEllipse;
  setUp(() {
    return File('./test/fixtures/map.tmx').readAsString().then((xml) {
      tilemapEllipse = TileMapParser.parseTmx(xml);
    });
  });


  TiledMap map5;
  setUp(() {
    return File('./test/fixtures/complexmap.json').readAsString().then((xml) {
      map5 = TileMapParser.parseJson(xml);
    });
  });

  TiledMap map6;
  setUp(() {
    return File('./test/fixtures/complexmap.tmx').readAsString().then((xml) {
      map6 = TileMapParser.parseTmx(xml);
    });
  });

  TiledMap tilemapComplex;
  setUp(() {
    return File('./test/fixtures/complexmap.tmx').readAsString().then((xml) {
      tilemapComplex = TileMapParser.parseTmx(xml);
    });
  });

  group('Parser compare', () {
    test('toString should be equal', () => expect(oldmap.type, equals(tilemap.type)));

    test('toString should be equal', () => expect(map.type, equals(tilemap.type)));
    test('toString should be equal', () => expect(map2.type, equals(tilemap.type)));
    test('toString should be equal', () => expect(map3.type, equals(tilemap.type)));
    test('toString should be equal', () => expect(map4.type, equals(tilemap.type)));

    test('toString should be equal', () => expect(map5.type, equals(tilemapComplex.type)));
    test('toString should be equal', () => expect(map6.type, equals(tilemapComplex.type)));
    test('toString should be equal', () => expect(tilemapEllipse.type, equals(tilemapComplex.type)));
  });

}
