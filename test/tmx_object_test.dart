import 'package:test/test.dart';
import 'package:tiled/tiled.dart';
import 'package:xml/xml.dart';
import 'dart:io';
import 'dart:math';

void main() {
  XmlElement xmlRoot;
  setUp(() {
    return File('./test/fixtures/objectgroup.tmx').readAsString().then((xml) {
      xmlRoot = XmlDocument.parse(xml).rootElement;
    });
  });

  group('TmxObject.fromXML', () {
    List<XmlElement> objects;
    setUp(() => objects = xmlRoot.findAllElements('object').toList());

    group('Circle', () {
      TmxObject tmxObject;
      setUp(() => tmxObject = TmxObject.fromXML(objects[0]));

      test('sets name to "Circle"', () {
        expect(tmxObject.name, equals("Circle"));
      });

      test('sets type to "circle"', () {
        expect(tmxObject.type, equals("circle"));
      });

      test('sets x to 344', () {
        expect(tmxObject.x, equals(344));
      });

      test('sets y to 179', () {
        expect(tmxObject.y, equals(179));
      });

      test('sets width to 55', () {
        expect(tmxObject.width, equals(55));
      });

      test('sets height to 53', () {
        expect(tmxObject.height, equals(53));
      });

      test('sets properties', () {
        expect(tmxObject.properties['property_name'], equals('property_value'));
      });

      test('sets isEllipse to true', () => expect(tmxObject.isEllipse, isTrue));
    });

    group('Rectangle', () {
      TmxObject tmxObject;
      setUp(() => tmxObject = TmxObject.fromXML(objects[1]));

      test('sets name to "Rectangle"', () {
        expect(tmxObject.name, equals("Rectangle"));
      });

      test('sets type to "rectangle"', () {
        expect(tmxObject.type, equals("rectangle"));
      });

      test('sets x to 541', () {
        expect(tmxObject.x, equals(541));
      });

      test('sets y to 271', () {
        expect(tmxObject.y, equals(271));
      });

      test('sets width to 46', () {
        expect(tmxObject.width, equals(46));
      });

      test('sets height to 43', () {
        expect(tmxObject.height, equals(43));
      });

      test('sets isRectangle to true', () {
        expect(tmxObject.isRectangle, isTrue);
      });
    });

    group('Polygon', () {
      TmxObject tmxObject;
      setUp(() => tmxObject = TmxObject.fromXML(objects[2]));

      test('sets name to "Polygon"', () {
        expect(tmxObject.name, equals("Polygon"));
      });

      test('sets type to "polygon"', () {
        expect(tmxObject.type, equals("polygon"));
      });

      test('sets x to 752', () {
        expect(tmxObject.x, equals(752));
      });

      test('sets y to 216', () {
        expect(tmxObject.y, equals(216));
      });

      test('populates the points list', () {
        final ps = tmxObject.points;
        expect(ps[0], equals(const Point(0, 0)));
        expect(ps[1], equals(const Point(-4, 81)));
        expect(ps[2], equals(const Point(-78, 19)));
      });

      test('sets isPolygon to true', () => expect(tmxObject.isPolygon, isTrue));
    });

    group('Polyline', () {
      TmxObject tmxObject;
      setUp(() => tmxObject = TmxObject.fromXML(objects[3]));

      test('sets name to "Polyline"', () {
        expect(tmxObject.name, equals("Polyline"));
      });

      test('sets x to 1016', () {
        expect(tmxObject.x, equals(1016));
      });

      test('sets y to 141', () {
        expect(tmxObject.y, equals(141));
      });

      test('populates the points list', () {
        final ps = tmxObject.points;
        expect(ps[0], equals(const Point(0, 0)));
        expect(ps[1], equals(const Point(-5, 98)));
        expect(ps[2], equals(const Point(-49, 42)));
      });

      test('sets isPolyline to true', () {
        expect(tmxObject.isPolyline, isTrue);
      });
    });
  });
}
