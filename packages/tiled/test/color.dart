import 'dart:math';

import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';
import 'package:tiled/tiled.dart';

void main() {
  group("ColorData.hex", () {
    test("parse", () {
      final random = Random();
      final red = random.nextInt(256);
      final green = random.nextInt(256);
      final blue = random.nextInt(256);
      final alpha = random.nextInt(256);

      final hex = alpha << 24 | red << 16 | green << 8 | blue << 0;
      final data = ColorData.hex(hex);

      expect(data.alpha, equals(alpha));
      expect(data.red, equals(red));
      expect(data.green, equals(green));
      expect(data.blue, equals(blue));
    });
  });
}