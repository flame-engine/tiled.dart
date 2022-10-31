import 'dart:io';

import 'package:test/test.dart';
import 'package:tiled/tiled.dart';

void main() {
  late TiledMap map;
  setUp(() {
    return File('./test/fixtures/objectgroup.tmx').readAsString().then((xml) {
      map = TileMapParser.parseTmx(xml);
    });
  });

  group('TiledObject', () {
    late List<TiledObject> objects;
    setUp(() {
      objects = (map.layerByName('Test Object Layer 1') as ObjectGroup).objects;
    });

    group('Circle', () {
      late TiledObject tiledObject;
      setUp(() => tiledObject = objects[0]);

      test('sets name to "Circle"', () {
        expect(tiledObject.name, equals('Circle'));
      });

      test('sets type and class to "circle"', () {
        expect(tiledObject.type, equals('circle'));
        expect(tiledObject.class_, equals('circle'));
      });

      test('sets x to 344', () {
        expect(tiledObject.x, equals(344));
      });

      test('sets y to 179', () {
        expect(tiledObject.y, equals(179));
      });

      test('sets width to 55', () {
        expect(tiledObject.width, equals(55));
      });

      test('sets height to 53', () {
        expect(tiledObject.height, equals(53));
      });

      test('sets properties', () {
        final props = tiledObject.properties;
        expect(props.first.name, equals('property_name'));
        expect(
          props.getValue<String>('property_name'),
          equals('property_value'),
        );
      });

      test('sets isEllipse to true', () => expect(tiledObject.ellipse, isTrue));
    });

    group('Rectangle', () {
      late TiledObject tiledObject;
      setUp(() => tiledObject = objects[1]);

      test('sets name to "Rectangle"', () {
        expect(tiledObject.name, equals('Rectangle'));
      });

      test('sets type and class to "rectangle"', () {
        expect(tiledObject.type, equals('rectangle'));
        expect(tiledObject.class_, equals('rectangle'));
      });

      test('sets x to 541', () {
        expect(tiledObject.x, equals(541));
      });

      test('sets y to 271', () {
        expect(tiledObject.y, equals(271));
      });

      test('sets width to 46', () {
        expect(tiledObject.width, equals(46));
      });

      test('sets height to 43', () {
        expect(tiledObject.height, equals(43));
      });

      test('sets isRectangle to true', () {
        expect(tiledObject.isRectangle, isTrue);
      });
    });

    group('Polygon', () {
      late TiledObject tiledObject;
      setUp(() => tiledObject = objects[2]);

      test('sets name to "Polygon"', () {
        expect(tiledObject.name, equals('Polygon'));
      });

      test('sets type and class to "polygon"', () {
        expect(tiledObject.type, equals('polygon'));
        expect(tiledObject.class_, equals('polygon'));
      });

      test('sets x to 752', () {
        expect(tiledObject.x, equals(752));
      });

      test('sets y to 216', () {
        expect(tiledObject.y, equals(216));
      });

      test('populates the points list', () {
        final ps = tiledObject.polygon;
        expect(ps[0].x, equals(Point(x: 0, y: 0).x));
        expect(ps[0].y, equals(Point(x: 0, y: 0).y));
        expect(ps[1].x, equals(Point(x: -4, y: 81).x));
        expect(ps[1].y, equals(Point(x: -4, y: 81).y));
        expect(ps[2].x, equals(Point(x: -78, y: 19).x));
        expect(ps[2].y, equals(Point(x: -78, y: 19).y));
      });

      test(
        'sets isPolygon to true',
        () => expect(tiledObject.isPolygon, isTrue),
      );
    });

    group('Polyline', () {
      late TiledObject tiledObject;
      setUp(() => tiledObject = objects[3]);

      test('sets name to "Polyline"', () {
        expect(tiledObject.name, equals('Polyline'));
      });

      test('sets x to 1016', () {
        expect(tiledObject.x, equals(1016));
      });

      test('sets y to 141', () {
        expect(tiledObject.y, equals(141));
      });

      test('populates the points list', () {
        final ps = tiledObject.polyline;
        expect(ps[0].x, equals(Point(x: 0, y: 0).x));
        expect(ps[0].y, equals(Point(x: 0, y: 0).y));
        expect(ps[1].x, equals(Point(x: -5, y: 98).x));
        expect(ps[1].y, equals(Point(x: -5, y: 98).y));
        expect(ps[2].x, equals(Point(x: -49, y: 42).x));
        expect(ps[2].y, equals(Point(x: -49, y: 42).y));
      });

      test('sets isPolyline to true', () {
        expect(tiledObject.isPolyline, isTrue);
      });
    });
  });
}
