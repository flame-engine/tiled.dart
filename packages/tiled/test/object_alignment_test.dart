import 'package:flutter_test/flutter_test.dart';
import 'package:tiled/tiled.dart';

void main() {
  group('ObjectAlignment', () {
    test('ObjectAlignment.byName', () {
      expect(
        ObjectAlignment.byName('unspecified'),
        ObjectAlignment.unspecified,
      );
      expect(ObjectAlignment.byName('topleft'), ObjectAlignment.topLeft);
      expect(ObjectAlignment.byName('top'), ObjectAlignment.top);
      expect(ObjectAlignment.byName('topright'), ObjectAlignment.topRight);
      expect(ObjectAlignment.byName('left'), ObjectAlignment.left);
      expect(ObjectAlignment.byName('center'), ObjectAlignment.center);
      expect(ObjectAlignment.byName('right'), ObjectAlignment.right);
      expect(ObjectAlignment.byName('bottomleft'), ObjectAlignment.bottomLeft);
      expect(ObjectAlignment.byName('bottom'), ObjectAlignment.bottom);
      expect(
        ObjectAlignment.byName('bottomright'),
        ObjectAlignment.bottomRight,
      );
    });
  });
}
