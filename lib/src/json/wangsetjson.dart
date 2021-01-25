import 'package:tiled/src/json/propertyjson.dart';
import 'package:tiled/src/json/wangcolorjson.dart';
import 'package:tiled/src/json/wangtilejson.dart';

class WangSetJson {
  List<WangColorJson> cornercolors = [];
  List<WangColorJson> edgecolors = [];
  String name;
  List<PropertyJson> properties = [];
  int tile;
  List<WangTileJson> wangtiles = [];

  WangSetJson(
      {this.cornercolors,
      this.edgecolors,
      this.name,
      this.properties,
      this.tile,
      this.wangtiles});

  WangSetJson.fromJson(Map<String, dynamic> json) {
    if (json['cornercolors'] != null) {
      cornercolors = <WangColorJson>[];
      json['cornercolors'].forEach((v) {
        cornercolors.add(WangColorJson.fromJson(v));
      });
    }
    if (json['edgecolors'] != null) {
      edgecolors = <WangColorJson>[];
      json['edgecolors'].forEach((v) {
        edgecolors.add(WangColorJson.fromJson(v));
      });
    }
    name = json['name'];
    if (json['properties'] != null) {
      properties = <PropertyJson>[];
      json['properties'].forEach((v) {
        properties.add(PropertyJson.fromJson(v));
      });
    }
    tile = json['tile'];
    if (json['wangtiles'] != null) {
      wangtiles = <WangTileJson>[];
      json['wangtiles'].forEach((v) {
        wangtiles.add(WangTileJson.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (cornercolors != null) {
      data['cornercolors'] = cornercolors.map((v) => v.toJson()).toList();
    }
    if (edgecolors != null) {
      data['edgecolors'] = edgecolors.map((v) => v.toJson()).toList();
    }
    data['name'] = name;
    if (properties != null) {
      data['properties'] = properties.map((v) => v.toJson()).toList();
    }
    data['tile'] = tile;
    if (wangtiles != null) {
      data['wangtiles'] = wangtiles.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
