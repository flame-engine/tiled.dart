import 'dart:io';

import 'package:test/test.dart';
import 'package:tiled/tiled.dart';

void main() {
  late TiledMap oldMap;
  setUp(() {
    return File('./test/fixtures/test_old.tmx').readAsString().then((xml) {
      oldMap = TiledMap.parseTmx(xml);
    });
  });

  late TiledMap map;
  setUp(() {
    return File('./test/fixtures/testcsv.json').readAsString().then((xml) {
      map = TiledMap.parseJson(xml);
    });
  });

  late TiledMap map2;
  setUp(() {
    return File('./test/fixtures/testzlib.json').readAsString().then((xml) {
      map2 = TiledMap.parseJson(xml);
    });
  });

  late TiledMap map3;
  setUp(() {
    return File('./test/fixtures/testgzip.json').readAsString().then((xml) {
      map3 = TiledMap.parseJson(xml);
    });
  });

  late TiledMap map4;
  setUp(() {
    return File('./test/fixtures/testbase64only.json')
        .readAsString()
        .then((xml) {
      map4 = TiledMap.parseJson(xml);
    });
  });

  late TiledMap tileMapCsv;
  setUp(() {
    return File('./test/fixtures/test_csv.tmx').readAsString().then((xml) {
      tileMapCsv = TiledMap.parseTmx(xml);
    });
  });

  late TiledMap tileMap;
  setUp(() {
    return File('./test/fixtures/test.tmx').readAsString().then((xml) {
      tileMap = TiledMap.parseTmx(xml);
    });
  });

  late TiledMap tileMapEllipse;
  setUp(() {
    return File('./test/fixtures/map.tmx').readAsString().then((xml) {
      tileMapEllipse = TiledMap.parseTmx(xml);
    });
  });

  late TiledMap map5;
  setUp(() {
    return File('./test/fixtures/complexmap.json').readAsString().then((xml) {
      map5 = TiledMap.parseJson(xml);
    });
  });

  late TiledMap map6;
  setUp(() {
    return File('./test/fixtures/complexmap.tmx').readAsString().then((xml) {
      map6 = TiledMap.parseTmx(xml);
    });
  });

  late TiledMap tileMapComplex;
  setUp(() {
    return File('./test/fixtures/complexmap.tmx').readAsString().then((xml) {
      tileMapComplex = TiledMap.parseTmx(xml);
    });
  });

  group('Parser compare', () {
    test(
      'toString should be equal',
      () => expect(oldMap.type, equals(tileMap.type)),
    );

    test(
      'toString should be equal',
      () => expect(map.type, equals(tileMap.type)),
    );
    test(
      'toString should be equal',
      () => expect(map2.type, equals(tileMap.type)),
    );
    test(
      'toString should be equal',
      () => expect(map3.type, equals(tileMap.type)),
    );
    test(
      'toString should be equal',
      () => expect(map4.type, equals(tileMap.type)),
    );
    test(
      'toString should be equal',
      () => expect(tileMapCsv.type, equals(tileMap.type)),
    );

    test(
      'toString should be equal',
      () => expect(map5.type, equals(tileMapComplex.type)),
    );
    test(
      'toString should be equal',
      () => expect(map6.type, equals(tileMapComplex.type)),
    );
    test(
      'toString should be equal',
      () => expect(tileMapEllipse.type, equals(tileMapComplex.type)),
    );
  });
}
