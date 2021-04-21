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
  MapOrientation orientation;
  List<Property> properties = [];
  RenderOrder renderOrder;
  StaggerAxis staggerAxis;
  StaggerIndex staggerIndex;
  String tiledVersion;
  int tileHeight;
  List<TileSet> tileSets = [];
  int tileWidth;
  String type;
  num version;
  int width;

  TiledMap();

  // Convenience Methods
  Tile getTileByGId(int tileGId) {
    if (tileGId == 0) {
      return Tile(0);
    }
    final TileSet tileset = getTilesetByTileGId(tileGId);
    return tileset.tiles.firstWhere(
        (element) => element.localId == (tileGId - tileset.firstGId),
        orElse: null);
  }

  Tile getTileByLocalID(String tileSetName, int localId) {
    final TileSet tileset = getTilesetByName(tileSetName);
    return tileset.tiles
        .firstWhere((element) => element.localId == localId, orElse: null);
  }

  Tile getTileByPhrase(String tilePhrase) {
    final split = tilePhrase.split('|');
    if (split.length != 2) {
      throw ArgumentError(
        '$tilePhrase not in the format of "TilesetName|LocalTileID"',
      );
    }

    final tilesetName = split.first;
    final tileId = int.tryParse(split.last);
    if (tileId == null) {
      throw ArgumentError('Local tile ID ${split.last} is not an integer.');
    }

    return getTileByLocalID(tilesetName, tileId);
  }

  TileSet getTilesetByTileGId(int tileGId) {
    if (tileSets.length == 1) {
      return tileSets.first;
    }
    for (var i = 0; i < tileSets.length; ++i) {
      if (tileSets[i].firstGId > tileGId) {
        if (i == 0) {
          throw ArgumentError('Tileset not found');
        }
        return tileSets[i - 1];
      }
    }
    return tileSets.last;
  }

  List<TiledImage> getTiledImages() {
    final imageSet = <TiledImage>{};
    for (var i = 0; i < tileSets.length; ++i) {
      if (tileSets[i].image != null) {
        imageSet.add(tileSets[i].image);
      }
      for (var j = 0; j < tileSets[i].tiles.length; ++j) {
        final Tile t = tileSets[i].tiles[j];
        if (t.image != null) {
          imageSet.add(t.image);
        }
      }
    }
    for (var i = 0; i < layers.length; ++i) {
      if (layers[i].image != null) {
        imageSet.add(layers[i].image);
      }
    }
    return imageSet.toList();
  }

  Layer getLayerByName(String name) {
    return layers.firstWhere((element) => element.name == name,
        orElse: () => throw ArgumentError('Layer $name not found'));
  }

  TileSet getTilesetByName(String name) {
    return tileSets.firstWhere((element) => element.name == name,
        orElse: () => throw ArgumentError('Tileset $name not found'));
  }

  TiledMap.fromXml(XmlElement xmlElement, {TsxProvider tsx}) {
    backgroundColor = xmlElement.getAttribute('backgroundcolor');
    compressionLevel = int.tryParse(
        xmlElement.getAttribute('compressionlevel') ?? "-1"); //defaults to -1
    height = int.tryParse(xmlElement.getAttribute('height') ?? '');
    hexSideLength =
        int.tryParse(xmlElement.getAttribute('hexsidelength') ?? '');
    infinite = int.tryParse(xmlElement.getAttribute('infinite') ?? "0") !=
        0; // 0 for false, 1 for true, defaults to 0)
    nextLayerId = int.tryParse(xmlElement.getAttribute('nextlayerid') ?? '');
    nextObjectId = int.tryParse(xmlElement.getAttribute('nextobjectid') ?? '');
    orientation = MapOrientation.values.firstWhere(
        (e) => e.name == xmlElement.getAttribute('orientation'),
        orElse: () => null);
    renderOrder = RenderOrder.values.firstWhere(
        (e) => e.name == xmlElement.getAttribute('renderorder'),
        orElse: () => RenderOrder.right_down);
    staggerAxis = StaggerAxis.values.firstWhere(
        (e) => e.name == xmlElement.getAttribute('staggeraxis') ?? "",
        orElse: () => null);
    staggerIndex = StaggerIndex.values.firstWhere(
        (e) => e.name == xmlElement.getAttribute('staggerindex') ?? "",
        orElse: () => null);
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
        case 'properties':
          element.nodes.whereType<XmlElement>().forEach((element) {
            properties.add(Property.fromXml(element));
          });
          break;
        case 'editorsettings':
          element.nodes.whereType<XmlElement>().forEach((element) {
            editorSettings.add(EditorSetting.fromXml(element));
          });
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
    layers =
        (json['layers'] as List)?.map((e) => Layer.fromJson(e))?.toList() ?? [];
    // Could contain types:
    // - layers
    // - objectGroups
    // - imageLayers
    // - groups
    nextLayerId = json['nextlayerid'];
    nextObjectId = json['nextobjectid'];
    properties = (json['properties'] as List)
            ?.map((e) => Property.fromJson(e))
            ?.toList() ??
        [];

    orientation = MapOrientation.values
        .firstWhere((e) => e.name == json['orientation'], orElse: () => null);
    renderOrder = RenderOrder.values.firstWhere(
        (e) => e.name == json['renderorder'].replaceAll("-", "_"),
        orElse: () => RenderOrder.right_down);
    staggerAxis = StaggerAxis.values
        .firstWhere((e) => e.name == json['staggeraxis'], orElse: () => null);
    staggerIndex = StaggerIndex.values
        .firstWhere((e) => e.name == json['staggerindex'], orElse: () => null);
    tiledVersion = json['tiledversion'];
    tileHeight = json['tileheight'];
    tileSets =
        (json['tilesets'] as List)?.map((e) => TileSet.fromJson(e))?.toList() ??
            [];
    tileWidth = json['tilewidth'];
    type = json['type'] ?? "map";
    version = json['version'];
    width = json['width'];
  }
}
