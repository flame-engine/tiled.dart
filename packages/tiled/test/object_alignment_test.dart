import 'package:flutter_test/flutter_test.dart';
import 'package:tiled/tiled.dart';

void main() {
  group('ObjectAlignment', () {
    test('ObjectAlignment.byName', () {
      expect(
        ObjectAlignment.fromName('unspecified'),
        ObjectAlignment.unspecified,
      );
      expect(ObjectAlignment.fromName('topleft'), ObjectAlignment.topLeft);
      expect(ObjectAlignment.fromName('top'), ObjectAlignment.top);
      expect(ObjectAlignment.fromName('topright'), ObjectAlignment.topRight);
      expect(ObjectAlignment.fromName('left'), ObjectAlignment.left);
      expect(ObjectAlignment.fromName('center'), ObjectAlignment.center);
      expect(ObjectAlignment.fromName('right'), ObjectAlignment.right);
      expect(ObjectAlignment.fromName('bottomleft'), ObjectAlignment.bottomLeft);
      expect(ObjectAlignment.fromName('bottom'), ObjectAlignment.bottom);
      expect(
        ObjectAlignment.fromName('bottomright'),
        ObjectAlignment.bottomRight,
      );
    });
  });
}
