import 'package:tiled/src/json/gridjson.dart';
import 'package:tiled/src/json/propertyjson.dart';
import 'package:tiled/src/json/terrainjson.dart';
import 'package:tiled/src/json/tilejson.dart';
import 'package:tiled/src/json/tileoffsetjson.dart';
import 'package:tiled/src/json/wangsetjson.dart';
import 'package:tiled/tiled.dart';
import 'package:xml/src/xml/nodes/node.dart';
import 'package:xml/xml.dart';

class TilesetJson {
  String backgroundcolor;
  int columns;
  int firstgid;
  GridJson grid;
  Image image;
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

  TilesetJson.fromXML(XmlNode xmlElement) {
    backgroundcolor = xmlElement.getAttribute('backgroundcolor');
    columns = int.parse(xmlElement.getAttribute('columns'));
    firstgid = int.parse(xmlElement.getAttribute('firstgid'));
    margin = int.parse(xmlElement.getAttribute('margin'));
    name = xmlElement.getAttribute('name');
    objectalignment = xmlElement.getAttribute('objectalignment');
    source = xmlElement.getAttribute('source');
    spacing = int.parse(xmlElement.getAttribute('spacing'));
    tilecount = int.parse(xmlElement.getAttribute('tilecount'));
    tileheight = int.parse(xmlElement.getAttribute('tileheight'));
    tiledversion = xmlElement.getAttribute('tiledversion');
    tilewidth = int.parse(xmlElement.getAttribute('tilewidth'));
    transparentcolor = xmlElement.getAttribute('transparentcolor');
    type = xmlElement.getAttribute('type');
    version = int.parse(xmlElement.getAttribute('version'));

    xmlElement.children.whereType<XmlElement>().forEach((XmlElement element) {
      switch (element.name.local) {
        case 'image':
          image = Image.fromXML(element);
          break;
        case 'grid':
          grid = GridJson.fromXML(element);
          break;
        case 'tileoffset':
          tileoffset = TileOffsetJson.fromXML(element);
          break;
        case 'properties':
          element.nodes.forEach((element) {
            properties.add(PropertyJson.fromXML(element));
          });
          break;
        case 'terrains':
          element.nodes.forEach((element) {
            terrains.add(TerrainJson.fromXML(element));
          });
          break;
        case 'tiles':
          element.nodes.forEach((element) {
            tiles.add(TileJson.fromXML(element));
          });
          break;
        case 'wangsets':
          element.nodes.forEach((element) {
            wangsets.add(WangSetJson.fromXML(element));
          });
          break;
      }
    });
  }

  TilesetJson.fromJson(Map<String, dynamic> json) {
    backgroundcolor = json['backgroundcolor'];
    columns = json['columns'];
    firstgid = json['firstgid'];
    grid = json['grid'] != null ? GridJson.fromJson(json['grid']) : null;
    if (json['image'] != null) {
      image = Image(json['image'], json['imageheight'], json['imagewidth']);
    }
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
    data['image'] = image.source;
    data['imageheight'] = image.height;
    data['imagewidth'] = image.width;
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

  Tileset toTileset(TileMap map) {
    final Tileset tileset = Tileset(firstgid);
    //tileset.firstgid = firstgid; // via constructor
    tileset.width = columns;
    tileset.height = (tilecount / columns).round();
    tileset.margin = margin;
    tileset.name = name;
    tileset.properties = <String, dynamic>{};
    properties.forEach((element) {
      tileset.properties.putIfAbsent(element.name, () => element.value);
    });
    tileset.source = source;
    tileset.spacing = spacing;
    tileset.map = map;

    tileset.image = image;
    tileset.images = [tileset.image]; //TODO this had to be be wrong :D

    tileset.tileProperties = {};
    tiles.sort((a, b) => a.id.compareTo(b.id));
    tiles.forEach((element) {
      tileset.tileProperties.putIfAbsent(element.id + tileset.firstgid, () {
        final props = <String, dynamic>{};
        element.properties.forEach((element) {
          props.putIfAbsent(element.name, () => element.value);
        });
        return props;
      });
    });
    tileset.tileImage = {};
    tiles.forEach((element) {
      tileset.tileImage
          .putIfAbsent(element.id + tileset.firstgid, () => element.image);
    });

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
