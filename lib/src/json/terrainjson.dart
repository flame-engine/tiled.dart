import 'package:tiled/src/json/propertyjson.dart';
import 'package:xml/xml.dart';

class TerrainJson {
  String name;
  List<PropertyJson> properties = [];
  int tile;

  TerrainJson({this.name, this.properties, this.tile});

  TerrainJson.fromXML(XmlElement xmlElement) {
    name  = xmlElement.getAttribute('name');
    tile  = int.parse(xmlElement.getAttribute('tile'));
    xmlElement.children.whereType<XmlElement>().forEach((XmlElement element) {
      switch (element.name.local) {
        case 'properties':
          element.nodes.forEach((element) {properties.add(PropertyJson.fromXML(element));});
          break;
      }
    });
  }

  TerrainJson.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    if (json['properties'] != null) {
      properties = <PropertyJson>[];
      json['properties'].forEach((v) {
        properties.add(PropertyJson.fromJson(v));
      });
    }
    tile = json['tile'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    if (properties != null) {
      data['properties'] = properties.map((v) => v.toJson()).toList();
    }
    data['tile'] = tile;
    return data;
  }
}
