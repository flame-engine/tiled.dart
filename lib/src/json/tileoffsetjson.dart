import 'package:xml/xml.dart';

class TileOffsetJson {
  int x;
  int y;

  TileOffsetJson({this.x, this.y}); //TODO remove all Constructors

  TileOffsetJson.fromXML(XmlElement xmlElement) {
    x  = int.tryParse(xmlElement.getAttribute('x') ?? '');
    y  = int.tryParse(xmlElement.getAttribute('y') ?? '');
  }

  TileOffsetJson.fromJson(Map<String, dynamic> json) {
    x = json['x'];
    y = json['y'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['x'] = x;
    data['y'] = y;
    return data;
  }
}
