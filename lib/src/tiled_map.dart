part of tiled;

/// Below is Tiled's documentation about how this structure is represented
/// on XML files:
///
/// <map>
///
/// * version: The TMX format version. Was “1.0” so far, and will be incremented
///   to match minor Tiled releases.
/// * tiledversion: The Tiled version used to save the file (since Tiled 1.0.1).
///   May be a date (for snapshot builds). (optional)
/// * orientation: Map orientation. Tiled supports “orthogonal”, “isometric”,
///   “staggered” and “hexagonal” (since 0.11).
/// * renderorder: The order in which tiles on tile layers are rendered.
///   Valid values are right-down (the default), right-up, left-down and
///   left-up. In all cases, the map is drawn row-by-row. (only supported for
///   orthogonal maps at the moment)
/// * compressionlevel: The compression level to use for tile layer data
///   (defaults to -1, which means to use the algorithm default).
/// * width: The map width in tiles.
/// * height: The map height in tiles.
/// * tilewidth: The width of a tile.
/// * tileheight: The height of a tile.
/// * hexsidelength: Only for hexagonal maps. Determines the width or height
///   (depending on the staggered axis) of the tile’s edge, in pixels.
/// * staggeraxis: For staggered and hexagonal maps, determines which axis
///   (“x” or “y”) is staggered. (since 0.11)
/// * staggerindex: For staggered and hexagonal maps, determines whether the
///   “even” or “odd” indexes along the staggered axis are shifted. (since 0.11)
/// * backgroundcolor: The background color of the map. (optional, may include
///   alpha value since 0.15 in the form #AARRGGBB. Defaults to fully transparent.)
/// * nextlayerid: Stores the next available ID for new layers. This number is
///   stored to prevent reuse of the same ID after layers have been removed.
///   (since 1.2) (defaults to the highest layer id in the file + 1)
/// * nextobjectid: Stores the next available ID for new objects. This number is
///   stored to prevent reuse of the same ID after objects have been removed.
///   (since 0.11) (defaults to the highest object id in the file + 1)
/// * infinite: Whether this map is infinite. An infinite map has no fixed size
///   and can grow in all directions. Its layer data is stored in chunks.
///   (0 for false, 1 for true, defaults to 0)
///
/// The tilewidth and tileheight properties determine the general grid size of
/// the map. The individual tiles may have different sizes. Larger tiles will
/// extend at the top and right (anchored to the bottom left).
///
/// A map contains three different kinds of layers. Tile layers were once the
/// only type, and are simply called layer, object layers have the objectgroup
/// tag and image layers use the imagelayer tag. The order in which these layers
/// appear is the order in which the layers are rendered by Tiled.
///
/// The staggered orientation refers to an isometric map using staggered axes.
///
/// Can contain at most one: <properties>
///
/// Can contain any number: <tileset>, <layer>, <objectgroup>, <imagelayer>,
/// <group> (since 1.0), <editorsettings> (since 1.3)
class TiledMap {
  TileMapType type;
  String version;
  String? tiledVersion;

  int width;
  int height;
  bool infinite;

  int tileWidth;
  int tileHeight;

  List<Tileset> tilesets;
  List<Layer> layers;

  String? backgroundColor;
  int compressionLevel;

  int? nextLayerId;
  int? nextObjectId;
  MapOrientation? orientation;
  RenderOrder renderOrder;

  List<EditorSetting> editorSettings;
  List<Property> properties;

  // only for hexagonal maps:
  int? hexSideLength;
  StaggerAxis? staggerAxis;
  StaggerIndex? staggerIndex;

  TiledMap({
    this.type = TileMapType.map,
    this.version = '1.0',
    this.tiledVersion,
    required this.width,
    required this.height,
    this.infinite = false,
    required this.tileWidth,
    required this.tileHeight,
    this.tilesets = const [],
    this.layers = const [],
    this.backgroundColor,
    this.compressionLevel = -1,
    this.hexSideLength,
    this.nextLayerId,
    this.nextObjectId,
    this.orientation,
    this.renderOrder = RenderOrder.rightDown,
    this.staggerAxis,
    this.staggerIndex,
    this.editorSettings = const [],
    this.properties = const [],
  });

  // Convenience Methods
  Tile tileByGid(int tileGid) {
    if (tileGid == 0) {
      return Tile(localId: 0);
    }
    final tileset = tilesetByTileGId(tileGid);
    return tileset.tiles.firstWhere(
      (element) => element.localId == (tileGid - tileset.firstGid!),
      orElse: null,
    );
  }

  Tile tileByLocalId(String tileSetName, int localId) {
    final tileset = tilesetByName(tileSetName);
    return tileset.tiles.firstWhere(
      (element) => element.localId == localId,
      orElse: null,
    );
  }

  Tile tileByPhrase(String tilePhrase) {
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

    return tileByLocalId(tilesetName, tileId);
  }

  Tileset tilesetByTileGId(int tileGId) {
    if (tilesets.length == 1) {
      return tilesets.first;
    }
    for (var i = 0; i < tilesets.length; ++i) {
      if (tilesets[i].firstGid! > tileGId) {
        if (i == 0) {
          throw ArgumentError('Tileset not found');
        }
        return tilesets[i - 1];
      }
    }
    return tilesets.last;
  }

  List<TiledImage> tiledImages() {
    final imageSet = <TiledImage>{};
    for (var i = 0; i < tilesets.length; ++i) {
      final image = tilesets[i].image;
      if (image != null) {
        imageSet.add(image);
      }
      for (var j = 0; j < tilesets[i].tiles.length; ++j) {
        final image = tilesets[i].tiles[j].image;
        if (image != null) {
          imageSet.add(image);
        }
      }
    }
    imageSet.addAll(layers.whereType<ImageLayer>().map((e) => e.image));
    return imageSet.toList();
  }

  Layer layerByName(String name) {
    return layers.firstWhere(
      (element) => element.name == name,
      orElse: () => throw ArgumentError('Layer $name not found'),
    );
  }

  Tileset tilesetByName(String name) {
    return tilesets.firstWhere(
      (element) => element.name == name,
      orElse: () => throw ArgumentError('Tileset $name not found'),
    );
  }

  static TiledMap parse(Parser parser, {TsxProvider? tsx}) {
    final backgroundColor = parser.getStringOrNull('backgroundcolor');
    final compressionLevel = parser.getInt('compressionlevel', defaults: -1);
    final height = parser.getInt('height');
    final hexSideLength = parser.getIntOrNull('hexsidelength');
    final infinite = parser.getBool('infinite', defaults: false);
    final nextLayerId = parser.getIntOrNull('nextlayerid');
    final nextObjectId = parser.getIntOrNull('nextobjectid');
    final orientation = parser.getMapOrientationOrNull('orientation');
    final renderOrder = parser.getRenderOrder(
      'renderorder',
      defaults: RenderOrder.rightDown,
    );
    final staggerAxis = parser.getStaggerAxisOrNull('staggeraxis');
    final staggerIndex = parser.getStaggerIndexOrNull('staggerindex');
    final tiledVersion = parser.getStringOrNull('tiledversion');
    final tileHeight = parser.getInt('tileheight');
    final tileWidth = parser.getInt('tilewidth');
    final type = parser.getTileMapType('type', defaults: TileMapType.map);
    final version = parser.getString('version', defaults: '1.0');
    final width = parser.getInt('width');

    final tilesets = parser.getChildrenAs(
      'tileset',
      (e) => Tileset.parse(e, tsx: tsx),
    );
    final layers = Layer.parseLayers(parser);
    final properties = parser.getProperties();
    final editorSettings = parser.getChildrenAs(
      'editorsettings',
      EditorSetting.parse,
    );

    return TiledMap(
      type: type,
      version: version,
      tiledVersion: tiledVersion,
      width: width,
      height: height,
      infinite: infinite,
      tileWidth: tileWidth,
      tileHeight: tileHeight,
      tilesets: tilesets,
      layers: layers,
      backgroundColor: backgroundColor,
      compressionLevel: compressionLevel,
      hexSideLength: hexSideLength,
      nextLayerId: nextLayerId,
      nextObjectId: nextObjectId,
      orientation: orientation,
      renderOrder: renderOrder,
      staggerAxis: staggerAxis,
      staggerIndex: staggerIndex,
      editorSettings: editorSettings,
      properties: properties,
    );
  }
}
