import 'package:test/test.dart';
import 'package:tiled/tiled.dart';
import 'package:xml/xml.dart';
import 'dart:io';

void main() {
  late XmlElement xmlRoot;
  setUp(() {
    return File('./test/fixtures/objectgroup.tmx').readAsString().then((xml) {
      xmlRoot = XmlDocument.parse(xml).rootElement;
    });
  });

  group('ObjectGroup.fromXML', () {
    late ObjectGroup objectGroup;
    late XmlElement xml;

    setUp(() {
      xml = xmlRoot.findAllElements('objectgroup').first;
      objectGroup = ObjectGroup.fromXML(xml);
    });

    test('sets name', () {
      expect(objectGroup.name, equals('Test Object Layer 1'));
    });

    test('sets color', () {
      expect(objectGroup.color, equals('#555500'));
    });

    test('sets opacity', () {
      expect(objectGroup.opacity, equals(0.7));
    });

    test('sets visible', () {
      expect(objectGroup.visible, equals(true));

      final xml = xmlRoot.findAllElements('objectgroup').last;
      objectGroup = ObjectGroup.fromXML(xml);

      expect(objectGroup.visible, equals(false));
    });

    test('populates tmxObjects', () {
      expect(objectGroup.tmxObjects.length, greaterThan(0));
    });
  });
}
