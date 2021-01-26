import 'package:xml/xml.dart';

class GridJson {
  int height;
  String orientation;
  int width;

  GridJson({this.height, this.orientation, this.width});

  GridJson.fromXML(XmlElement xmlElement) {
    height  = int.tryParse(xmlElement.getAttribute('height') ?? '');
    width  = int.tryParse(xmlElement.getAttribute('width') ?? '');
    orientation  = xmlElement.getAttribute('orientation');
  }

  GridJson.fromJson(Map<String, dynamic> json) {
    height = json['height'];
    orientation = json['orientation'];
    width = json['width'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['height'] = height;
    data['orientation'] = orientation;
    data['width'] = width;
    return data;
  }
}
