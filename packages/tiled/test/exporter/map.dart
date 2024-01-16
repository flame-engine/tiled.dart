import 'package:test/test.dart';
import 'package:tiled/tiled.dart';
import 'package:xml/xml.dart';

void main() {
  late TiledMap export;
  setUp(() => export = TiledMap(
        width: 576,
        height: 432,
        tileWidth: 48,
        tileHeight: 48,
        orientation: MapOrientation.hexagonal,
        renderOrder: RenderOrder.leftUp,
        hexSideLength: 24,
        staggerAxis: StaggerAxis.y,
        staggerIndex: StaggerIndex.even,
        backgroundColor: ColorData.hex(0xaa252627),
        nextLayerId: 24,
        nextObjectId: 56,
        infinite: false,
        layers: [
          TileLayer(name: 'test1', width: 48, height: 48),
          TileLayer(name: 'test2', width: 48, height: 48),
          TileLayer(name: 'test3', width: 48, height: 48),
        ],
        tilesets: [
          Tileset(firstGid: 1, source: 'xyz.png'),
          Tileset(firstGid: 20, source: 'xyz.png'),
        ],
      ));

  group('Exporter - Map', () {
    test(
      'Xml',
      () => testSuite(XmlParser(export.exportXml() as XmlElement)),
    );
    test(
      'Json',
      () => testSuite(JsonParser(export.exportJson() as Map<String, dynamic>)),
    );
  });
}

void testSuite(Parser export) {
  void attribute(String name, String expected) =>
      expect(export.getString(name), equals(expected));

  attribute('height', '432');
  attribute('width', '576');
  attribute('tilewidth', '48');
  attribute('tileheight', '48');
  attribute('version', '1.10');
  attribute('type', TileMapType.map.name);
  attribute('orientation', MapOrientation.hexagonal.name);
  attribute('renderorder', RenderOrder.leftUp.name);
  attribute('hexsidelength', '24');
  attribute('staggeraxis', StaggerAxis.y.name);
  attribute('staggerindex', StaggerIndex.even.name);
  attribute('backgroundcolor', '#aa252627');
  attribute('nextlayerid', '24');
  attribute('nextobjectid', '56');
  attribute(
      'infinite', export.formatSpecificParsing((p0) => 'false', (p0) => '0'));

  final layers = export.formatSpecificParsing(
    (e) => e.getChildren('layers'),
    (e) => e.getChildren('layer'),
  );
  expect(layers.length, equals(3));

  final tilesets = export.formatSpecificParsing(
    (e) => e.getChildren('tilesets'),
    (e) => e.getChildren('tileset'),
  );
  expect(tilesets.length, equals(2));
}
