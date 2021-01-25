import 'package:tiled/src/json/propertyjson.dart';

class TerrainJson {
  String name;
  List<PropertyJson> properties = [];
  int tile;

  TerrainJson({this.name, this.properties, this.tile});

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
