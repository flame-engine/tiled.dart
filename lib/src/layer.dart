part of tiled;

class Layer {
  List<Chunk> chunks = [];
  Compression compression;
  List<int> data = [];
  DrawOrder drawOrder = DrawOrder.topdown;
  String color;
  FileEncoding encoding = FileEncoding.csv;
  int height;
  int id;
  TiledImage image; // only on imageLayer
  List<Layer> layers = [];
  String name;
  List<TiledObject> objects = [];
  double offsetX;
  double offsetY;
  double opacity;
  List<Property> properties = [];
  int startX;
  int startY;
  String tintColor;
  String transparentColor;
  LayerType type;
  bool visible;
  int width;
  int x;
  int y;

  // Convenience
  List<List<int>> tileIDMatrix = [];
  List<List<Flips>> tileFlips = [];

  Layer.fromXml(XmlNode xmlElement) {
    drawOrder = DrawOrder.values.firstWhere(
        (e) => e.name == xmlElement.getAttribute('draworder'),
        orElse: () => null);
    color = xmlElement.getAttribute('color'); // only ObjectGroup
    height = int.tryParse(xmlElement.getAttribute('height') ?? '');
    id = int.tryParse(xmlElement.getAttribute('id') ?? '');
    name = xmlElement.getAttribute('name');
    offsetX = double.tryParse(xmlElement.getAttribute('offsetx') ?? '');
    offsetY = double.tryParse(xmlElement.getAttribute('offsety') ?? '');
    opacity = double.tryParse(xmlElement.getAttribute('opacity') ?? '');
    startX = int.tryParse(xmlElement.getAttribute('startx') ?? '');
    startY = int.tryParse(xmlElement.getAttribute('starty') ?? '');
    width = int.tryParse(xmlElement.getAttribute('width') ?? '');
    x = int.tryParse(xmlElement.getAttribute('x') ?? '');
    y = int.tryParse(xmlElement.getAttribute('y') ?? '');
    tintColor = xmlElement.getAttribute('tintcolor');
    transparentColor = xmlElement.getAttribute('transparentcolor');
    type = LayerType.values.firstWhere(
        (e) => e.name == xmlElement.getAttribute('type'),
        orElse: () => null);
    visible = int.tryParse(xmlElement.getAttribute('visible') ?? "1") == 1;

    xmlElement.children.whereType<XmlElement>().forEach((XmlElement element) {
      switch (element.name.local) {
        case 'image':
          image = TiledImage.fromXml(element);
          break;
        case 'data':
          compression = Compression.values.firstWhere(
              (e) => e.name == element.getAttribute('compression'),
              orElse: () => null);
          encoding = FileEncoding.values.firstWhere(
              (e) => e.name == element.getAttribute('encoding'),
              orElse: () => null);
          chunks = <Chunk>[];
          element.nodes.whereType<XmlElement>().forEach((element) {
            chunks.add(Chunk.fromXml(element, encoding, compression));
          });
          if (chunks.isEmpty) {
            data = decodeData(element.text, encoding, compression);
          }
          break;
        case 'properties':
          element.nodes.whereType<XmlElement>().forEach((element) {
            properties.add(Property.fromXml(element));
          });
          break;
        case 'chunks':
          element.nodes.whereType<XmlElement>().forEach((element) {
            chunks.add(Chunk.fromXml(element, encoding, compression));
          });
          break;
        case 'layer':
          final layer = Layer.fromXml(element);
          layer.type = LayerType.tilelayer;
          layers.add(layer);
          break;
        case 'objectgroup':
          final layer = Layer.fromXml(element);
          layer.type = LayerType.objectlayer;
          layers.add(layer);
          break;
        case 'imagelayer':
          final layer = Layer.fromXml(element);
          layer.type = LayerType.imagelayer;
          layers.add(layer);
          break;
        case 'group':
          final layer = Layer.fromXml(element);
          layer.type = LayerType.group;
          layers.add(layer);
          break;
        case 'object':
          objects.add(TiledObject.fromXml(element));
          break;
      }
    });

    _generateTileMatrix();
  }

  Layer.fromJson(Map<String, dynamic> json) {
    compression = Compression.values
        .firstWhere((e) => e.name == json['compression'], orElse: () => null);
    encoding = FileEncoding.values
        .firstWhere((e) => e.name == json['encoding'], orElse: () => null);
    chunks = (json['chunks'] as List)
            ?.map((e) => Chunk.fromJson(e, encoding, compression))
            ?.toList() ??
        [];
    data = json['data'] != null
        ? decodeData(json['data'], encoding, compression)
        : [];
    drawOrder = DrawOrder.values
        .firstWhere((e) => e.name == json['draworder'], orElse: () => null);
    height = json['height'];
    id = json['id'];
    image = json['image'];
    layers =
        (json['layers'] as List)?.map((e) => Layer.fromJson(e))?.toList() ?? [];
    name = json['name'];
    offsetX = json['offsetx'];
    offsetY = json['offsety'];
    opacity = json['opacity']?.toDouble();
    properties = (json['properties'] as List)
            ?.map((e) => Property.fromJson(e))
            ?.toList() ??
        [];
    startX = json['startx'];
    startY = json['starty'];
    tintColor = json['tintcolor'];
    transparentColor = json['transparentcolor'];
    type = LayerType.values
        .firstWhere((e) => e.name == json['type'], orElse: () => null);
    visible = json['visible'];
    width = json['width'];
    x = json['x'];
    y = json['y'];
    objects = (json['objects'] as List)
            ?.map((e) => TiledObject.fromJson(e))
            ?.toList() ??
        [];
    _generateTileMatrix();
  }

  static List<int> decodeData(
      json, FileEncoding encoding, Compression compression) {
    if (json == null) {
      return null;
    }

    if (encoding == null || encoding == FileEncoding.csv) {
      return json.cast<int>();
    }
    //Ok, its base64
    final trim = json.toString().replaceAll("\n", "").trim();
    final Uint8List decodedString = base64.decode(trim);
    //zlib, gzip, zstd or empty
    List<int> decompressed;
    switch (compression) {
      case Compression.zlib:
        decompressed = ZLibDecoder().decodeBytes(decodedString);
        break;
      case Compression.gzip:
        decompressed = GZipDecoder().decodeBytes(decodedString);
        break;
      case Compression.zstd:
        //TODO zstd compression not supported in dart
        throw UnsupportedError("zstd is an unsupported compression");
      default:
        decompressed = decodedString;
        break;
    }

    // From the tiled documentation:
    // Now you have an array of bytes, which should be interpreted as an array of unsigned 32-bit integers using little-endian byte ordering.
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

  static const int FLIPPED_HORIZONTALLY_FLAG = 0x80000000;
  static const int FLIPPED_VERTICALLY_FLAG = 0x40000000;
  static const int FLIPPED_DIAGONALLY_FLAG = 0x20000000;

  void _generateTileMatrix() {
    if (height == null ||
            width == null // objectlayer
            ||
            data.isEmpty // infinate map with chunks
        ) {
      return;
    }
    tileIDMatrix = List.generate(height, (_) => List<int>.filled(width, 0));
    tileFlips = List.generate(height, (_) => List<Flips>.filled(width, null));
    generateTiles(data, height, width, tileIDMatrix, tileFlips);
  }

  static void generateTiles(List<int> data, int chunkheight, int chunkwidth,
      List<List<int>> matrix, List<List<Flips>> flips) {
    for (var y = 0; y < chunkheight; ++y) {
      for (var x = 0; x < chunkwidth; ++x) {
        int id = data[(y * chunkwidth) + x];
        // get flips from id
        final bool flippedHorizontally =
            (id & FLIPPED_HORIZONTALLY_FLAG) == FLIPPED_HORIZONTALLY_FLAG;
        final bool flippedVertically =
            (id & FLIPPED_VERTICALLY_FLAG) == FLIPPED_VERTICALLY_FLAG;
        final bool flippedDiagonally =
            (id & FLIPPED_DIAGONALLY_FLAG) == FLIPPED_DIAGONALLY_FLAG;
        //clear id from flips
        id &= ~(FLIPPED_HORIZONTALLY_FLAG |
            FLIPPED_VERTICALLY_FLAG |
            FLIPPED_DIAGONALLY_FLAG);
        matrix[y][x] = id;
        flips[y][x] =
            Flips(flippedHorizontally, flippedVertically, flippedDiagonally);
      }
    }
  }
}
