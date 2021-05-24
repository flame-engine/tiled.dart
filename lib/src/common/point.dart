part of tiled;

/// Below is Tiled's documentation about how this structure is represented
/// on XML files:
///
/// <point>
/// Used to mark an object as a point.
/// The existing x and y attributes are used to determine the position of the
/// point.
class Point {
  double x;
  double y;

  Point({required this.x, required this.y});

  static Point parse(Parser parser) {
    return Point(
      x: parser.getDouble('x'),
      y: parser.getDouble('y'),
    );
  }

  static Point parseFromString(String point) {
    final split = point.split(',');
    return Point(
      x: double.parse(split[0]),
      y: double.parse(split[1]),
    );
  }
}
