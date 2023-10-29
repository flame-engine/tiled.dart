part of tiled;

const _mask = 0xff;

int _sub(int hex, int index) {
  final value = (hex & (_mask << index * 8)) >> index * 8;
  assert(value >= 0 && value < 256);
  return value;
}

class Color {
  final int red;
  final int green;
  final int blue;
  final int alpha;

  /// Format: aarrggbb
  Color.hex(int hex)
      : alpha = _sub(hex, 3),
        red = _sub(hex, 2),
        green = _sub(hex, 1),
        blue = _sub(hex, 0);

  const Color.rgb(this.red, this.green, this.blue, [this.alpha = 255])
      : assert(red >= 0 && red <= 255),
        assert(green >= 0 && green <= 255),
        assert(blue >= 0 && blue <= 255),
        assert(alpha >= 0 && alpha <= 255);
}
