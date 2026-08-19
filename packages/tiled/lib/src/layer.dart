import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:tiled/tiled.dart';
import 'package:xml/xml.dart';

/// Below is Tiled's documentation about how this structure is represented
/// on XML files:
///
/// All `<tileset>` tags shall occur before the first `<layer>` tag so that
/// parsers may rely on having the tilesets before needing to resolve tiles.
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
/// Can contain at most one: `<properties>`, `<data>`
abstract class Layer {
  /// Incremental ID - unique across all layers
  int? id;

  /// Name assigned to this layer.
  /// Always present; might be an empty string.
  String name;

  /// Each type is associated with a concrete implementation of [Layer].
  LayerType type;

  /// The "Class" specified in Tiled, introduced in Tiled 1.9 to support
  /// custom types on any object. This is NOT the same as [type]
  String? class_;

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
  String? tintColorHex;

  /// [ColorData] that is multiplied with any graphics drawn by this layer or
  /// any child layers (optional).
  ///
  /// Parsed from [tintColorHex], will be null if parsing fails for any reason.
  ColorData? tintColor;

  /// The opacity of the layer as a value from 0 to 1. Defaults to 1.
  double opacity;

  /// Whether layer is shown or hidden in editor.
  bool visible;

  /// List of [Property].
  CustomProperties properties;

  Layer({
    required this.name,
    required this.type,
    this.id,
    this.class_,
    this.x = 0,
    this.y = 0,
    this.offsetX = 0,
    this.offsetY = 0,
    this.parallaxX = 1,
    this.parallaxY = 1,
    this.startX,
    this.startY,
    this.tintColorHex,
    this.tintColor,
    this.opacity = 1,
    this.visible = true,
    this.properties = CustomProperties.empty,
  });

  static Layer parse(Parser parser) {
    final type = parser.formatSpecificParsing(
      (json) => json.getLayerType('type'),
      (xml) => LayerTypeExtension.parseFromTmx(xml.element.name.toString()),
    );

    final id = parser.getIntOrNull('id');
    final name = parser.getString('name', defaults: '');
    final class_ = parser.getStringOrNull('class');
    final x = parser.getInt('x', defaults: 0);
    final y = parser.getInt('y', defaults: 0);
    final offsetX = parser.getDouble('offsetx', defaults: 0);
    final offsetY = parser.getDouble('offsety', defaults: 0);
    final parallaxX = parser.getDouble('parallaxx', defaults: 1);
    final parallaxY = parser.getDouble('parallaxy', defaults: 1);
    final startX = parser.getIntOrNull('startx');
    final startY = parser.getIntOrNull('starty');
    final tintColorHex = parser.getStringOrNull('tintcolor');
    final tintColor = parser.getColorOrNull('tintcolor');
    final opacity = parser.getDouble('opacity', defaults: 1);
    final visible = parser.getBool('visible', defaults: true);
    final properties = parser.getProperties();

    final Layer layer;
    switch (type) {
      case LayerType.tileLayer:
        final width = parser.getInt('width');
        final height = parser.getInt('height');
        final dataNode = parser.formatSpecificParsing(
          (json) => json, // data is just a string or list of int on JSON
          (xml) => xml.getSingleChildOrNull('data'),
        );
        final compression =
            parser.getCompressionOrNull('compression') ??
            dataNode?.getCompressionOrNull('compression');
        final encoding =
            parser.getFileEncodingOrNull('encoding') ??
            dataNode?.getFileEncodingOrNull('encoding') ??
            FileEncoding.csv;
        Chunk parseChunk(Parser e) => Chunk.parse(e, encoding, compression);
        final chunks =
            parser.getChildrenAs('chunks', parseChunk) +
            (dataNode?.getChildrenAs('chunk', parseChunk) ?? []);
        final data = dataNode != null
            ? parseLayerData(dataNode, encoding, compression)
            : null;
        layer = TileLayer(
          id: id,
          name: name,
          class_: class_,
          x: x,
          y: y,
          offsetX: offsetX,
          offsetY: offsetY,
          parallaxX: parallaxX,
          parallaxY: parallaxY,
          startX: startX,
          startY: startY,
          tintColorHex: tintColorHex,
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
      case LayerType.objectGroup:
        final drawOrder = parser.getDrawOrder(
          'draworder',
          defaults: DrawOrder.topDown,
        );
        final colorHex = parser.getString(
          'color',
          defaults: ObjectGroup.defaultColorHex,
        );
        final color = parser.getColor(
          'color',
          defaults: ObjectGroup.defaultColor,
        );

        final objects = parser.formatSpecificParsing(
          (json) => json.getChildrenAs('objects', TiledObject.parse),
          (xml) => xml.getChildrenAs('object', TiledObject.parse),
        );

        layer = ObjectGroup(
          id: id,
          name: name,
          class_: class_,
          x: x,
          y: y,
          offsetX: offsetX,
          offsetY: offsetY,
          parallaxX: parallaxX,
          parallaxY: parallaxY,
          startX: startX,
          startY: startY,
          tintColorHex: tintColorHex,
          tintColor: tintColor,
          opacity: opacity,
          visible: visible,
          properties: properties,
          drawOrder: drawOrder,
          objects: objects,
          colorHex: colorHex,
          color: color,
        );
      case LayerType.imageLayer:
        final transparentColorHex = parser.getStringOrNull('transparentcolor');
        final transparentColor = parser.getColorOrNull('transparentcolor');
        final image = parser.getSingleChildAs('image', TiledImage.parse);
        final repeatX = parser.getBool('repeatx', defaults: false);
        final repeatY = parser.getBool('repeaty', defaults: false);
        layer = ImageLayer(
          id: id,
          name: name,
          class_: class_,
          x: x,
          y: y,
          offsetX: offsetX,
          offsetY: offsetY,
          parallaxX: parallaxX,
          parallaxY: parallaxY,
          repeatX: repeatX,
          repeatY: repeatY,
          startX: startX,
          startY: startY,
          tintColorHex: tintColorHex,
          tintColor: tintColor,
          opacity: opacity,
          visible: visible,
          properties: properties,
          image: image,
          transparentColorHex: transparentColorHex,
          transparentColor: transparentColor,
        );
      case LayerType.group:
        final layers = parseLayers(parser);
        layer = Group(
          id: id,
          name: name,
          class_: class_,
          x: x,
          y: y,
          offsetX: offsetX,
          offsetY: offsetY,
          parallaxX: parallaxX,
          parallaxY: parallaxY,
          startX: startX,
          startY: startY,
          tintColorHex: tintColorHex,
          tintColor: tintColor,
          opacity: opacity,
          visible: visible,
          properties: properties,
          layers: layers,
        );
    }

    return layer;
  }

  static List<Layer> parseLayers(Parser parser) {
    return parser.formatSpecificParsing(
      (json) => json.getChildrenAs('layers', Layer.parse),
      (xml) {
        // It's very important not change the order of the layers
        // during parsing!
        // Order in the map determines rendering order.
        final xmlLayers = xml.getChildrenWithNames(
          {'layer', 'objectgroup', 'imagelayer', 'group'},
        );
        return xmlLayers.map(Layer.parse).toList();
      },
    );
  }

  static List<int>? parseLayerData(
    Parser parser,
    FileEncoding encoding,
    Compression? compression,
  ) {
    final dynamic data = parser.formatSpecificParsing<dynamic>(
      (json) => json.json['data'],
      (xml) {
        if (xml.element.children.length != 1) {
          return null;
        }
        final text = xml.element.children.first;
        if (text is XmlText) {
          return text.value;
        }
        return null;
      },
    );

    if (data == null) {
      return null;
    }

    if (encoding == FileEncoding.csv) {
      if (data is List) {
        return data.cast<int>();
      } else {
        // csv data must be parsed
        return List.from(
          (data as String).split(',').map<int>((s) => int.parse(s.trim())),
        );
      }
    }
    // Ok, its base64
    final trim = data.toString().replaceAll('\n', '').trim();
    final decodedString = base64.decode(trim);
    // zlib, gzip, zstd or empty
    List<int> decompressed;
    switch (compression) {
      case Compression.zlib:
        decompressed = const ZLibDecoder().decodeBytes(decodedString);
      case Compression.gzip:
        decompressed = const GZipDecoder().decodeBytes(decodedString);
      case Compression.zstd:
        throw UnsupportedError('zstd is an unsupported compression');
      case null:
        decompressed = decodedString;
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

/// Called for each cell of a [TileLayer] in Tiled world tile coordinates.
///
/// The [x] and [y] parameters are the Tiled world tile coordinates.
/// The [gid] parameter is the GID of the tile at the given coordinates.
typedef TileVisitor = void Function(int x, int y, Gid gid);

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

  /// This is not part of the tiled definitions; this is just a convenience
  /// wrapper over the [data] field that simplifies two things:
  ///
  /// * represents the matrix as a matrix (`List<List<X>>`) instead of a flat
  ///   list
  /// * wraps the gid integer into the [Gid] class for easy access of properties
  List<List<Gid>>? tileData;

  TileLayer({
    required super.name,
    required this.width,
    required this.height,
    super.id,
    super.class_,
    super.x,
    super.y,
    super.offsetX,
    super.offsetY,
    super.parallaxX,
    super.parallaxY,
    super.startX,
    super.startY,
    super.tintColorHex,
    super.tintColor,
    super.opacity,
    super.visible,
    super.properties,
    this.compression,
    this.encoding = FileEncoding.csv,
    this.chunks,
    this.data,
  }) : tileData = maybeGenerate(data, width, height),
       super(
         type: LayerType.tileLayer,
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

  /// Inclusive-exclusive tile bounds of this layer in Tiled world coordinates.
  ///
  /// Finite layers use `[0, width) × [0, height)`. Infinite layers use the
  /// axis-aligned bounds of all chunks (`left`/`top` are the minimum tile
  /// indices, which may be negative). Returns `null` when there is no tile
  /// matrix and no chunks.
  Rectangle<int>? get contentBounds {
    if (tileData != null) {
      return Rectangle(0, 0, width, height);
    }

    final layerChunks = chunks;
    if (layerChunks == null || layerChunks.isEmpty) {
      return null;
    }

    var minX = layerChunks.first.x;
    var minY = layerChunks.first.y;
    var maxX = minX + layerChunks.first.width;
    var maxY = minY + layerChunks.first.height;

    for (var i = 1; i < layerChunks.length; i++) {
      final chunk = layerChunks[i];
      if (chunk.x < minX) {
        minX = chunk.x;
      }
      if (chunk.y < minY) {
        minY = chunk.y;
      }
      final chunkMaxX = chunk.x + chunk.width;
      final chunkMaxY = chunk.y + chunk.height;
      if (chunkMaxX > maxX) {
        maxX = chunkMaxX;
      }
      if (chunkMaxY > maxY) {
        maxY = chunkMaxY;
      }
    }

    return Rectangle(minX, minY, maxX - minX, maxY - minY);
  }

  /// Walks every cell in Tiled world tile coordinates
  /// and calls the [action] function with the x, y, and gid of the tile.
  void forEachTile(TileVisitor action) {
    final data = tileData;
    if (data != null) {
      for (var ty = 0; ty < data.length; ty++) {
        final row = data[ty];
        for (var tx = 0; tx < row.length; tx++) {
          action(tx, ty, row[tx]);
        }
      }
      return;
    }

    final layerChunks = chunks;
    if (layerChunks == null) {
      return;
    }

    for (final chunk in layerChunks) {
      for (var localY = 0; localY < chunk.tileData.length; localY++) {
        final row = chunk.tileData[localY];
        for (var localX = 0; localX < row.length; localX++) {
          action(chunk.x + localX, chunk.y + localY, row[localX]);
        }
      }
    }
  }

  /// Returns the GID at Tiled tile `(x, y)` if it exists, otherwise returns
  /// null.
  Gid? tileAt(int x, int y) {
    final data = tileData;
    if (data != null) {
      if (y < 0 || x < 0 || y >= data.length || x >= data[y].length) {
        return null;
      }
      return data[y][x];
    }

    final chunk = _chunkAt(x, y);
    if (chunk == null) {
      return null;
    }
    return chunk.tileData[y - chunk.y][x - chunk.x];
  }

  /// Writes [gid] at Tiled tile `(x, y)` if that cell already exists.
  ///
  /// Does not allocate new chunks. Returns `true` when the stored GID changed.
  bool setTileAt(int x, int y, Gid gid) {
    final current = tileAt(x, y);
    if (current == null || !_gidChanged(current, gid)) {
      return false;
    }

    final data = tileData;
    if (data != null) {
      data[y][x] = gid;
      return true;
    }

    final chunk = _chunkAt(x, y);
    if (chunk == null) {
      return false;
    }
    chunk.tileData[y - chunk.y][x - chunk.x] = gid;
    return true;
  }

  /// Returns the chunk at Tiled tile `(x, y)` if it exists, otherwise returns
  /// null.
  Chunk? _chunkAt(int x, int y) {
    final layerChunks = chunks;
    if (layerChunks == null) {
      return null;
    }
    for (final chunk in layerChunks) {
      if (x >= chunk.x &&
          x < chunk.x + chunk.width &&
          y >= chunk.y &&
          y < chunk.y + chunk.height) {
        return chunk;
      }
    }
    return null;
  }

  /// Returns true if the GID has changed, otherwise returns false.
  static bool _gidChanged(Gid current, Gid gid) {
    return current.tile != gid.tile ||
        current.flips.horizontally != gid.flips.horizontally ||
        current.flips.vertically != gid.flips.vertically ||
        current.flips.diagonally != gid.flips.diagonally;
  }
}

class ObjectGroup extends Layer {
  static const defaultColor = ColorData.rgb(160, 160, 164);
  static const defaultColorHex = '%a0a0a4';

  /// topdown (default) or index (indexOrder).
  DrawOrder drawOrder;

  /// List of [TiledObject].
  List<TiledObject> objects;

  /// Hex-formatted color (#RRGGBB or #AARRGGBB) used to display the objects in
  /// this group. (defaults to gray (“#a0a0a4”))
  String colorHex;

  /// [ColorData] used to display the objects in this group.
  /// (defaults to gray (“#a0a0a4”))
  ///
  /// Parsed from [colorHex], will be fallback to [defaultColor] if parsing
  /// fails for any reason.
  ColorData color;

  ObjectGroup({
    required super.name,
    required this.objects,
    super.id,
    super.class_,
    super.x,
    super.y,
    super.offsetX,
    super.offsetY,
    super.parallaxX,
    super.parallaxY,
    super.startX,
    super.startY,
    super.tintColorHex,
    super.tintColor,
    super.opacity,
    super.visible,
    super.properties,
    this.drawOrder = DrawOrder.topDown,
    this.colorHex = defaultColorHex,
    this.color = defaultColor,
  }) : super(
         type: LayerType.objectGroup,
       );
}

class ImageLayer extends Layer {
  /// Image used by this layer.
  TiledImage image;

  /// Hex-formatted color (#RRGGBB or #AARRGGBB) to be rendered as transparent
  /// (optional).
  String? transparentColorHex;

  /// [ColorData] to be rendered as transparent (optional).
  ///
  /// Parsed from [transparentColorHex], will be null if parsing fails for any
  /// reason.
  ColorData? transparentColor;

  /// Whether or not to repeat the image on the X-axis
  bool repeatX;

  /// Whether or not to repeat the image on the Y-axis
  bool repeatY;

  ImageLayer({
    required super.name,
    required this.image,
    required this.repeatX,
    required this.repeatY,
    super.id,
    super.class_,
    super.x,
    super.y,
    super.offsetX,
    super.offsetY,
    super.parallaxX,
    super.parallaxY,
    super.startX,
    super.startY,
    super.tintColorHex,
    super.tintColor,
    super.opacity,
    super.visible,
    super.properties,
    this.transparentColorHex,
    this.transparentColor,
  }) : super(
         type: LayerType.imageLayer,
       );
}

class Group extends Layer {
  /// List of [Layer].
  List<Layer> layers;

  Group({
    required super.name,
    required this.layers,
    super.id,
    super.class_,
    super.x,
    super.y,
    super.offsetX,
    super.offsetY,
    super.parallaxX,
    super.parallaxY,
    super.startX,
    super.startY,
    super.tintColorHex,
    super.tintColor,
    super.opacity,
    super.visible,
    super.properties,
  }) : super(
         type: LayerType.imageLayer,
       );
}
