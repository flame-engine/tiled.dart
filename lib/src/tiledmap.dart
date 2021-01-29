part of tiled;


class TiledMap {
  String backgroundcolor;
  int compressionlevel;
  List<Editorsetting> editorsettings;
  int height;
  int hexsidelength;
  bool infinite;
  List<Layer> layers = [];
  int nextlayerid;
  int nextobjectid;
  String orientation; // orthogonal, isometric, staggered or hexagonal
  List<Property> properties = [];
  String renderorder; // right-down (the default), right-up, left-down and left-up.
  String staggeraxis; // x or y
  String staggerindex; // odd or even
  String tiledversion;
  int tileheight;
  List<Tileset> tilesets = [];
  int tilewidth;
  String type;
  num version;
  int width;

  // Convenience Methods
  Tile getTileByGID(int cleanTileID){
    final Tileset tileset = getTilesetByTileID(cleanTileID);
    final tiles = tileset.tiles.where((element) => element.gid == (cleanTileID - tileset.firstgid)).toList();
    if(tiles.isNotEmpty){
      return tiles.first;
    }
    return null;
  }

  Tileset getTilesetByTileID(int cleanTileID){
    if(tilesets.length == 1){
      return tilesets.first;
    }
    for (var i = 0; i < tilesets.length; ++i) {
      if(tilesets[i].firstgid > cleanTileID){
        return tilesets[i-1];
      }
    }
    return tilesets.last;
  }

  List<TiledImage> getTiledImages(){
    final imageSet = <TiledImage>{};
    for (var i = 0; i < tilesets.length; ++i) {
      if(tilesets[i].image != null) {
        imageSet.add(tilesets[i].image);
      }
      for (var j = 0; j < tilesets[i].tiles.length; ++j) {
        final Tile t = tilesets[i].tiles[j];
        if(t.image != null){
          imageSet.add(t.image);
        }
      }
    }
    for (var i = 0; i < layers.length; ++i) {
      if(layers[i].image != null) {
        imageSet.add(layers[i].image);
      }
    }
    return imageSet.toList();
  }

  Layer getLayerByName(String s) {
    return layers.firstWhere((element) => element.name == s);
  }

  getTilesetByName(String s) {
    return tilesets.firstWhere((element) => element.name == s);
  }

  TiledMap.fromXml(XmlElement xmlElement, {TsxProvider tsx}) {
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
          tilesets.add(Tileset.fromXml(element, tsx: tsx));
          break;
        case 'layer':
          final layer = Layer.fromXml(element);
          layer.type = 'tilelayer';
          layers.add(layer);
          break;
        case 'objectgroup':
          final layer = Layer.fromXml(element);
          layer.type = 'objectgroup';
          layers.add(layer);
          break;
        case 'imagelayer':
          final layer = Layer.fromXml(element);
          layer.type = 'imagelayer';
          layers.add(layer);
          break;
        // case 'group':
        //   element.nodes.forEach((element) {groups.add(GroupJson.fromXML(element));});
        //   break;
        case 'properties':
          element.nodes.whereType<XmlElement>().forEach((element) {properties.add(Property.fromXml(element));});
          break;
        case 'editorsettings':
          element.nodes.whereType<XmlElement>().forEach((element) {editorsettings.add(Editorsetting.fromXml(element));});
          break;
      }
    });
  }


  TiledMap.fromJson(Map<String, dynamic> json) {
    backgroundcolor = json['backgroundcolor'];
    compressionlevel = json['compressionlevel'] ?? -1;
    if (json['editorsettings'] != null) {
      editorsettings = <Editorsetting>[];
      editorsettings.add(Editorsetting.fromJson(json['editorsettings']));
    }
    height = json['height'];
    hexsidelength = json['hexsidelength'];
    infinite = json['infinite'] ?? false;
    if (json['layers'] != null) {
      layers = <Layer>[];
      json['layers'].forEach((v) {
        layers.add(Layer.fromJson(v));
        // Could contain types:
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
      properties = <Property>[];
      json['properties'].forEach((v) {
        properties.add(Property.fromJson(v));
      });
    }
    renderorder = json['renderorder'] ?? "right-down";
    staggeraxis = json['staggeraxis'];
    staggerindex = json['staggerindex'];
    tiledversion = json['tiledversion'];
    tileheight = json['tileheight'];
    if (json['tilesets'] != null) {
      tilesets = <Tileset>[];
      json['tilesets'].forEach((v) {
        tilesets.add(Tileset.fromJson(v));
      });
    }
    tilewidth = json['tilewidth'];
    type = json['type'] ?? "map";
    version = json['version'];
    width = json['width'];
  }
}
