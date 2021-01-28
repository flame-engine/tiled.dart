import 'dart:io';

import 'package:test/test.dart';
import 'package:tiled/tiled.dart';

void main() {

  TiledMap map;
  setUp(() {
    return File('./test/fixtures/testcsv.json').readAsString().then((xml) {
      map = TileMapParser.parseJson(xml);
      // var out = new File('jsonoutcome.json').openWrite();
      // out.write(map.toTileMap());
      // out.close();
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
      // var out = new File('tmxoutcome.json').openWrite();
      // out.write(tilemap);
      // out.close();
    });
  });

  TiledMap tilemapEllipse;
  setUp(() {
    return File('./test/fixtures/map.tmx').readAsString().then((xml) {
      tilemapEllipse = TileMapParser.parseTmx(xml);
      // var out = new File('tmxoutcome.json').openWrite();
      // out.write(tilemap);
      // out.close();
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
    test('toString should be equal', () => expect(map, equals(tilemap)));
    test('toString should be equal', () => expect(map2, equals(tilemap)));
    test('toString should be equal', () => expect(map3, equals(tilemap)));
    test('toString should be equal', () => expect(map4, equals(tilemap)));

    test('toString should be equal', () => expect(map5, equals(tilemapComplex)));
    test('toString should be equal', () => expect(map6, equals(tilemapComplex)));
    test('toString should be equal', () => expect(tilemapEllipse, equals(tilemapComplex)));
  });

}
