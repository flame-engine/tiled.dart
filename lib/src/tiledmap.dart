part of tiled;


class TiledMap {
  String backgroundColor;
  int compressionLevel;
  List<EditorSetting> editorSettings;
  int height;
  int hexSideLength;
  bool infinite;
  List<Layer> layers = [];
  int nextLayerId;
  int nextObjectId;
  String orientation; // orthogonal, isometric, staggered or hexagonal
  List<Property> properties = [];
  String renderOrder; // right-down (the default), right-up, left-down and left-up.
  String staggerAxis; // x or y
  String staggerIndex; // odd or even
  String tiledVersion;
  int tileHeight;
  List<TileSet> tileSets = [];
  int tileWidth;
  String type;
  num version;
  int width;

  // Convenience Methods
  Tile getTileByGID(int cleanTileID){
    final TileSet tileset = getTilesetByTileID(cleanTileID);
    return tileset.tiles.firstWhere((element) => element.gid == (cleanTileID - tileset.firstGId), orElse: () => null);
  }

  TileSet getTilesetByTileID(int cleanTileID){
    if(tileSets.length == 1){
      return tileSets.first;
    }
    for (var i = 0; i < tileSets.length; ++i) {
      if(tileSets[i].firstGId > cleanTileID){
        return tileSets[i-1];
      }
    }
    return tileSets.last;
  }

  List<TiledImage> getTiledImages(){
    final imageSet = <TiledImage>{};
    for (var i = 0; i < tileSets.length; ++i) {
      if(tileSets[i].image != null) {
        imageSet.add(tileSets[i].image);
      }
      for (var j = 0; j < tileSets[i].tiles.length; ++j) {
        final Tile t = tileSets[i].tiles[j];
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

  TileSet getTilesetByName(String s) {
    return tileSets.firstWhere((element) => element.name == s);
  }

  TiledMap.fromXml(XmlElement xmlElement, {TsxProvider tsx}) {
    backgroundColor = xmlElement.getAttribute('backgroundcolor');
    compressionLevel = int.tryParse(xmlElement.getAttribute('compressionlevel') ?? "-1"); //defaults to -1
    height = int.tryParse(xmlElement.getAttribute('height') ?? '');
    hexSideLength = int.tryParse(xmlElement.getAttribute('hexsidelength') ?? '');
    infinite = int.tryParse(xmlElement.getAttribute('infinite') ?? "0") != 0;  // 0 for false, 1 for true, defaults to 0)
    nextLayerId = int.tryParse(xmlElement.getAttribute('nextlayerid') ?? '');
    nextObjectId = int.tryParse(xmlElement.getAttribute('nextobjectid') ?? '');
    orientation = xmlElement.getAttribute('orientation');
    renderOrder = xmlElement.getAttribute('renderorder') ?? "right-down"; // right-down (the default), right-up, left-down and left-up.
    staggerAxis = xmlElement.getAttribute('staggeraxis');
    staggerIndex = xmlElement.getAttribute('staggerindex');
    tiledVersion = xmlElement.getAttribute('tiledversion');
    tileHeight = int.tryParse(xmlElement.getAttribute('tileheight') ?? '');
    tileWidth = int.tryParse(xmlElement.getAttribute('tilewidth') ?? '');
    type = "map"; // only set in jsonImport
    version = int.tryParse(xmlElement.getAttribute('version') ?? '');
    width = int.tryParse(xmlElement.getAttribute('width') ?? '');

    xmlElement.children.whereType<XmlElement>().forEach((XmlElement element) {
      switch (element.name.local) {
        case 'tileset':
          tileSets.add(TileSet.fromXml(element, tsx: tsx));
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
        case 'group':
          final layer = Layer.fromXml(element);
          layer.type = 'group';
          layers.add(layer);
          break;
        case 'properties':
          element.nodes.whereType<XmlElement>().forEach((element) {properties.add(Property.fromXml(element));});
          break;
        case 'editorsettings':
          element.nodes.whereType<XmlElement>().forEach((element) {editorSettings.add(EditorSetting.fromXml(element));});
          break;
      }
    });
  }


  TiledMap.fromJson(Map<String, dynamic> json) {
    backgroundColor = json['backgroundcolor'];
    compressionLevel = json['compressionlevel'] ?? -1;
    if (json['editorsettings'] != null) {
      editorSettings = <EditorSetting>[];
      editorSettings.add(EditorSetting.fromJson(json['editorsettings']));
    }
    height = json['height'];
    hexSideLength = json['hexsidelength'];
    infinite = json['infinite'] ?? false;
    layers = (json['layers'] as List)?.map((e) => Layer.fromJson(e))?.toList() ?? [];
        // Could contain types:
        // - layers
        // - objectGroups
        // - imageLayers
        // - groups
    nextLayerId = json['nextlayerid'];
    nextObjectId = json['nextobjectid'];
    orientation = json['orientation'];
    properties = (json['properties'] as List)?.map((e) => Property.fromJson(e))?.toList() ?? [];
    renderOrder = json['renderorder'] ?? "right-down";
    staggerAxis = json['staggeraxis'];
    staggerIndex = json['staggerindex'];
    tiledVersion = json['tiledversion'];
    tileHeight = json['tileheight'];
    tileSets = (json['tilesets'] as List)?.map((e) => TileSet.fromJson(e))?.toList() ?? [];
    tileWidth = json['tilewidth'];
    type = json['type'] ?? "map";
    version = json['version'];
    width = json['width'];
  }
}
