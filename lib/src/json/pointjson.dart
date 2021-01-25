import 'dart:math';

class PointJson {
  num x;
  num y;

  PointJson({this.x, this.y});

  PointJson.fromJson(Map<String, dynamic> json) {
    x = json['x'];
    y = json['y'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['x'] = x;
    data['y'] = y;
    return data;
  }

  Point<num> toPoint() {
    return Point(x, y);
  }
}
