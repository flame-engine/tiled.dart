import 'dart:math';

import 'package:tiled/src/json/pointjson.dart';
import 'package:tiled/src/json/propertyjson.dart';
import 'package:tiled/src/json/textjson.dart';
import 'package:tiled/tiled.dart';
import 'package:xml/xml.dart';

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

  ObjectJson.fromXML(XmlNode xmlElement) {
    x = double.tryParse(xmlElement.getAttribute('x') ?? 0);
    y = double.tryParse(xmlElement.getAttribute('y') ?? 0);
    height = double.tryParse(xmlElement.getAttribute('height') ?? 0);
    width = double.tryParse(xmlElement.getAttribute('width') ?? 0);
    rotation = double.tryParse(xmlElement.getAttribute('rotation') ?? 0);
    visible = int.tryParse(xmlElement.getAttribute('rotation') ?? 1) == 1; //TODO correct?
    id = int.tryParse(xmlElement.getAttribute('id') ?? '');
    gid = int.tryParse(xmlElement.getAttribute('gid') ?? '');
    name = xmlElement.getAttribute('name');
    type = xmlElement.getAttribute('type');
    //TODO template;


    //TODO <ellipse>
    //
    // Used to mark an object as an ellipse. The existing x, y, width and height attributes are used to determine the size of the ellipse.
    // <point>
    //
    // Used to mark an object as a point. The existing x and y attributes are used to determine the position of the point.
    // <polygon>
    //
    //     points: A list of x,y coordinates in pixels.
    //
    // Each polygon object is made up of a space-delimited list of x,y coordinates. The origin for these coordinates is the location of the parent object. By default, the first point is created as 0,0 denoting that the point will originate exactly where the object is placed.
    // <polyline>
    //
    //     points: A list of x,y coordinates in pixels.
    //
    // A polyline follows the same placement definition as a polygon object.
    // <text>
    //
    //     fontfamily: The font family used (defaults to “sans-serif”)
    //     pixelsize: The size of the font in pixels (not using points, because other sizes in the TMX format are also using pixels) (defaults to 16)
    //     wrap: Whether word wrapping is enabled (1) or disabled (0). (defaults to 0)
    //     color: Color of the text in #AARRGGBB or #RRGGBB format (defaults to #000000)
    //     bold: Whether the font is bold (1) or not (0). (defaults to 0)
    //     italic: Whether the font is italic (1) or not (0). (defaults to 0)
    //     underline: Whether a line should be drawn below the text (1) or not (0). (defaults to 0)
    //     strikeout: Whether a line should be drawn through the text (1) or not (0). (defaults to 0)
    //     kerning: Whether kerning should be used while rendering the text (1) or not (0). (defaults to 1)
    //     halign: Horizontal alignment of the text within the object (left, center, right or justify, defaults to left) (since Tiled 1.2.1)
    //     valign: Vertical alignment of the text within the object (top , center or bottom, defaults to top)
  }

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
