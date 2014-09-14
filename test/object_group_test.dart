import 'package:unittest/unittest.dart';
import 'package:tmx/tmx.dart';
import 'package:xml/xml.dart';
import 'dart:io';

void main() {
  XmlElement xmlRoot;
  setUp( () {
    return new File('./test/fixtures/objectgroup.tmx').readAsString().then((xml) {
      xmlRoot = parse(xml).rootElement;
    });
  });

  group('ObjectGroup.fromXML', () {
    var objectGroup;
    var xml;

    setUp(() {
      xml = xmlRoot.findAllElements('objectgroup').first;
      objectGroup = new ObjectGroup.fromXML(xml);
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

      var xml = xmlRoot.findAllElements('objectgroup').last;
      objectGroup = new ObjectGroup.fromXML(xml);

      expect(objectGroup.visible, equals(false));
    });

    test('populates tmxObjects', () {
      expect(objectGroup.tmxObjects.length, greaterThan(0));
    });
  });
}
