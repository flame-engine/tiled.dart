part of tiled;

class Point {
  num x;
  num y;

  Point.fromXml(XmlElement xmlElement) {
    x  = int.tryParse(xmlElement.getAttribute('x') ?? '');
    y  = int.tryParse(xmlElement.getAttribute('y') ?? '');
  }

  Point.fromJson(Map<String, dynamic> json) {
    x = json['x'];
    y = json['y'];
  }
}
