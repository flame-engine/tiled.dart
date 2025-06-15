import 'package:tiled/tiled.dart';

/// Below is Tiled's documentation about how this structure is represented
/// on XML files:
///
/// `<object>`
///
/// * id: Unique ID of the object. Each object that is placed on a map gets a
///   unique id. Even if an object was deleted, no object gets the same ID.
///   Can not be changed in Tiled. (since Tiled 0.11)
/// * name: The name of the object. An arbitrary string. (defaults to “”)
/// * type: The type of the object. An arbitrary string. (defaults to “”)
/// * class_: The class of the object. An arbitrary string. (defaults to “”).
///           It replaces "type" property starting 1.9.
/// * x: The x coordinate of the object in pixels. (defaults to 0)
/// * y: The y coordinate of the object in pixels. (defaults to 0)
/// * width: The width of the object in pixels. (defaults to 0)
/// * height: The height of the object in pixels. (defaults to 0)
/// * rotation: The rotation of the object in degrees clockwise around (x, y).
///   (defaults to 0)
/// * gid: A reference to a tile. (optional)
/// * visible: Whether the object is shown (1) or hidden (0). (defaults to 1)
/// * template: A reference to a template file. (optional)
///
/// While tile layers are very suitable for anything repetitive aligned to the
/// tile grid, sometimes you want to annotate your map with other information,
/// not necessarily aligned to the grid. Hence the objects have their
/// coordinates and size in pixels, but you can still easily align that to the
/// grid when you want to.
///
/// You generally use objects to add custom information to your tile map, such
/// as spawn points, warps, exits, etc.
///
/// When the object has a gid set, then it is represented by the image of the
/// tile with that global ID. The image alignment currently depends on the map
/// orientation. In orthogonal orientation it’s aligned to the bottom-left while
/// in isometric it’s aligned to the bottom-center. The image will rotate around
/// the bottom-left or bottom-center, respectively.
///
/// When the object has a template set, it will borrow all the properties from
/// the specified template, properties saved with the object will have higher
/// priority, i.e. they will override the template properties.
///
/// Can contain at most one: `<properties>`, `<ellipse>` (since 0.9),
/// `<point>` (since 1.1), `<polygon>`, `<polyline>, `<text>` (since 1.0)
class TiledObject {
  int id;
  String name;
  String type;
  int? gid;

  double x;
  double y;
  double width;
  double height;
  double rotation;

  bool ellipse;
  bool point;
  bool rectangle;

  Template? template;
  Text? text;
  bool visible;

  List<Point> polygon;
  List<Point> polyline;
  CustomProperties properties;

  /// The "Class" property, a.k.a "Type" prior to Tiled 1.9.
  /// Will be same as [type].
  String get class_ => type;

  TiledObject({
    required this.id,
    this.name = '',
    this.type = '',
    this.gid,
    this.x = 0,
    this.y = 0,
    this.width = 0,
    this.height = 0,
    this.rotation = 0,
    this.ellipse = false,
    this.point = false,
    this.rectangle = false,
    this.template,
    this.text,
    this.visible = true,
    this.polygon = const [],
    this.polyline = const [],
    this.properties = CustomProperties.empty,
  });

  bool get isPolyline => polyline.isNotEmpty;
  bool get isPolygon => polygon.isNotEmpty;
  bool get isPoint => point;
  bool get isEllipse => ellipse;
  bool get isRectangle => rectangle;

  factory TiledObject.parse(Parser parser) {
    final x = parser.getDouble('x', defaults: 0);
    final y = parser.getDouble('y', defaults: 0);
    final height = parser.getDouble('height', defaults: 0);
    final width = parser.getDouble('width', defaults: 0);
    final rotation = parser.getDouble('rotation', defaults: 0);
    final visible = parser.getBool('visible', defaults: true);
    final id = parser.getInt('id');
    final gid = parser.getIntOrNull('gid');
    final name = parser.getString('name', defaults: '');

    // Tiled 1.9 and above versions running in compatibility mode set to
    // "Tiled 1.8" will still write out "Class" property as "type". So try both
    // before using default value.
    final type = parser.getString(
      'class',
      defaults: parser.getString('type', defaults: ''),
    );

    final ellipse = parser.formatSpecificParsing(
      (json) => json.getBool('ellipse'),
      (xml) => xml.getChildren('ellipse').isNotEmpty,
    );
    final point = parser.formatSpecificParsing(
      (json) => json.getBool('point'),
      (xml) => xml.getChildren('point').isNotEmpty,
    );
    final text = parser.getSingleChildOrNullAs('text', Text.parse);
    final template = parser.getSingleChildOrNullAs('template', Template.parse);
    final properties = parser.getProperties();

    final polygon = parsePointList(parser, 'polygon');
    final polyline = parsePointList(parser, 'polyline');

    final rectangle = polyline.isEmpty && polygon.isEmpty && !ellipse && !point;

    return TiledObject(
      id: id,
      name: name,
      type: type,
      gid: gid,
      x: x,
      y: y,
      width: width,
      height: height,
      rotation: rotation,
      ellipse: ellipse,
      point: point,
      rectangle: rectangle,
      template: template,
      text: text,
      visible: visible,
      polygon: polygon,
      polyline: polyline,
      properties: properties,
    );
  }

  static List<Point> parsePointList(Parser parser, String name) {
    return parser.formatSpecificParsing(
      (json) => json.getChildrenAs(name, Point.parse),
      (xml) {
        final points = xml
            .getSingleChildOrNull(name)
            ?.getString('points')
            .split(' ')
            .map(Point.parseFromString)
            .toList();
        return points ?? [];
      },
    );
  }
}
