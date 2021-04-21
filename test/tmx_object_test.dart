import 'dart:io';
import 'dart:math';

import 'package:test/test.dart';
import 'package:tiled/tiled.dart';

void main() {
  TiledMap map;
  setUp(() {
    return File('./test/fixtures/objectgroup.tmx').readAsString().then((xml) {
      map = TileMapParser.parseTmx(xml);
    });
  });

  group('TiledObject', () {
    List<TiledObject> objects;
    setUp(() => objects = map.getLayerByName('Test Object Layer 1').objects);

    group('Circle', () {
      TiledObject tiledObject;
      setUp(() => tiledObject = objects[0]);

      test('sets name to "Circle"', () {
        expect(tiledObject.name, equals("Circle"));
      });

      test('sets type to "circle"', () {
        expect(tiledObject.type, equals("circle"));
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
        final List<Property> props = tiledObject.properties;
        expect(props[0].name, equals('property_name'));
        expect(props[0].value, equals('property_value'));
      });

      test('sets isEllipse to true', () => expect(tiledObject.ellipse, isTrue));
    });

    group('Rectangle', () {
      TiledObject tiledObject;
      setUp(() => tiledObject = objects[1]);

      test('sets name to "Rectangle"', () {
        expect(tiledObject.name, equals("Rectangle"));
      });

      test('sets type to "rectangle"', () {
        expect(tiledObject.type, equals("rectangle"));
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
      TiledObject tiledObject;
      setUp(() => tiledObject = objects[2]);

      test('sets name to "Polygon"', () {
        expect(tiledObject.name, equals("Polygon"));
      });

      test('sets type to "polygon"', () {
        expect(tiledObject.type, equals("polygon"));
      });

      test('sets x to 752', () {
        expect(tiledObject.x, equals(752));
      });

      test('sets y to 216', () {
        expect(tiledObject.y, equals(216));
      });

      test('populates the points list', () {
        final ps = tiledObject.polygon;
        expect(ps[0].x, equals(Point(0, 0).x));
        expect(ps[0].y, equals(Point(0, 0).y));
        expect(ps[1].x, equals(Point(-4, 81).x));
        expect(ps[1].y, equals(Point(-4, 81).y));
        expect(ps[2].x, equals(Point(-78, 19).x));
        expect(ps[2].y, equals(Point(-78, 19).y));
      });

      test('sets isPolygon to true',
          () => expect(tiledObject.isPolygon, isTrue));
    });

    group('Polyline', () {
      TiledObject tiledObject;
      setUp(() => tiledObject = objects[3]);

      test('sets name to "Polyline"', () {
        expect(tiledObject.name, equals("Polyline"));
      });

      test('sets x to 1016', () {
        expect(tiledObject.x, equals(1016));
      });

      test('sets y to 141', () {
        expect(tiledObject.y, equals(141));
      });

      test('populates the points list', () {
        final ps = tiledObject.polyline;
        expect(ps[0].x, equals(Point(0, 0).x));
        expect(ps[0].y, equals(Point(0, 0).y));
        expect(ps[1].x, equals(Point(-5, 98).x));
        expect(ps[1].y, equals(Point(-5, 98).y));
        expect(ps[2].x, equals(Point(-49, 42).x));
        expect(ps[2].y, equals(Point(-49, 42).y));
      });

      test('sets isPolyline to true', () {
        expect(tiledObject.isPolyline, isTrue);
      });
    });
  });
}
