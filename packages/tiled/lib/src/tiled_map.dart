import 'dart:collection';
import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:tiled/tiled.dart';
import 'package:xml/xml.dart';

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
///   alpha value since 0.15 in the form #AARRGGBB.)
///   Defaults to fully transparent.
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

  /// Hex-formatted color (#RRGGBB or #AARRGGBB) to be rendered as a solid color
  /// behind all other layers (optional).
  String? backgroundColorHex;

  /// [ColorData] to be rendered as a solid color behind all other layers
  /// (optional).
  ///
  /// Parsed from [backgroundColorHex], will be null if parsing fails for any
  /// reason.
  ColorData? backgroundColor;

  int compressionLevel;

  int? nextLayerId;
  int? nextObjectId;
  MapOrientation? orientation;
  RenderOrder renderOrder;

  List<EditorSetting> editorSettings;
  CustomProperties properties;

  // Cache the object by ID when accessed.
  Map<int, TiledObject>? _cachedObjects;

  // only for hexagonal maps:
  int? hexSideLength;
  StaggerAxis? staggerAxis;
  StaggerIndex? staggerIndex;

  TiledMap({
    required this.width,
    required this.height,
    required this.tileWidth,
    required this.tileHeight,
    this.type = TileMapType.map,
    this.version = '1.0',
    this.tiledVersion,
    this.infinite = false,
    this.tilesets = const [],
    this.layers = const [],
    this.backgroundColorHex,
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
    this.properties = CustomProperties.empty,
  });

  // Convenience Methods
  Tile? tileByGid(int tileGid) {
    if (tileGid == 0) {
      return Tile(localId: -1);
    }
    final tileset = tilesetByTileGId(tileGid);
    final firstGid = tileset.firstGid ?? 0;
    return tileset.tiles.firstWhereOrNull(
      (element) => element.localId == (tileGid - firstGid),
    );
  }

  Tile? tileByLocalId(String tileSetName, int localId) {
    final tileset = tilesetByName(tileSetName);
    return tileset.tiles.firstWhereOrNull(
      (element) => element.localId == localId,
    );
  }

  Tile? tileByPhrase(String tilePhrase) {
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
      final tileset = tilesets[i];
      final firstGid = tileset.firstGid ?? 0;
      if (firstGid > tileGId) {
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
      if (image?.source != null) {
        imageSet.add(image!);
      }
      for (var j = 0; j < tilesets[i].tiles.length; ++j) {
        final image = tilesets[i].tiles[j].image;
        if (image?.source != null) {
          imageSet.add(image!);
        }
      }
    }
    imageSet.addAll(
      layers
          .whereType<ImageLayer>()
          .map((e) => e.image)
          .where((e) => e.source != null),
    );
    return imageSet.toList();
  }

  List<TiledImage> collectImagesInLayer(Layer layer) {
    if (layer is ImageLayer) {
      return [layer.image];
    } else if (layer is Group) {
      return layer.layers.expand(collectImagesInLayer).toList();
    } else if (layer is TileLayer) {
      const emptyTile = 0;
      final rows = layer.tileData ?? <List<Gid>>[];
      final gids = rows
          .expand((row) => row.map((gid) => gid.tile))
          .where((gid) => gid != emptyTile)
          .toSet();

      return gids
          .map(tilesetByTileGId)
          .toSet() // The different gid can be in the same tileset
          .expand(
            (tileset) =>
                [tileset.image, ...tileset.tiles.map((tile) => tile.image)],
          )
          // ignore: deprecated_member_use
          .whereNotNull()
          .toList();
    }

    return [];
  }

  /// Finds the first layer with the matching [name], or throw an
  /// [ArgumentError] if one cannot be found.
  /// Will search recursively through [Group] children.
  Layer layerByName(String name) {
    final toSearch = Queue<List<Layer>>();
    toSearch.add(layers);

    Layer? found;
    while (found == null && toSearch.isNotEmpty) {
      final currentLayers = toSearch.removeFirst();
      currentLayers.forEach((layer) {
        if (layer.name == name) {
          found = layer;
          return;
        } else if (layer is Group) {
          toSearch.add(layer.layers);
        }
      });
    }

    if (found != null) {
      return found!;
    }

    // Couldn't find it in any layer
    throw ArgumentError('Layer $name not found');
  }

  /// Finds the [TiledObject] in this map with the unique [id].
  /// Objects have map wide unique IDs which are never reused.
  /// https://doc.mapeditor.org/en/stable/reference/tmx-map-format/#object
  ///
  /// This reads through a cached map of all the objects so it does not
  /// need to loop through all the object layers each time.
  ///
  /// Returns null if not found.
  TiledObject? objectById(int id) {
    if (_cachedObjects == null) {
      _cachedObjects = {};
      layers.whereType<ObjectGroup>().forEach((objectGroup) {
        for (final object in objectGroup.objects) {
          _cachedObjects![object.id] = object;
        }
      });
    }

    return _cachedObjects?[id];
  }

  Tileset tilesetByName(String name) {
    return tilesets.firstWhere(
      (element) => element.name == name,
      orElse: () => throw ArgumentError('Tileset $name not found'),
    );
  }

  /// Parses the provided json.
  ///
  /// Accepts an optional list of external TsxProviders for external tilesets
  /// referenced in the map file.
  factory TiledMap.parseJson(
    String json, {
    List<ParserProvider>? tsxProviders,
    List<ParserProvider>? templateProviders,
  }) {
    final parser = JsonParser(
      jsonDecode(json) as Map<String, dynamic>,
      templateProviders: templateProviders,
      tsxProviders: tsxProviders,
    );
    return TiledMap.parse(parser);
  }

  /// Parses the provided map xml.
  ///
  /// Accepts an optional list of external TsxProviders for external tilesets
  /// referenced in the map file.
  factory TiledMap.parseTmx(
    String xml, {
    List<ParserProvider>? tsxProviders,
    List<ParserProvider>? templateProviders,
  }) {
    final xmlElement = XmlDocument.parse(xml).rootElement;
    if (xmlElement.name.local != 'map') {
      throw 'XML is not in TMX format';
    }
    final parser = XmlParser(
      xmlElement,
      tsxProviders: tsxProviders,
      templateProviders: templateProviders,
    );
    return TiledMap.parse(parser);
  }

  factory TiledMap.parse(Parser parser) {
    final backgroundColorHex = parser.getStringOrNull('backgroundcolor');
    final backgroundColor = parser.getColorOrNull('backgroundcolor');
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
      (tilesetData) {
        final tilesetSource = tilesetData.getStringOrNull('source');
        if (tilesetSource == null || parser.tsxProviders == null) {
          return Tileset.parse(tilesetData);
        }

        final matchingTsx = parser.tsxProviders!.where(
          (tsx) => tsx.canProvide(tilesetSource),
        );

        return Tileset.parse(
          tilesetData,
          tsx: matchingTsx.isNotEmpty ? matchingTsx.first : null,
        );
      },
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
      backgroundColorHex: backgroundColorHex,
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
