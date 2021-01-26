import 'dart:convert';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:tiled/src/json/chunkjson.dart';
import 'package:tiled/src/json/objectjson.dart';
import 'package:tiled/src/json/propertyjson.dart';
import 'package:tiled/tiled.dart';
import 'package:xml/xml.dart';

class LayerJson {
  List<ChunkJson> chunks = [];
  String
      compression; // zlib, gzip, zstd (since Tiled 1.3) or empty (default). tilelayer
  List<int> data = [];
  String draworder = 'topdown'; //topdown (default) or index. only objectgroup
  String color; // only objectgroup; Not supported by json
  String encoding = 'csv'; // csv (default) or base64. tilelayer
  int height;
  int id;
  Image image; // only on imageLayer
  List<LayerJson> layers = [];
  String name;
  List<ObjectJson> objects = [];
  double offsetx;
  double offsety;
  double opacity;
  List<PropertyJson> properties = [];
  int startx;
  int starty;
  String tintcolor;
  String transparentcolor;
  String type; // tilelayer, objectgroup, imagelayer or group
  bool visible;
  int width;
  int x;
  int y;

  LayerJson(
      {this.chunks,
      this.compression,
      this.data,
      this.draworder,
      this.encoding,
      this.height,
      this.id,
      this.image,
      this.layers,
      this.name,
      this.objects,
      this.offsetx,
      this.offsety,
      this.opacity,
      this.properties,
      this.startx,
      this.starty,
      this.tintcolor,
      this.transparentcolor,
      this.type,
      this.visible,
      this.width,
      this.x,
      this.y});

  LayerJson.fromXML(XmlNode xmlElement) {

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
          image = Image.fromXML(element);
          break;
        case 'data':
          compression = element.getAttribute('compression');
          encoding = element.getAttribute('encoding');
          data = decodeData(element.text, encoding, compression);
          break;
        case 'properties':
          element.nodes.whereType<XmlElement>().forEach((element) {
            properties.add(PropertyJson.fromXML(element));
          });
          break;
        case 'chunks':
          element.nodes.whereType<XmlElement>().forEach((element) {
            chunks.add(ChunkJson.fromXML(element));
          });
          break;
        case 'layers':
          element.nodes.whereType<XmlElement>().forEach((element) {
            layers.add(LayerJson.fromXML(element));
          });
          break;
        case 'objects':
          element.nodes.whereType<XmlElement>().forEach((element) {
            objects.add(ObjectJson.fromXML(element));
          });
          break;
      }
    });
  }

  LayerJson.fromJson(Map<String, dynamic> json) {
    if (json['chunks'] != null) {
      chunks = <ChunkJson>[];
      json['chunks'].forEach((v) {
        chunks.add(ChunkJson.fromJson(v));
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
      layers = <LayerJson>[];
      json['layers'].forEach((v) {
        layers.add(LayerJson.fromJson(v));
      });
    }
    name = json['name'];
    offsetx = json['offsetx'];
    offsety = json['offsety'];
    opacity = json['opacity']?.toDouble();
    if (json['properties'] != null) {
      properties = <PropertyJson>[];
      json['properties'].forEach((v) {
        properties.add(PropertyJson.fromJson(v));
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
      objects = <ObjectJson>[];
      json['objects'].forEach((v) {
        objects.add(ObjectJson.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (chunks != null) {
      data['chunks'] = chunks.map((v) => v.toJson()).toList();
    }
    data['compression'] = compression;
    data['data'] = data;
    data['draworder'] = draworder;
    data['encoding'] = encoding;
    data['height'] = height;
    data['id'] = id;
    data['image'] = image;
    if (layers != null) {
      data['layers'] = layers.map((v) => v.toJson()).toList();
    }
    data['name'] = name;
    data['offsetx'] = offsetx;
    data['offsety'] = offsety;
    data['opacity'] = opacity;
    if (properties != null) {
      data['properties'] = properties.map((v) => v.toJson()).toList();
    }
    data['startx'] = startx;
    data['starty'] = starty;
    data['tintcolor'] = tintcolor;
    data['transparentcolor'] = transparentcolor;
    data['type'] = type;
    data['visible'] = visible;
    data['width'] = width;
    data['x'] = x;
    data['y'] = y;
    if (objects != null) {
      data['objects'] = objects.map((v) => "v.toJson()").toList();
    }
    return data;
  }

  static const int FLIPPED_HORIZONTALLY_FLAG = 0x80000000;
  static const int FLIPPED_VERTICALLY_FLAG = 0x40000000;
  static const int FLIPPED_DIAGONALLY_FLAG = 0x20000000;

  Layer toLayer(TileMap tileMap) {
    final Layer layer = Layer(name, width, height);
    layer.name = name;
    layer.height = height ?? 0;
    layer.properties = <String, dynamic>{};
    properties.forEach((element) {
      layer.properties.putIfAbsent(element.name, () => element.value);
    });
    layer.visible = visible;
    layer.width = width ?? 0;
    layer.map = tileMap;

    layer.tileMatrix = List.generate(layer.height, (_) => List<int>(layer.width));
    layer.tileFlips = List.generate(layer.height, (_) => List<Flips>(layer.width));

    for (var i = 0; i < layer.height; ++i) {
      for (var j = 0; j < layer.width; ++j) {
        final gid = data[(i * layer.width) + j];
        layer.tileMatrix[i][j] = gid;
        // Read out the flags
        final flippedHorizontally =
            (gid & FLIPPED_HORIZONTALLY_FLAG) == FLIPPED_HORIZONTALLY_FLAG;
        final flippedVertically =
            (gid & FLIPPED_VERTICALLY_FLAG) == FLIPPED_VERTICALLY_FLAG;
        final flippedDiagonally =
            (gid & FLIPPED_DIAGONALLY_FLAG) == FLIPPED_DIAGONALLY_FLAG;

        // Save rotation flags
        layer.tileFlips[i][j] = Flips(
          flippedHorizontally,
          flippedVertically,
          flippedDiagonally,
        );
      }
    }

    // TODO not filled in Layer
    // List<List<Tile>> _tiles;

    // TODO not converted
    // layer.chunks = chunks;
    // layer.compression = compression;
    // layer.data = data;
    // layer.draworder = draworder; // TODO sorting?
    // layer.encoding = encoding;
    // layer.id = id;
    // layer.image = image;
    // layer.layers = layers;
    // layer.objects = objects;
    // layer.offsetx = offsetx;
    // layer.offsety = offsety;
    // layer.opacity = opacity;
    // layer.startx = startx;
    // layer.starty = starty;
    // layer.tintcolor = tintcolor;
    // layer.transparentcolor = transparentcolor;
    // layer.type = type;
    // layer.x = x;
    // layer.y = y;

    return layer;
  }

  ObjectGroup toObjectGroup(TileMap tileMap) {
    final ObjectGroup objectGroup = ObjectGroup();
    objectGroup.name = name;
    objectGroup.opacity = opacity;
    objectGroup.properties = <String, dynamic>{};
    properties.forEach((element) {
      objectGroup.properties.putIfAbsent(element.name, () => element.value);
    });
    objectGroup.visible = visible;
    objectGroup.map = tileMap;
    objectGroup.tmxObjects = [];
    objects.forEach((element) {
      objectGroup.tmxObjects.add(element.toTmxObject());
    });
    objectGroup.color = color;

    // TODO not converted
    // objectGroup.chunks = chunks;
    // objectGroup.compression = compression; //TODO compression
    // objectGroup.data = data;
    // objectGroup.draworder = draworder; // TODO sorting?
    // objectGroup.encoding = encoding;
    // objectGroup.height = height;
    // objectGroup.id = id;
    // objectGroup.image = image;
    // objectGroup.layers = layers;
    // objectGroup.offsetx = offsetx;
    // objectGroup.offsety = offsety;
    // objectGroup.startx = startx;
    // objectGroup.starty = starty;
    // objectGroup.tintcolor = tintcolor;
    // objectGroup.transparentcolor = transparentcolor;
    // objectGroup.type = type;
    // objectGroup.width = width;
    // objectGroup.x = x;
    // objectGroup.y = y;

    return objectGroup;
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
        throw UnsupportedError("zstd is an unsupported compression"); //TODO zstd compression
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
}
