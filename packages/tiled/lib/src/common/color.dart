part of tiled;

const _mask = 0xff;
int _sub(int hex, int index) => (hex & (_mask << index * 8)) >> index * 8;

class Color extends RgbColor {
  /// Format: aarrggbb
  Color(int hex) : super(_sub(hex, 2), _sub(hex, 1), _sub(hex, 0), _sub(hex, 3));
}
