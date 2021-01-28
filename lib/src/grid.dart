part of tiled;

class Grid {
  int height;
  String orientation;
  int width;

  Grid.fromXml(XmlElement xmlElement) {
    height  = int.tryParse(xmlElement.getAttribute('height') ?? '');
    width  = int.tryParse(xmlElement.getAttribute('width') ?? '');
    orientation  = xmlElement.getAttribute('orientation');
  }

  Grid.fromJson(Map<String, dynamic> json) {
    height = json['height'];
    orientation = json['orientation'];
    width = json['width'];
  }
}
