part of tiled;

/// Basic data class holding a Color in ARGB format.
/// This can be converted to dart:ui's Color using the flame_tiled package
@immutable
class ColorData {
  static int _sub(int hex, int index) => (hex >> index * 8) & 0x000000ff;

  final int _hex;

  int get alpha => _sub(_hex, 3);

  int get red => _sub(_hex, 2);

  int get green => _sub(_hex, 1);

  int get blue => _sub(_hex, 0);

  /// Parses the Color from an int using the lower 32-bits and tiled's format: 0xaarrggbb
  const ColorData.hex(this._hex);

  const ColorData.rgb(int red, int green, int blue, [int alpha = 255])
      : assert(red >= 0 && red <= 255),
        assert(green >= 0 && green <= 255),
        assert(blue >= 0 && blue <= 255),
        assert(alpha >= 0 && alpha <= 255),
        _hex = (alpha << 3 * 8) + (red << 2 * 8) + (green << 1 * 8) +
            (blue << 0 * 8);

  const ColorData.argb(int alpha, int red, int green, int blue)
      : assert(red >= 0 && red <= 255),
        assert(green >= 0 && green <= 255),
        assert(blue >= 0 && blue <= 255),
        assert(alpha >= 0 && alpha <= 255),
        _hex = (alpha << 3 * 8) + (red << 2 * 8) + (green << 1 * 8) +
            (blue << 0 * 8);

  @override
  bool operator ==(Object other) {
    if (other is! ColorData) return false;
    return _hex == other._hex;
  }

  @override
  int get hashCode => _hex.hashCode;
}
