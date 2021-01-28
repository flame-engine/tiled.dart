part of tiled;

class Property {
  String name;
  String type;
  String value;

  Property.fromXml(XmlNode element) {
    value = element.getAttribute('value');
    name = element.getAttribute('name');
    type = element.getAttribute('type');
  }

  Property.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    type = json['type'];
    value = json['value'].toString();
  }
}
