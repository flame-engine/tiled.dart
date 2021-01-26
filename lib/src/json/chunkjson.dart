import 'package:xml/xml.dart';

class ChunkJson {
  String
      data; // TODO array or string - 	Array of unsigned int (GIDs) or base64-encoded data
  int height;
  int width;
  int x;
  int y;

  ChunkJson({this.data, this.height, this.width, this.x, this.y});

  ChunkJson.fromXML(XmlNode xmlElement) {
    height = int.tryParse(xmlElement.getAttribute('height') ?? '');
    width = int.tryParse(xmlElement.getAttribute('width') ?? '');
    x = int.tryParse(xmlElement.getAttribute('x') ?? '');
    y = int.tryParse(xmlElement.getAttribute('y') ?? '');
    //TODO data
  }

  ChunkJson.fromJson(Map<String, dynamic> json) {
    data = json['data'];
    height = json['height'];
    width = json['width'];
    x = json['x'];
    y = json['y'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['data'] = data;
    data['height'] = height;
    data['width'] = width;
    data['x'] = x;
    data['y'] = y;
    return data;
  }
}
