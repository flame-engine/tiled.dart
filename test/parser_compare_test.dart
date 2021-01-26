import 'dart:io';

import 'package:test/test.dart';
import 'package:tiled/src/json/mapjson.dart';
import 'package:tiled/tiled.dart';

void main() {
  final parser = TileMapJsonParser();

  MapJson map;
  setUp(() {
    return File('./test/fixtures/testcsv.json').readAsString().then((xml) {
      map = parser.parse(xml);
      // var out = new File('jsonoutcome.json').openWrite();
      // out.write(map.toTileMap());
      // out.close();
    });
  });

  MapJson map2;
  setUp(() {
    return File('./test/fixtures/testzlib.json').readAsString().then((xml) {
      map2 = parser.parse(xml);
    });
  });


  MapJson map3;
  setUp(() {
    return File('./test/fixtures/testgzip.json').readAsString().then((xml) {
      map3 = parser.parse(xml);
    });
  });


  MapJson map4;
  setUp(() {
    return File('./test/fixtures/testbase64only.json').readAsString().then((xml) {
      map4 = parser.parse(xml);
    });
  });

  final tileparser = TileMapParser();
  TileMap tilemap;
  setUp(() {
    return File('./test/fixtures/test.tmx').readAsString().then((xml) {
      tilemap = tileparser.parse(xml);
      // var out = new File('tmxoutcome.json').openWrite();
      // out.write(tilemap);
      // out.close();
    });
  });


  MapJson map5;
  setUp(() {
    return File('./test/fixtures/complexmap.json').readAsString().then((xml) {
      map5 = parser.parse(xml);
    });
  });

  MapJson map6;
  setUp(() {
    return File('./test/fixtures/complexmap.tmx').readAsString().then((xml) {
      map6 = parser.parseXml(xml);
    });
  });

  final tileparserComplex = TileMapParser();
  TileMap tilemapComplex;
  setUp(() {
    return File('./test/fixtures/complexmap.tmx').readAsString().then((xml) {
      tilemapComplex = tileparserComplex.parse(xml);
    });
  });

  group('Parser compare', () {
    // test('toString should be equal', () => expect(map.toTileMap().toString(), equals(tilemap.toString())));
    // test('toString should be equal', () => expect(map2.toTileMap().toString(), equals(tilemap.toString())));
    // test('toString should be equal', () => expect(map3.toTileMap().toString(), equals(tilemap.toString())));
    // test('toString should be equal', () => expect(map4.toTileMap().toString(), equals(tilemap.toString())));
    //
    // test('toString should be equal', () => expect(map5.toTileMap().toString(), equals(tilemapComplex.toString())));
    test('toString should be equal', () => expect(map6.toTileMap().toString(), equals(tilemapComplex.toString())));
  });

}
