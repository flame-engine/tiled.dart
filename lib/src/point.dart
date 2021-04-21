part of tiled;

class Point {
  double x;
  double y;

  Point(this.x, this.y);

  Point.fromXml(XmlElement xmlElement) {
    x = double.tryParse(xmlElement.getAttribute('x') ?? '');
    y = double.tryParse(xmlElement.getAttribute('y') ?? '');
  }

  Point.fromJson(Map<String, dynamic> json) {
    x = json['x'];
    y = json['y'];
  }
}
