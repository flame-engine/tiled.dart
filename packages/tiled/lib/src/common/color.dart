part of tiled;

class ColorData {
  static int _sub(int hex, int index) => (hex >> index * 8) & 0x000000ff;

  final int red;
  final int green;
  final int blue;
  final int alpha;

  /// Format: aarrggbb
  ColorData.hex(int hex)
      : alpha = _sub(hex, 3),
        red = _sub(hex, 2),
        green = _sub(hex, 1),
        blue = _sub(hex, 0);

  const ColorData.rgb(this.red, this.green, this.blue, [this.alpha = 255])
      : assert(red >= 0 && red <= 255),
        assert(green >= 0 && green <= 255),
        assert(blue >= 0 && blue <= 255),
        assert(alpha >= 0 && alpha <= 255);
}
