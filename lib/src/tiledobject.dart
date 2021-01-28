part of tiled;

class TiledObject {
  bool ellipse = false;
  int gid;
  double height;
  int id;
  String name;
  bool point = false;
  List<Point> polygon = [];
  List<Point> polyline = [];
  List<Property> properties = [];
  double rotation;
  String template;
  Text text;
  String type;
  bool visible;
  double width;
  double x;
  double y;

  TiledObject.fromXml(XmlNode xmlElement) {
    x = double.tryParse(xmlElement.getAttribute('x') ?? 0);
    y = double.tryParse(xmlElement.getAttribute('y') ?? 0);
    height = double.tryParse(xmlElement.getAttribute('height') ?? '0');
    width = double.tryParse(xmlElement.getAttribute('width') ?? '0');
    rotation = double.tryParse(xmlElement.getAttribute('rotation') ?? '0');
    visible = int.tryParse(xmlElement.getAttribute('visible') ?? '1') == 1;
    id = int.tryParse(xmlElement.getAttribute('id') ?? '');
    gid = int.tryParse(xmlElement.getAttribute('gid') ?? '');
    name = xmlElement.getAttribute('name');
    type = xmlElement.getAttribute('type');

    xmlElement.children.whereType<XmlElement>().forEach((XmlElement element) {
      switch (element.name.local) {
        case 'ellipse':
          ellipse = true;
          break;
        case 'point':
          point = true;
          break;
        case 'polygon':
          polygon = [];
          element.children.whereType<XmlElement>().forEach((XmlElement pointElement) {
            polygon.add(Point.fromXml(pointElement));
          });
          break;
        case 'polyline':
          polyline = [];
          element.children.whereType<XmlElement>().forEach((XmlElement pointElement) {
            polyline.add(Point.fromXml(pointElement));
          });
          break;
        case 'text':
          text = Text.fromXml(element);
          break;
      }
    });
    //TODO template;
  }

  TiledObject.fromJson(Map<String, dynamic> json) {
    ellipse = json['ellipse'];
    gid = json['gid'];
    height = json['height']?.toDouble();
    id = json['id'];
    name = json['name'];
    point = json['point'];
    if (json['polygon'] != null) {
      polygon = <Point>[];
      json['polygon'].forEach((v) {
        polygon.add(Point.fromJson(v));
      });
    }
    if (json['polyline'] != null) {
      polyline = <Point>[];
      json['polyline'].forEach((v) {
        polyline.add(Point.fromJson(v));
      });
    }
    if (json['properties'] != null) {
      properties = <Property>[];
      json['properties'].forEach((v) {
        properties.add(Property.fromJson(v));
      });
    }
    rotation = json['rotation']?.toDouble();
    template = json['template'];
    text = json['text'] != null ? Text.fromJson(json['text']) : null;
    type = json['type'];
    visible = json['visible'];
    width = json['width']?.toDouble();
    x = json['x']?.toDouble();
    y = json['y']?.toDouble();
  }
}
