part of tiled;

class Layer {
  List<Chunk> chunks = [];
  String
      compression; // zlib, gzip, zstd (since Tiled 1.3) or empty (default). tilelayer
  List<int> data = [];
  String draworder = 'topdown'; //topdown (default) or index. only objectgroup
  String color; // only objectgroup; Not supported by json
  String encoding = 'csv'; // csv (default) or base64. tilelayer
  int height;
  int id;
  TiledImage image; // only on imageLayer
  List<Layer> layers = [];
  String name;
  List<TiledObject> objects = [];
  double offsetx;
  double offsety;
  double opacity;
  List<Property> properties = [];
  int startx;
  int starty;
  String tintcolor;
  String transparentcolor;
  String type; // tilelayer, objectgroup, imagelayer or group //TODO group
  bool visible;
  int width;
  int x;
  int y;

  // Convenience
  List<List<int>> tileIDMatrix;
  List<List<Flips>> tileFlips;

  Layer.fromXml(XmlNode xmlElement) {
    draworder = xmlElement.getAttribute('draworder');// only ObjectGroup
    color = xmlElement.getAttribute('color');// only ObjectGroup
    height = int.tryParse(xmlElement.getAttribute('height') ?? '');
    id = int.tryParse(xmlElement.getAttribute('id') ?? '');
    name = xmlElement.getAttribute('name');
    offsetx = double.tryParse(xmlElement.getAttribute('offsetx') ?? '');
    offsety = double.tryParse(xmlElement.getAttribute('offsety') ?? '');
    opacity = double.tryParse(xmlElement.getAttribute('opacity') ?? '');
    startx = int.tryParse(xmlElement.getAttribute('startx') ?? '');
    starty = int.tryParse(xmlElement.getAttribute('starty') ?? '');
    width = int.tryParse(xmlElement.getAttribute('width') ?? '');
    x = int.tryParse(xmlElement.getAttribute('x') ?? '');
    y = int.tryParse(xmlElement.getAttribute('y') ?? '');
    tintcolor = xmlElement.getAttribute('tintcolor');
    transparentcolor = xmlElement.getAttribute('transparentcolor');
    type = xmlElement.getAttribute('type');
    visible = int.tryParse(xmlElement.getAttribute('visible') ?? "1") == 1;

    xmlElement.children.whereType<XmlElement>().forEach((XmlElement element) {
      switch (element.name.local) {
        case 'image':
          image = TiledImage.fromXml(element);
          break;
        case 'data':
          compression = element.getAttribute('compression');
          encoding = element.getAttribute('encoding');
          data = decodeData(element.text, encoding, compression);
          break;
        case 'properties':
          element.nodes.whereType<XmlElement>().forEach((element) {
            properties.add(Property.fromXml(element));
          });
          break;
        case 'chunks':
          element.nodes.whereType<XmlElement>().forEach((element) {
            chunks.add(Chunk.fromXml(element));
          });
          break;
        case 'layers':
          element.nodes.whereType<XmlElement>().forEach((element) {
            layers.add(Layer.fromXml(element));
          });
          break;
        case 'object':
            objects.add(TiledObject.fromXml(element));
          break;
      }
    });

    _generateTileMatrix();
  }

  Layer.fromJson(Map<String, dynamic> json) {
    if (json['chunks'] != null) {
      chunks = <Chunk>[];
      json['chunks'].forEach((v) {
        chunks.add(Chunk.fromJson(v));
      });
    }
    compression = json['compression'];
    encoding = json['encoding'];
    data = decodeData(json['data'], encoding, compression);
    draworder = json['draworder'];
    height = json['height'];
    id = json['id'];
    image = json['image'];
    if (json['layers'] != null) {
      layers = <Layer>[];
      json['layers'].forEach((v) {
        layers.add(Layer.fromJson(v));
      });
    }
    name = json['name'];
    offsetx = json['offsetx'];
    offsety = json['offsety'];
    opacity = json['opacity']?.toDouble();
    if (json['properties'] != null) {
      properties = <Property>[];
      json['properties'].forEach((v) {
        properties.add(Property.fromJson(v));
      });
    }
    startx = json['startx'];
    starty = json['starty'];
    tintcolor = json['tintcolor'];
    transparentcolor = json['transparentcolor'];
    type = json['type'];
    visible = json['visible'];
    width = json['width'];
    x = json['x'];
    y = json['y'];
    if (json['objects'] != null) {
      objects = <TiledObject>[];
      json['objects'].forEach((v) {
        objects.add(TiledObject.fromJson(v));
      });
    }
    _generateTileMatrix();
  }

  List<int> decodeData(json, String encoding, String compression) {
    if (json == null) {
      return null;
    }

    if (encoding == null || encoding == 'csv') {
      return json.cast<int>();
    }
    //Ok, its base64
    final Uint8List decodedString = base64.decode(json.trim());
    //zlib, gzip, zstd or empty
    List<int> decompressed;
    switch (compression) {
      case 'zlib':
        decompressed = ZLibDecoder().decodeBytes(decodedString);
        break;
      case 'gzip':
        decompressed = GZipDecoder().decodeBytes(decodedString);
        break;
      case 'zstd':
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
        uint32.add(dv.getUint32(i,Endian.little));
      }
    }
    return uint32;
  }

  static const int FLIPPED_HORIZONTALLY_FLAG = 0x80000000;
  static const int FLIPPED_VERTICALLY_FLAG = 0x40000000;
  static const int FLIPPED_DIAGONALLY_FLAG = 0x20000000;

  void _generateTileMatrix() {
    tileIDMatrix = <List<int>>[];
    tileFlips = <List<Flips>>[];
    if(height == null || width == null){ // objectlayer
      return;
    }
    for (var i = 0; i < height; ++i) {
      final row = <int>[];
      final fliprow = <Flips>[];
      for (var j = 0; j < width; ++j) {
        int id = data[(i*width) + j];
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
        row.add(id);
        fliprow.add(Flips(flippedHorizontally, flippedVertically, flippedDiagonally));
      }
      tileIDMatrix.add(row);
      tileFlips.add(fliprow);
    }
  }
}
