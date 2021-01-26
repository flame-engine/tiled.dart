import 'package:tiled/src/json/editorsettingsjson.dart';
import 'package:tiled/src/json/layerjson.dart';
import 'package:tiled/src/json/propertyjson.dart';
import 'package:tiled/src/json/tilesetjson.dart';
import 'package:tiled/tiled.dart';
import 'package:xml/xml.dart';

class MapJson {
  String backgroundcolor;
  int compressionlevel;
  List<EditorsettingJson> editorsettings;
  int height;
  int hexsidelength;
  bool infinite;
  List<LayerJson> layers = [];
  int nextlayerid;
  int nextobjectid;
  String orientation; // orthogonal, isometric, staggered or hexagonal
  List<PropertyJson> properties = [];
  String renderorder; // right-down (the default), right-up, left-down and left-up.
  String staggeraxis; // x or y
  String staggerindex; // odd or even
  String tiledversion;
  int tileheight;
  List<TilesetJson> tilesets = [];
  int tilewidth;
  String type;
  num version;
  int width;

  MapJson({this.backgroundcolor,
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


  MapJson.fromXml(XmlElement xmlElement) {
    if (xmlElement.name.local != 'map') {
      throw 'XML is not in TMX format';
    }

    backgroundcolor = xmlElement.getAttribute('backgroundcolor');
    compressionlevel = int.tryParse(xmlElement.getAttribute('compressionlevel') ?? "-1"); //defaults to -1
    height = int.tryParse(xmlElement.getAttribute('height') ?? '');
    hexsidelength = int.tryParse(xmlElement.getAttribute('hexsidelength') ?? '');
    infinite = int.tryParse(xmlElement.getAttribute('infinite') ?? "0") != 0;  // 0 for false, 1 for true, defaults to 0)
    nextlayerid = int.tryParse(xmlElement.getAttribute('nextlayerid') ?? '');
    nextobjectid = int.tryParse(xmlElement.getAttribute('nextobjectid') ?? '');
    orientation = xmlElement.getAttribute('orientation');
    renderorder = xmlElement.getAttribute('renderorder') ?? "right-down"; // right-down (the default), right-up, left-down and left-up.
    staggeraxis = xmlElement.getAttribute('staggeraxis');
    staggerindex = xmlElement.getAttribute('staggerindex');
    tiledversion = xmlElement.getAttribute('tiledversion');
    tileheight = int.tryParse(xmlElement.getAttribute('tileheight') ?? '');
    tilewidth = int.tryParse(xmlElement.getAttribute('tilewidth') ?? '');
    type = "map"; // only set in jsonImport
    version = int.tryParse(xmlElement.getAttribute('version') ?? '');
    width = int.tryParse(xmlElement.getAttribute('width') ?? '');

    xmlElement.children.whereType<XmlElement>().forEach((XmlElement element) {
      switch (element.name.local) {
        case 'tileset':
          tilesets.add(TilesetJson.fromXML(element));
          break;
        case 'layer':
          layers.add(LayerJson.fromXML(element));
          break;
        // case 'objectgroup': //TODO split in json and new in tmx
        //   element.nodes.forEach((element) {objectGroups.add(ObjectGroupJson.fromXML(element));});
        //   break;
        // case 'imagelayer':
        //   element.nodes.forEach((element) {imageLayers.add(ImageLayerJson.fromXML(element));});
        //   break;
        // case 'group':
        //   element.nodes.forEach((element) {groups.add(GroupJson.fromXML(element));});
        //   break;
        case 'properties':
          element.nodes.whereType<XmlElement>().forEach((element) {properties.add(PropertyJson.fromXML(element));});
          break;
        case 'editorsettings':
          element.nodes.whereType<XmlElement>().forEach((element) {editorsettings.add(EditorsettingJson.fromXML(element));});
          break;
      }
    });
  }


  MapJson.fromJson(Map<String, dynamic> json) {
    backgroundcolor = json['backgroundcolor'];
    compressionlevel = json['compressionlevel'] ?? -1;
    if (json['editorsettings'] != null) {
      editorsettings = <EditorsettingJson>[];
      editorsettings.add(EditorsettingJson.fromJson(json['editorsettings']));
    }
    height = json['height'];
    hexsidelength = json['hexsidelength'];
    infinite = json['infinite'] ?? false;
    if (json['layers'] != null) {
      layers = <LayerJson>[];
      json['layers'].forEach((v) {
        layers.add(LayerJson.fromJson(v)); // TODO sorting?
        //TODO Split by type == tilelayer, objectgroup, imagelayer or group
        // - layers
        // - objectGroups
        // - imageLayers
        // - groups
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
    renderorder = json['renderorder'] ?? "right-down";
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
    type = json['type'] ?? "map";
    version = json['version'];
    width = json['width'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['backgroundcolor'] = backgroundcolor;
    data['compressionlevel'] = compressionlevel;
    if (editorsettings != null) {
      data['editorsettings'] = editorsettings.map((v) => v.toJson()).toList();
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

  TileMap toTileMap() {
    final TileMap tileMap = TileMap();

    tileMap.height = height;
    tileMap.width = width;
    tileMap.layers = [];
    layers.where((element) => element.type != 'objectgroup').forEach((element) {
      tileMap.layers.add(element.toLayer(tileMap));
    });
    tileMap.objectGroups = [];
    layers.where((element) => element.type == 'objectgroup').forEach((element) {
      tileMap.objectGroups.add(element.toObjectGroup(tileMap));
    });
    tileMap.properties = <String, dynamic>{};
    properties.forEach((element) {
      tileMap.properties.putIfAbsent(element.name, () => element.value);
    });

    tileMap.tileHeight = tileheight;
    tileMap.tilesets = [];
    tilesets.forEach((element) {
      tileMap.tilesets.add(element.toTileset(tileMap));
    });
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
