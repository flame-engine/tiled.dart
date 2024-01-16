import 'package:collection/collection.dart';
import 'package:test/test.dart';
import 'package:tiled/tiled.dart';
import 'package:xml/xml.dart';

void main() {
  late TiledObject export;
  late CustomProperties byName;
  setUp(() {
    byName = CustomProperties([
      StringProperty(name: 'test_string', value: 'test'),
    ].groupFoldBy((e) => e.name, (old, e) => e));

    export = TiledObject(id: 5, properties: byName);
  });

  void testSuite(Parser export) {
    final properties = export.getProperties();
    expect(properties.length, equals(byName.length));

    for (final property in properties) {
      final match = byName
          .where((e) => e.name == property.name && e.value == property.value);
      expect(match.length, equals(1));
    }
  }

  group('Exporter - CustomProperties', () {
    test('Xml', () => testSuite(XmlParser(export.exportXml() as XmlElement)));
    test(
        'Json',
        () =>
            testSuite(JsonParser(export.exportJson() as Map<String, dynamic>)));
  });
}
