import 'package:unittest/unittest.dart';
import 'package:tmx/tmx.dart';

void main() {
  //TODO: Bad test/pattern here.
  test('Tileset.tileProperties is present', () {
    Tileset ts = new Tileset(1);
    expect(ts.tileProperties, new isInstanceOf<Map>());
  });
}