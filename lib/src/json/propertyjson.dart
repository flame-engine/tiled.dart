import 'package:xml/src/xml/nodes/node.dart';

class PropertyJson {
  String name;
  String type;
  String value;

  PropertyJson({this.name, this.type, this.value});

  PropertyJson.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    type = json['type'];
    value = json['value'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['type'] = type;
    data['value'] = value;
    return data;
  }

  PropertyJson.fromXML(XmlNode element) {
    value = element.getAttribute('value');
    name = element.getAttribute('name');
    type = element.getAttribute('type');
  }
}
