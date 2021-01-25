import 'package:xml/xml.dart';

class WangColorJson {
  String color;
  String name;
  double probability;
  int tile;

  WangColorJson({this.color, this.name, this.probability, this.tile});

  WangColorJson.fromXML(XmlElement xmlElement) {
    tile  = int.parse(xmlElement.getAttribute('tile'));
    probability  = double.parse(xmlElement.getAttribute('probability') ?? 0);
    color = xmlElement.getAttribute('color');
    name = xmlElement.getAttribute('name');
  }

  WangColorJson.fromJson(Map<String, dynamic> json) {
    color = json['color'];
    name = json['name'];
    probability = json['probability'] ?? 0;
    tile = json['tile'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['color'] = color;
    data['name'] = name;
    data['probability'] = probability;
    data['tile'] = tile;
    return data;
  }
}
