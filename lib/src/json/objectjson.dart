import 'dart:math';

import 'package:tiled/src/json/pointjson.dart';
import 'package:tiled/src/json/propertyjson.dart';
import 'package:tiled/src/json/textjson.dart';
import 'package:tiled/tiled.dart';

class ObjectJson {
  bool ellipse;
  int gid;
  double height;
  int id;
  String name;
  bool point;
  List<PointJson> polygon = [];
  List<PointJson> polyline = [];
  List<PropertyJson> properties = [];
  double rotation;
  String template;
  TextJson text;
  String type;
  bool visible;
  double width;
  double x;
  double y;

  ObjectJson(
      {this.ellipse,
      this.gid,
      this.height,
      this.id,
      this.name,
      this.point,
      this.polygon,
      this.polyline,
      this.properties,
      this.rotation,
      this.template,
      this.text,
      this.type,
      this.visible,
      this.width,
      this.x,
      this.y});

  ObjectJson.fromJson(Map<String, dynamic> json) {
    ellipse = json['ellipse'];
    gid = json['gid'];
    height = json['height']?.toDouble();
    id = json['id'];
    name = json['name'];
    point = json['point'];
    if (json['polygon'] != null) {
      polygon = <PointJson>[];
      json['polygon'].forEach((v) {
        polygon.add(PointJson.fromJson(v));
      });
    }
    if (json['polyline'] != null) {
      polyline = <PointJson>[];
      json['polyline'].forEach((v) {
        polyline.add(PointJson.fromJson(v));
      });
    }
    if (json['properties'] != null) {
      properties = <PropertyJson>[];
      json['properties'].forEach((v) {
        properties.add(PropertyJson.fromJson(v));
      });
    }
    rotation = json['rotation']?.toDouble();
    template = json['template'];
    text = json['text'] != null ? TextJson.fromJson(json['text']) : null;
    type = json['type'];
    visible = json['visible'];
    width = json['width']?.toDouble();
    x = json['x']?.toDouble();
    y = json['y']?.toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ellipse'] = ellipse;
    data['gid'] = gid;
    data['height'] = height;
    data['id'] = id;
    data['name'] = name;
    data['point'] = point;
    if (polygon != null) {
      data['polygon'] = polygon.map((v) => v.toJson()).toList();
    }
    if (polyline != null) {
      data['polyline'] = polyline.map((v) => v.toJson()).toList();
    }

    if (properties != null) {
      data['properties'] = properties.map((v) => v.toJson()).toList();
    }
    data['rotation'] = rotation;
    data['template'] = template;
    if (text != null) {
      data['text'] = text.toJson();
    }
    data['type'] = type;
    data['visible'] = visible;
    data['width'] = width;
    data['x'] = x;
    data['y'] = y;
    return data;
  }

  TmxObject toTmxObject() {
    final TmxObject tmxObject = TmxObject();
    tmxObject.isEllipse = ellipse;
    tmxObject.gid = gid;
    tmxObject.height = height;
    tmxObject.name = name;
    tmxObject.rotation = rotation;
    tmxObject.type = type;
    tmxObject.visible = visible;
    tmxObject.width = width;
    tmxObject.x = x;
    tmxObject.y = y;

    //tmxObject.id = id; //TODO sorting
    tmxObject.properties = <String, dynamic>{};
    properties.forEach((element) {
      tmxObject.properties.putIfAbsent(element.name, () => element.value);
    });

    if (!ellipse) {
      if (polygon.isNotEmpty) {
        tmxObject.isPolygon = true;
        tmxObject.points = <Point>[];
        polygon.forEach((element) {
          tmxObject.points.add(element.toPoint());
        });
      } else if (polyline.isNotEmpty) {
        tmxObject.isPolyline = true;
        tmxObject.points = <Point>[];
        polyline.forEach((element) {
          tmxObject.points.add(element.toPoint());
        });
      }
      //tmxObject.isRectangle = false; //TODO How to detect?
      // tmxObject.point = point; //TODO No idea what this is

      //tmxObject.template = template;  //TODO No idea what this is
      //tmxObject.text = text; //TODO No equivalent in tmx
    }
    return tmxObject;
  }
}
