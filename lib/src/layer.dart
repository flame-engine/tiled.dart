part of tiled;

/// All <tileset> tags shall occur before the first <layer> tag so that parsers
/// may rely on having the tilesets before needing to resolve tiles.
///
/// * id: Unique ID of the layer. Each layer that added to a map gets a unique
///   id. Even if a layer is deleted, no layer ever gets the same ID.
///   Can not be changed in Tiled. (since Tiled 1.2)
/// * name: The name of the layer. (defaults to “”)
/// * x: The x coordinate of the layer in tiles.
///   Defaults to 0 and can not be changed in Tiled.
/// * y: The y coordinate of the layer in tiles.
///   Defaults to 0 and can not be changed in Tiled.
/// * width: The width of the layer in tiles.
///   Always the same as the map width for fixed-size maps.
/// * height: The height of the layer in tiles.
///   Always the same as the map height for fixed-size maps.
/// * opacity: The opacity of the layer as a value from 0 to 1. Defaults to 1.
/// * visible: Whether the layer is shown (1) or hidden (0). Defaults to 1.
/// * tintcolor: A tint color that is multiplied with any tiles drawn by this
///   layer in #AARRGGBB or #RRGGBB format (optional).
/// * offsetx: Horizontal offset for this layer in pixels.
///   Defaults to 0. (since 0.14)
/// * offsety: Vertical offset for this layer in pixels.
///   Defaults to 0. (since 0.14)
/// * parallaxx: Horizontal parallax factor for this layer.
///   Defaults to 1. (since 1.5)
/// * parallaxy: Vertical parallax factor for this layer.
///   Defaults to 1. (since 1.5)
///
/// Can contain at most one: <properties>, <data>
abstract class Layer {
  /// Incremental ID - unique across all layers
  int? id;

  /// Name assigned to this layer.
  /// Always present; might be an empty string.
  String name;

  /// Each type is associated with a concrete implementation of [Layer].
  LayerType type;

  /// Horizontal layer offset in tiles. Always 0.
  int x;

  /// Vertical layer offset in tiles. Always 0.
  int y;

  /// Horizontal layer offset in pixels (default: 0)
  double offsetX;

  /// Vertical layer offset in pixels (default: 0)
  double offsetY;

  /// Horizontal parallax factor for this layer (default: 1). (since Tiled 1.5)
  /// See: https://doc.mapeditor.org/en/stable/manual/layers/#parallax-factor
  double parallaxX;

  /// Vertical parallax factor for this layer (default: 1). (since Tiled 1.5)
  /// See: https://doc.mapeditor.org/en/stable/manual/layers/#parallax-factor
  double parallaxY;

  /// X coordinate where layer content starts (for infinite maps)
  int? startX;

  /// Y coordinate where layer content starts (for infinite maps)
  int? startY;

  /// Hex-formatted tint color (#RRGGBB or #AARRGGBB) that is multiplied with
  /// any graphics drawn by this layer or any child layers (optional).
  String? tintColor;

  /// The opacity of the layer as a value from 0 to 1. Defaults to 1.
  double opacity;

  /// Whether layer is shown or hidden in editor.
  bool visible;

  /// List of [Property].
  List<Property> properties;

  Layer({
    this.id,
    required this.name,
    required this.type,
    this.x = 0,
    this.y = 0,
    this.offsetX = 0,
    this.offsetY = 0,
    this.parallaxX = 1,
    this.parallaxY = 1,
    this.startX,
    this.startY,
    this.tintColor,
    this.opacity = 1,
    this.visible = true,
    this.properties = const [],
  });

  static Layer parse(Parser parser) {
    final type = parser.formatSpecificParsing(
      (json) => json.getLayerType('type'),
      (xml) => LayerTypeExtension.parseFromTmx(xml.element.name.toString()),
    );

    final id = parser.getIntOrNull('id');
    final name = parser.getString('name', defaults: '');
    final x = parser.getInt('x', defaults: 0);
    final y = parser.getInt('y', defaults: 0);
    final offsetX = parser.getDouble('offsetx', defaults: 0);
    final offsetY = parser.getDouble('offsety', defaults: 0);
    final parallaxX = parser.getDouble('parallaxx', defaults: 1);
    final parallaxY = parser.getDouble('parallaxy', defaults: 1);
    final startX = parser.getIntOrNull('startx');
    final startY = parser.getIntOrNull('starty');
    final tintColor = parser.getStringOrNull('tintcolor');
    final opacity = parser.getDouble('opacity', defaults: 1);
    final visible = parser.getBool('visible', defaults: true);
    final properties = parser.getProperties();

    final Layer layer;
    switch (type) {
      case LayerType.tileLayer:
        final width = parser.getInt('width');
        final height = parser.getInt('height');
        final dataNode = parser.formatSpecificParsing(
          (json) => null, // data is just a string or list of int on JSON
          (xml) => xml.getSingleChildOrNull('data'),
        );
        final compression = parser.getCompressionOrNull('compression') ??
            dataNode?.getCompressionOrNull('compression');
        final encoding = parser.getFileEncodingOrNull('encoding') ??
            dataNode?.getFileEncodingOrNull('encoding') ??
            FileEncoding.csv;
        final parseChunk = (e) => Chunk.parse(e, encoding, compression);
        final chunks = parser.getChildrenAs('chunks', parseChunk) +
            (dataNode?.getChildrenAs('chunk', parseChunk) ?? []);
        final data = dataNode != null
            ? parseLayerData(dataNode, encoding, compression)
            : null;
        layer = TileLayer(
          id: id,
          name: name,
          x: x,
          y: y,
          offsetX: offsetX,
          offsetY: offsetY,
          parallaxX: parallaxX,
          parallaxY: parallaxY,
          startX: startX,
          startY: startY,
          tintColor: tintColor,
          opacity: opacity,
          visible: visible,
          properties: properties,
          width: width,
          height: height,
          compression: compression,
          encoding: encoding,
          chunks: chunks,
          data: data,
        );
        break;
      case LayerType.objectGroup:
        final drawOrder = parser.getDrawOrder(
          'draworder',
          defaults: DrawOrder.topDown,
        );
        final color = parser.getString('color', defaults: '#a0a0a4');
        final objects = parser.getChildrenAs('object', TiledObject.parse);
        layer = ObjectGroup(
          id: id,
          name: name,
          x: x,
          y: y,
          offsetX: offsetX,
          offsetY: offsetY,
          parallaxX: parallaxX,
          parallaxY: parallaxY,
          startX: startX,
          startY: startY,
          tintColor: tintColor,
          opacity: opacity,
          visible: visible,
          properties: properties,
          drawOrder: drawOrder,
          objects: objects,
          color: color,
        );
        break;
      case LayerType.imageLayer:
        final transparentColor = parser.getStringOrNull('transparentcolor');
        final image = parser.getSingleChildAs('image', TiledImage.parse);
        layer = ImageLayer(
          id: id,
          name: name,
          x: x,
          y: y,
          offsetX: offsetX,
          offsetY: offsetY,
          parallaxX: parallaxX,
          parallaxY: parallaxY,
          startX: startX,
          startY: startY,
          tintColor: tintColor,
          opacity: opacity,
          visible: visible,
          properties: properties,
          image: image,
          transparentColor: transparentColor,
        );
        break;
      case LayerType.group:
        final layers = parseLayers(parser);
        layer = Group(
          id: id,
          name: name,
          x: x,
          y: y,
          offsetX: offsetX,
          offsetY: offsetY,
          parallaxX: parallaxX,
          parallaxY: parallaxY,
          startX: startX,
          startY: startY,
          tintColor: tintColor,
          opacity: opacity,
          visible: visible,
          properties: properties,
          layers: layers,
        );
        break;
    }

    return layer;
  }

  static List<Layer> parseLayers(Parser parser) {
    return parser.formatSpecificParsing(
      (json) => json.getChildrenAs('layers', Layer.parse),
      (xml) {
        return xml.getChildrenAs('layer', Layer.parse) +
            xml.getChildrenAs('objectgroup', Layer.parse) +
            xml.getChildrenAs('imagelayer', Layer.parse) +
            xml.getChildrenAs('group', Layer.parse);
      },
    );
  }

  static List<int>? parseLayerData(
    Parser parser,
    FileEncoding encoding,
    Compression? compression,
  ) {
    final data = parser.formatSpecificParsing(
      (json) => json.json['data'],
      (xml) {
        if (xml.element.children.length != 1) {
          return null;
        }
        final text = xml.element.children.first;
        if (text is XmlText) {
          return text.text;
        }
        return null;
      },
    );

    if (data == null) {
      return null;
    }

    if (encoding == FileEncoding.csv) {
      return data.cast<int>();
    }
    // Ok, its base64
    final trim = data.toString().replaceAll("\n", "").trim();
    final Uint8List decodedString = base64.decode(trim);
    // zlib, gzip, zstd or empty
    List<int> decompressed;
    switch (compression) {
      case Compression.zlib:
        decompressed = const ZLibDecoder().decodeBytes(decodedString);
        break;
      case Compression.gzip:
        decompressed = GZipDecoder().decodeBytes(decodedString);
        break;
      case Compression.zstd:
        // TODO(luan) zstd compression not supported in dart
        throw UnsupportedError("zstd is an unsupported compression");
      case null:
        decompressed = decodedString;
        break;
    }

    // From the tiled documentation:
    // Now you have an array of bytes, which should be interpreted as an array
    // of unsigned 32-bit integers using little-endian byte ordering.
    final bytes = Uint8List.fromList(decompressed);
    final dv = ByteData.view(bytes.buffer);
    final uint32 = <int>[];
    for (var i = 0; i < decompressed.length; ++i) {
      if (i % 4 == 0) {
        uint32.add(dv.getUint32(i, Endian.little));
      }
    }
    return uint32;
  }
}

class TileLayer extends Layer {
  /// Column count. Same as map width for fixed-size maps.
  int width;

  /// Row count. Same as map height for fixed-size maps.
  int height;

  /// zlib, gzip, zstd (since Tiled 1.3) or empty (default).
  Compression? compression;

  /// csv (default) or base64.
  FileEncoding encoding;

  /// List of chunks (optional).
  List<Chunk>? chunks;

  /// List of gids as int (GIDs) (parsed from base64-encoded data)
  /// See [tileData] for a better representation.
  List<int>? data;

  /// This is not part of the tiled definitions; this is just a convinient
  /// wrapper over the [data] field that simplifies two things:
  ///
  /// * represents the matrix as a matrix (List<List<X>>) instead of a flat list
  /// * wraps the gid integer into the [Gid] class for easy access of properties
  List<List<Gid>>? tileData;

  TileLayer({
    int? id,
    required String name,
    int x = 0,
    int y = 0,
    double offsetX = 0,
    double offsetY = 0,
    double parallaxX = 1,
    double parallaxY = 1,
    int? startX,
    int? startY,
    String? tintColor,
    double opacity = 1,
    bool visible = true,
    List<Property> properties = const [],
    required this.width,
    required this.height,
    this.compression,
    this.encoding = FileEncoding.csv,
    this.chunks,
    this.data,
  })  : tileData = maybeGenerate(data, width, height),
        super(
          id: id,
          name: name,
          type: LayerType.tileLayer,
          x: x,
          y: y,
          offsetX: offsetX,
          offsetY: offsetY,
          parallaxX: parallaxX,
          parallaxY: parallaxY,
          startX: startX,
          startY: startY,
          tintColor: tintColor,
          opacity: opacity,
          visible: visible,
          properties: properties,
        );
  static List<List<Gid>>? maybeGenerate(
    List<int>? data,
    int width,
    int height,
  ) {
    if (data == null) {
      return null;
    }
    return Gid.generate(data, width, height);
  }
}

class ObjectGroup extends Layer {
  /// topdown (default) or index (indexOrder).
  DrawOrder drawOrder;

  /// List of [TiledObject].
  List<TiledObject> objects;

  /// The color used to display the objects in this group.
  /// (defaults to gray (“#a0a0a4”))
  String color;

  ObjectGroup({
    int? id,
    required String name,
    int x = 0,
    int y = 0,
    double offsetX = 0,
    double offsetY = 0,
    double parallaxX = 1,
    double parallaxY = 1,
    int? startX,
    int? startY,
    String? tintColor,
    double opacity = 1,
    bool visible = true,
    List<Property> properties = const [],
    this.drawOrder = DrawOrder.topDown,
    required this.objects,
    this.color = '#a0a0a4',
  }) : super(
          id: id,
          name: name,
          type: LayerType.objectGroup,
          x: x,
          y: y,
          offsetX: offsetX,
          offsetY: offsetY,
          parallaxX: parallaxX,
          parallaxY: parallaxY,
          startX: startX,
          startY: startY,
          tintColor: tintColor,
          opacity: opacity,
          visible: visible,
          properties: properties,
        );
}

class ImageLayer extends Layer {
  /// Image used by this layer.
  TiledImage image;

  /// Hex-formatted color (#RRGGBB) (optional).
  String? transparentColor;

  ImageLayer({
    int? id,
    required String name,
    int x = 0,
    int y = 0,
    double offsetX = 0,
    double offsetY = 0,
    double parallaxX = 1,
    double parallaxY = 1,
    int? startX,
    int? startY,
    String? tintColor,
    double opacity = 1,
    bool visible = true,
    List<Property> properties = const [],
    required this.image,
    this.transparentColor,
  }) : super(
          id: id,
          name: name,
          type: LayerType.imageLayer,
          x: x,
          y: y,
          offsetX: offsetX,
          offsetY: offsetY,
          parallaxX: parallaxX,
          parallaxY: parallaxY,
          startX: startX,
          startY: startY,
          tintColor: tintColor,
          opacity: opacity,
          visible: visible,
          properties: properties,
        );
}

class Group extends Layer {
  /// List of [Layer].
  List<Layer> layers;

  Group({
    int? id,
    required String name,
    int x = 0,
    int y = 0,
    double offsetX = 0,
    double offsetY = 0,
    double parallaxX = 1,
    double parallaxY = 1,
    int? startX,
    int? startY,
    String? tintColor,
    double opacity = 1,
    bool visible = true,
    List<Property> properties = const [],
    required this.layers,
  }) : super(
          id: id,
          name: name,
          type: LayerType.imageLayer,
          x: x,
          y: y,
          offsetX: offsetX,
          offsetY: offsetY,
          parallaxX: parallaxX,
          parallaxY: parallaxY,
          startX: startX,
          startY: startY,
          tintColor: tintColor,
          opacity: opacity,
          visible: visible,
          properties: properties,
        );
}
