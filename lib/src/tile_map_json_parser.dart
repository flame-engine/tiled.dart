part of tiled;

class TileMapJsonParser {
  TileMapJsonParser();

  MapJson parse(String string) {
    // TODO Check Filetype?
    // TODO Custom parser?
    // TODO ?.toDouble()
    final MapJson mapJson = MapJson.fromJson(jsonDecode(string));
    return mapJson;
  }
}

class MapJson {
  String backgroundcolor;
  int compressionlevel;
  EditorsettingJson editorsettings; // TODO not in description
  int height;
  int hexsidelength;
  bool infinite;
  List<LayerJson> layers = [];
  int nextlayerid;
  int nextobjectid;
  String orientation; // orthogonal, isometric, staggered or hexagonal
  List<PropertyJson> properties = [];
  String renderorder;
  String staggeraxis; // x or y
  String staggerindex; // odd or even
  String tiledversion;
  int tileheight;
  List<TilesetJson> tilesets = [];
  int tilewidth;
  String type;
  num version;
  int width;

  MapJson(
      {this.backgroundcolor,
      this.compressionlevel,
      this.editorsettings,
      this.height,
      this.hexsidelength,
      this.infinite,
      this.layers,
      this.nextlayerid,
      this.nextobjectid,
      this.orientation,
      this.properties,
      this.renderorder,
      this.staggeraxis,
      this.staggerindex,
      this.tiledversion,
      this.tileheight,
      this.tilesets,
      this.tilewidth,
      this.type,
      this.version,
      this.width});

  MapJson.fromJson(Map<String, dynamic> json) {
    backgroundcolor = json['backgroundcolor'];
    compressionlevel = json['compressionlevel'];
    editorsettings = json['editorsettings'] != null
        ? EditorsettingJson.fromJson(json['editorsettings'])
        : null;
    height = json['height'];
    hexsidelength = json['hexsidelength'];
    infinite = json['infinite'];
    if (json['layers'] != null) {
      layers = <LayerJson>[];
      json['layers'].forEach((v) {
        layers.add(LayerJson.fromJson(v)); // TODO sorting?
      });
    }
    nextlayerid = json['nextlayerid'];
    nextobjectid = json['nextobjectid'];
    orientation = json['orientation'];
    if (json['properties'] != null) {
      properties = <PropertyJson>[];
      json['properties'].forEach((v) {
        properties.add(PropertyJson.fromJson(v));
      });
    }
    renderorder = json['renderorder'];
    staggeraxis = json['staggeraxis'];
    staggerindex = json['staggerindex'];
    tiledversion = json['tiledversion'];
    tileheight = json['tileheight'];
    if (json['tilesets'] != null) {
      tilesets = <TilesetJson>[];
      json['tilesets'].forEach((v) {
        tilesets.add(TilesetJson.fromJson(v)); // TODO sorting?
      });
    }
    tilewidth = json['tilewidth'];
    type = json['type'];
    version = json['version'];
    width = json['width'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['backgroundcolor'] = backgroundcolor;
    data['compressionlevel'] = compressionlevel;
    if (editorsettings != null) {
      data['editorsettings'] = editorsettings.toJson();
    }
    data['height'] = height;
    data['hexsidelength'] = hexsidelength;
    data['infinite'] = infinite;
    if (layers != null) {
      data['layers'] = layers.map((v) => v.toJson()).toList();
    }
    data['nextlayerid'] = nextlayerid;
    data['nextobjectid'] = nextobjectid;
    data['orientation'] = orientation;
    if (properties != null) {
      data['properties'] = properties.map((v) => v.toJson()).toList();
    }
    data['renderorder'] = renderorder;
    data['staggeraxis'] = staggeraxis;
    data['staggerindex'] = staggerindex;
    data['tiledversion'] = tiledversion;
    data['tileheight'] = tileheight;
    if (tilesets != null) {
      data['tilesets'] = tilesets.map((v) => v.toJson()).toList();
    }
    data['tilewidth'] = tilewidth;
    data['type'] = type;
    data['version'] = version;
    data['width'] = width;
    return data;
  }

  TileMap toTileMap(){
    final TileMap tileMap = TileMap();

    tileMap.height = height;
    tileMap.width = width;
    tileMap.layers = [];
    layers.where((element) => element.type != 'objectgroup').forEach((element) {tileMap.layers.add(element.toLayer(tileMap));});
    tileMap.objectGroups = [];
    layers.where((element) => element.type == 'objectgroup').forEach((element) {tileMap.objectGroups.add(element.toObjectGroup(tileMap));});
    tileMap.properties = <String, dynamic>{};
    properties.forEach((element) {tileMap.properties.putIfAbsent(element.name, () => element.value);});

    tileMap.tileHeight = tileheight;
    tileMap.tilesets = [];
    tilesets.forEach((element) {tileMap.tilesets.add(element.toTileset(tileMap));});
    tileMap.tileWidth = tilewidth;


    // TODO not converted to TileMap
    // tileMap.backgroundcolor = backgroundcolor;
    // tileMap.compressionlevel = compressionlevel;
    // tileMap.editorsettings = editorsettings;
    // tileMap.hexsidelength = hexsidelength;
    // tileMap.infinite = infinite;
    // tileMap.nextlayerid = nextlayerid;
    // tileMap.nextobjectid = nextobjectid;
    // tileMap.orientation = orientation;
    // tileMap.renderorder = renderorder;
    // tileMap.staggeraxis = staggeraxis;
    // tileMap.staggerindex = staggerindex;
    // tileMap.tiledversion = tiledversion;
    // tileMap.type = type;
    // tileMap.version = version;

    return tileMap;
  }

}

class EditorsettingJson {
  ChunkJson chunksize;
  ExportJson export;

  EditorsettingJson({this.chunksize, this.export});

  EditorsettingJson.fromJson(Map<String, dynamic> json) {
    chunksize = json['chunksize'] != null
        ? ChunkJson.fromJson(json['chunksize'])
        : null;
    export =
        json['export'] != null ? ExportJson.fromJson(json['export']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (chunksize != null) {
      data['chunksize'] = chunksize.toJson();
    }
    if (export != null) {
      data['export'] = export.toJson();
    }
    return data;
  }
}

class ChunkJson {
  String data; // TODO array or string - 	Array of unsigned int (GIDs) or base64-encoded data
  int height;
  int width;
  int x;
  int y;

  ChunkJson({this.data, this.height, this.width, this.x, this.y});

  ChunkJson.fromJson(Map<String, dynamic> json) {
    data = json['data'];
    height = json['height'];
    width = json['width'];
    x = json['x'];
    y = json['y'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['data'] = data;
    data['height'] = height;
    data['width'] = width;
    data['x'] = x;
    data['y'] = y;
    return data;
  }
}

class ExportJson {
  String format;
  String target;

  ExportJson({this.format, this.target});

  ExportJson.fromJson(Map<String, dynamic> json) {
    format = json['format'];
    target = json['target'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['format'] = format;
    data['target'] = target;
    return data;
  }
}

class LayerJson {
  List<ChunkJson> chunks = [];
  String
      compression; // zlib, gzip, zstd (since Tiled 1.3) or empty (default). tilelayer
  List<int> data = [];
  String draworder = 'topdown'; //topdown (default) or index. objectgroup
  String encoding = 'csv'; // csv (default) or base64. tilelayer
  int height;
  int id;
  String image;
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
      data['objects'] =
          objects.map((v) => "v.toJson()").toList();
    }
    return data;
  }


  static const int FLIPPED_HORIZONTALLY_FLAG = 0x80000000;
  static const int FLIPPED_VERTICALLY_FLAG = 0x40000000;
  static const int FLIPPED_DIAGONALLY_FLAG = 0x20000000;

  Layer toLayer(TileMap tileMap) {
    final Layer layer = Layer(name, width, height);
    layer.name = name;
    layer.height = height;
    layer.properties = <String, dynamic>{};
    properties.forEach((element) {layer.properties.putIfAbsent(element.name, () => element.value);});
    layer.visible = visible;
    layer.width = width;
    layer.map = tileMap;

    layer.tileMatrix = List.generate(height, (_) => List<int>(width));
    layer.tileFlips = List.generate(height, (_) => List<Flips>(width));

    for (var i = 0; i < height; ++i) {
      for (var j = 0; j < width; ++j) {
        final gid = data[(i*width) + j];
        layer.tileMatrix [i][j] = gid;
        // Read out the flags
        final flippedHorizontally =
            (gid & FLIPPED_HORIZONTALLY_FLAG) ==
                FLIPPED_HORIZONTALLY_FLAG;
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
    properties.forEach((element) {objectGroup.properties.putIfAbsent(element.name, () => element.value);});
    objectGroup.visible = visible;
    objectGroup.map = tileMap;
    objectGroup.tmxObjects = [];
    objects.forEach((element) {objectGroup.tmxObjects.add(element.toTmxObject());});
    objectGroup.color = tintcolor; // TODO is this correct? or "transparentcolor"

    
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

  List<int> decodeData(json, String encoding, String compression){
    if(json == null){
      return null;
    }

    if(encoding == null || encoding == 'csv'){
      return json.cast<int>();
    }
    //Ok, its base64
    final Uint8List decodedString = base64.decode(json);
    //zlib, gzip, zstd or empty
    List<int> decompressed;
    switch (compression) {
      case 'zlib':
        decompressed = ZLibDecoder().decodeBytes(decodedString);
        break;
      case 'gzip':
        decompressed =  GZipDecoder().decodeBytes(decodedString);
        break;
      case 'zstd':
        throw UnsupportedError("zstd is an unsupported compression"); //TODO
      default:
        decompressed = decodedString;
        break;
    }

    // I have no idea why, but every base64 String has 4 digits instead of one, so it has to be reduced
    final reducedString = <int>[];
    for (var i = 0; i < decompressed.length; ++i) {
      if(i%4==0){
        reducedString.add(decompressed[i]);
      }
    }
    return reducedString;
  }

}

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

  TmxObject toTmxObject(){
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
    properties.forEach((element) {tmxObject.properties.putIfAbsent(element.name, () => element.value);});

    if(!ellipse) {
      if (polygon.isNotEmpty) {
        tmxObject.isPolygon = true;
        tmxObject.points = <Point>[];
        polygon.forEach((element) {tmxObject.points.add(element.toPoint());});
      } else if (polyline.isNotEmpty) {
        tmxObject.isPolyline = true;
        tmxObject.points = <Point>[];
        polyline.forEach((element) {tmxObject.points.add(element.toPoint());});
      }
      //tmxObject.isRectangle = false; //TODO How to detect?
      // tmxObject.point = point; //TODO No idea what this is

      //tmxObject.template = template;  //TODO No idea what this is
      //tmxObject.text = text; //TODO No equivalent in tmx
    }
    return tmxObject;
  }
}

class PointJson {
  num x;
  num y;

  PointJson({this.x, this.y});

  PointJson.fromJson(Map<String, dynamic> json) {
    x = json['x'];
    y = json['y'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['x'] = x;
    data['y'] = y;
    return data;
  }

  Point<num> toPoint() {
    return Point(x,y);
  }
}

class TextJson {
  bool bold = false;
  String color = '#000000';
  String fontfamily = 'sans-serif';
  String halign = 'left'; // center, right, justify or left
  bool italic = false;
  bool kerning = true;
  int pixelsize = 16;
  bool strikeout = false;
  String text = "";
  bool underline = false;
  String valign = 'top'; // center, bottom or top
  bool wrap = false;

  TextJson(
      {this.bold,
      this.color,
      this.fontfamily,
      this.halign,
      this.italic,
      this.kerning,
      this.pixelsize,
      this.strikeout,
      this.text,
      this.underline,
      this.valign,
      this.wrap});

  TextJson.fromJson(Map<String, dynamic> json) {
    bold = json['bold'];
    color = json['color'];
    fontfamily = json['fontfamily'];
    halign = json['halign'];
    italic = json['italic'];
    kerning = json['kerning'];
    pixelsize = json['pixelsize'];
    strikeout = json['strikeout'];
    text = json['text'];
    underline = json['underline'];
    valign = json['valign'];
    wrap = json['wrap'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['bold'] = bold;
    data['color'] = color;
    data['fontfamily'] = fontfamily;
    data['halign'] = halign;
    data['italic'] = italic;
    data['kerning'] = kerning;
    data['pixelsize'] = pixelsize;
    data['strikeout'] = strikeout;
    data['text'] = text;
    data['underline'] = underline;
    data['valign'] = valign;
    data['wrap'] = wrap;
    return data;
  }
}

class PropertyJson {
  String name;
  String type;
  String value;

  PropertyJson({this.name, this.type, this.value});

  PropertyJson.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    type = json['type'];
    value = json['value'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['type'] = type;
    data['value'] = value;
    return data;
  }
}

class TilesetJson {
  String backgroundcolor;
  int columns;
  int firstgid;
  GridJson grid;
  String image;
  int imageheight;
  int imagewidth;
  int margin;
  String name;
  String objectalignment;
  List<PropertyJson> properties = [];
  String source;
  int spacing;
  List<TerrainJson> terrains = [];
  int tilecount;
  String tiledversion;
  TileOffsetJson tileoffset;
  List<TileJson> tiles = [];
  int tileheight;
  int tilewidth;
  String transparentcolor;
  String type;
  num version;
  List<WangSetJson> wangsets = [];

  TilesetJson(
      {this.backgroundcolor,
      this.columns,
      this.firstgid,
      this.grid,
      this.image,
      this.imageheight,
      this.imagewidth,
      this.margin,
      this.name,
      this.objectalignment,
      this.properties,
      this.source,
      this.spacing,
      this.terrains,
      this.tilecount,
      this.tiledversion,
      this.tileheight,
      this.tileoffset,
      this.tiles,
      this.tilewidth,
      this.transparentcolor,
      this.type,
      this.version,
      this.wangsets});

  TilesetJson.fromJson(Map<String, dynamic> json) {
    backgroundcolor = json['backgroundcolor'];
    columns = json['columns'];
    firstgid = json['firstgid'];
    grid = json['grid'] != null ? GridJson.fromJson(json['grid']) : null;
    image = json['image'];
    imageheight = json['imageheight'];
    imagewidth = json['imagewidth'];
    margin = json['margin'];
    name = json['name'];
    objectalignment = json['objectalignment'];
    if (json['properties'] != null) {
      properties = <PropertyJson>[];
      json['properties'].forEach((v) {
        properties.add(PropertyJson.fromJson(v));
      });
    }
    source = json['source'];
    spacing = json['spacing'];
    if (json['terrains'] != null) {
      terrains = <TerrainJson>[];
      json['terrains'].forEach((v) {
        terrains.add(TerrainJson.fromJson(v));
      });
    }
    tilecount = json['tilecount'];
    tiledversion = json['tiledversion'];
    tileheight = json['tileheight'];
    tileoffset = json['tileoffset'] != null
        ? TileOffsetJson.fromJson(json['tileoffset'])
        : null;
    if (json['tiles'] != null) {
      tiles = <TileJson>[];
      json['tiles'].forEach((v) {
        tiles.add(TileJson.fromJson(v));
      });
    }
    tilewidth = json['tilewidth'];
    transparentcolor = json['transparentcolor'];
    type = json['type'];
    version = json['version'];
    if (json['wangsets'] != null) {
      wangsets = <WangSetJson>[];
      json['wangsets'].forEach((v) {
        wangsets.add(WangSetJson.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['backgroundcolor'] = backgroundcolor;
    data['columns'] = columns;
    data['firstgid'] = firstgid;
    if (grid != null) {
      data['grid'] = grid.toJson();
    }
    data['image'] = image;
    data['imageheight'] = imageheight;
    data['imagewidth'] = imagewidth;
    data['margin'] = margin;
    data['name'] = name;
    data['objectalignment'] = objectalignment;
    data['properties'] = properties;
    data['source'] = source;
    data['spacing'] = spacing;
    data['terrains'] = terrains;
    data['tilecount'] = tilecount;
    data['tiledversion'] = tiledversion;
    data['tileheight'] = tileheight;
    if (tileoffset != null) {
      data['tileoffset'] = tileoffset.toJson();
    }
    if (tiles != null) {
      data['tiles'] = tiles.map((v) => v.toJson()).toList();
    }
    data['tilewidth'] = tilewidth;
    data['transparentcolor'] = transparentcolor;
    data['type'] = type;
    data['version'] = version;
    data['wangsets'] = wangsets;
    return data;
  }

  Tileset toTileset(TileMap map){
    final Tileset tileset = Tileset(firstgid);
    //tileset.firstgid = firstgid; // via constructor
    tileset.width = columns;
    tileset.height = (tilecount / columns).round();
    tileset.margin = margin;
    tileset.name = name;
    tileset.properties = <String, dynamic>{};
    properties.forEach((element) {tileset.properties.putIfAbsent(element.name, () => element.value);});
    tileset.source = source;
    tileset.spacing = spacing;
    tileset.map = map;

    tileset.image = Image(image, imagewidth, imageheight);
    tileset.images = [tileset.image]; //TODO this had to be be wrong :D

    tileset.tileProperties = {};
    tiles.sort((a, b) => a.id.compareTo(b.id));
    tiles.forEach((element) {tileset.tileProperties.putIfAbsent(element.id + tileset.firstgid, () {
      final props = <String, dynamic>{};
      element.properties.forEach((element) {props.putIfAbsent(element.name, () => element.value);});
      return props;
    });});
    tileset.tileImage = {};
    tiles.forEach((element) {tileset.tileImage.putIfAbsent(element.id + tileset.firstgid,
            () => element.image == null ? null : Image(element.image, element.imagewidth, element.imageheight));});

    // TODO not converted to Tileset
    // tileset.backgroundcolor = backgroundcolor;
    // tileset.columns = columns;
    // tileset.grid = grid;
    // tileset.objectalignment = objectalignment;
    // tileset.terrains = terrains;
    // tileset.tilecount = tilecount;
    // tileset.tiledversion = tiledversion;
    // tileset.tileheight = tileheight;
    // tileset.tileoffset = tileoffset;
    // tileset.tiles = tiles;
    // tileset.tilewidth = tilewidth;
    // tileset.transparentcolor = transparentcolor;
    // tileset.type = type;
    // tileset.version = version;
    // tileset.wangsets = wangsets;
    return tileset;
  }
}

class GridJson {
  int height;
  String orientation;
  int width;

  GridJson({this.height, this.orientation, this.width});

  GridJson.fromJson(Map<String, dynamic> json) {
    height = json['height'];
    orientation = json['orientation'];
    width = json['width'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['height'] = height;
    data['orientation'] = orientation;
    data['width'] = width;
    return data;
  }
}

class TileOffsetJson {
  int x;
  int y;

  TileOffsetJson({this.x, this.y});

  TileOffsetJson.fromJson(Map<String, dynamic> json) {
    x = json['x'];
    y = json['y'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['x'] = x;
    data['y'] = y;
    return data;
  }
}

class FrameJson {
  int duration;
  int tileid;

  FrameJson({this.duration, this.tileid});

  FrameJson.fromJson(Map<String, dynamic> json) {
    duration = json['duration'];
    tileid = json['tileid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['duration'] = duration;
    data['tileid'] = tileid;
    return data;
  }
}

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

class WangColorJson {
  String color;
  String name;
  double probability;
  int tile;

  WangColorJson({this.color, this.name, this.probability, this.tile});

  WangColorJson.fromJson(Map<String, dynamic> json) {
    color = json['color'];
    name = json['name'];
    probability = json['probability'];
    tile = json['tile'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['color'] = color;
    data['name'] = name;
    data['probability'] = probability;
    data['tile'] = tile;
    return data;
  }
}

class WangTileJson {
  bool dflip;
  bool hflip;
  int tile;
  bool vflip;
  List<int> wangid = [];

  WangTileJson({this.dflip, this.hflip, this.tile, this.vflip, this.wangid});

  WangTileJson.fromJson(Map<String, dynamic> json) {
    dflip = json['dflip'];
    hflip = json['hflip'];
    tile = json['tile'];
    vflip = json['vflip'];
    wangid = json['wangid'];
    if (json['wangid'] != null) {
      wangid = <int>[];
      json['wangid'].forEach((v) {
        wangid.add(v);
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['dflip'] = dflip;
    data['hflip'] = hflip;
    data['tile'] = tile;
    data['vflip'] = vflip;
    if (wangid != null) {
      data['wangid'] = wangid.map((v) => v).toList();
    }
    return data;
  }
}

class TileJson {
  List<FrameJson> animation = [];
  int id;
  String image;
  int imageheight;
  int imagewidth;
  LayerJson objectgroup;
  double probability;
  List<PropertyJson> properties = [];
  List<int> terrain = []; // index of the terrain
  String type;

  TileJson(
      {this.animation,
      this.id,
      this.image,
      this.imageheight,
      this.imagewidth,
      this.objectgroup,
      this.probability,
      this.properties,
      this.terrain,
      this.type});

  TileJson.fromJson(Map<String, dynamic> json) {
    if (json['animation'] != null) {
      animation = <FrameJson>[];
      json['animation'].forEach((v) {
        animation.add(FrameJson.fromJson(v));
      });
    }
    id = json['id'];
    image = json['image'];
    imageheight = json['imageheight'];
    imagewidth = json['imagewidth'];
    objectgroup = json['objectgroup'];
    probability = json['probability'];
    if (json['properties'] != null) {
      properties = <PropertyJson>[];
      json['properties'].forEach((v) {
        properties.add(PropertyJson.fromJson(v));
      });
    }
    if (json['terrain'] != null) {
      terrain = <int>[];
      json['terrain'].forEach((v) {
        terrain.add(v);
      });
    }
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (animation != null) {
      data['animation'] = animation.map((v) => v).toList();
    }
    data['id'] = id;
    data['image'] = image;
    data['imageheight'] = imageheight;
    data['imagewidth'] = imagewidth;
    data['objectgroup'] = objectgroup;
    data['probability'] = probability;
    if (properties != null) {
      data['properties'] = properties.map((v) => v.toJson()).toList();
    }
    if (terrain != null) {
      data['terrain'] = terrain.map((v) => v).toList();
    }
    data['type'] = type;
    return data;
  }

  Tile toTile(Tileset tileset){
    final Tile tile = Tile(id, tileset);

    tile.image = Image(image, imagewidth, imageheight);
    tile.properties = <String, dynamic>{};
    properties.forEach((element) {tile.properties.putIfAbsent(element.name, () => element.value);});

    // TODO not converted
    // tile.animation = animation;
    // tile.objectgroup = objectgroup;
    // tile.probability = probability;
    // tile.terrain = terrain;
    // tile.type = type;


    // TODO not filled
    // // Tile global IDs aren't 1-based, but start from "1" (0 being an "null tile").
    // int gid;
    // int spacing;
    // int margin;
    // int height;
    // int width;
    // Flips flips;
    // int x, y;
    // int px, py;


    return tile;
  }


}
