class Rect {
  final double x;
  final double y;
  final double width;
  final double height;

  Rect.fromLTWH(this.x, this.y, this.width, this.height);

  @override
  bool operator ==(Object other) {
    if (other is! Rect) return false;
    return x == other.x && y == other.y && width == other.width && height == other.height;
  }

  @override
  int get hashCode => Object.hash(x, y, width, height);
}