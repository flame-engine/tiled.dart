part of tiled;

/// Below is Tiled's documentation about how this structure is represented
/// on XML files:
///
/// <tileset>
///
/// * firstgid: The first global tile ID of this tileset (this global ID maps
///   to the first tile in this tileset).
/// * source: If this tileset is stored in an external TSX (Tile Set XML) file,
///   this attribute refers to that file. That TSX file has the same structure
///   as the <tileset> element described here. (There is the firstgid attribute
///   missing and this source attribute is also not there. These two attributes
///   are kept in the TMX map, since they are map specific.)
/// * name: The name of this tileset.
/// * tilewidth: The (maximum) width of the tiles in this tileset.
/// * tileheight: The (maximum) height of the tiles in this tileset.
/// * spacing: The spacing in pixels between the tiles in this tileset (applies
///   to the tileset image, defaults to 0)
/// * margin: The margin around the tiles in this tileset (applies to the
///   tileset image, defaults to 0)
/// * tilecount: The number of tiles in this tileset (since 0.13)
/// * columns: The number of tile columns in the tileset. For image collection
///   tilesets it is editable and is used when displaying the tileset.
///   (since 0.15)
/// * objectalignment: Controls the alignment for tile objects. Valid values are
///   unspecified, topleft, top, topright, left, center, right, bottomleft,
///   bottom and bottomright. The default value is unspecified, for
///   compatibility reasons. When unspecified, tile objects use bottomleft in
///   orthogonal mode and bottom in isometric mode. (since 1.4)
///
/// If there are multiple <tileset> elements, they are in ascending order of
/// their firstgid attribute. The first tileset always has a firstgid value of
/// 1. Since Tiled 0.15, image collection tilesets do not necessarily number
/// their tiles consecutively since gaps can occur when removing tiles.
///
/// Image collection tilesets have no <image> tag. Instead, each tile has an
/// <image> tag.
///
/// Can contain at most one: <image>, <tileoffset>, <grid> (since 1.0),
/// <properties>, <terraintypes>, <wangsets> (since 1.1), <transformations>
/// (since 1.5)
///
/// Can contain any number: <tile>
class Tileset with Exportable {
  int? firstGid;
  String? source;
  String? name;
  int? tileWidth;
  int? tileHeight;
  int spacing = 0;
  int margin = 0;

  int? tileCount;
  int? columns;
  ObjectAlignment objectAlignment;

  List<Tile> tiles = [];

  TiledImage? image;
  TileOffset? tileOffset;
  Grid? grid;
  CustomProperties properties;
  List<Terrain> terrains = [];
  List<WangSet> wangSets = [];

  String version = '1.0';
  String? tiledVersion;
  String? backgroundColor;
  String? transparentColor;
  TilesetType type = TilesetType.tileset;

  Tileset({
    this.firstGid,
    this.source,
    this.name,
    this.tileWidth,
    this.tileHeight,
    this.spacing = 0,
    this.margin = 0,
    this.tileCount,
    this.columns,
    this.objectAlignment = ObjectAlignment.unspecified,
    List<Tile> tiles = const [],
    this.image,
    this.tileOffset,
    this.grid,
    this.properties = CustomProperties.empty,
    this.terrains = const [],
    this.wangSets = const [],
    this.version = '1.0',
    this.tiledVersion,
    this.backgroundColor,
    this.transparentColor,
    this.type = TilesetType.tileset,
  }) : tiles = _generateTiles(
          tiles,
          tileCount ?? 0,
          columns,
          tileWidth,
          tileHeight,
        ) {
    tileCount = this.tiles.length;
  }

  factory Tileset.parse(Parser parser, {TsxProvider? tsx}) {
    final backgroundColor = parser.getStringOrNull('backgroundcolor');
    final columns = parser.getIntOrNull('columns');
    final firstGid = parser.getIntOrNull('firstgid');
    final margin = parser.getInt('margin', defaults: 0);
    final name = parser.getStringOrNull('name');
    final objectAlignment = ObjectAlignment.values.byName(
      parser.getString('objectalignment', defaults: 'unspecified'),
    );
    final source = parser.getStringOrNull('source');
    final spacing = parser.getInt('spacing', defaults: 0);
    final tileCount = parser.getIntOrNull('tilecount');
    final tileWidth = parser.getIntOrNull('tilewidth');
    final tileHeight = parser.getIntOrNull('tileheight');
    final tiledVersion = parser.getStringOrNull('tiledversion');
    final transparentColor = parser.getStringOrNull('transparentcolor');
    final type = parser.getTilesetType('type', defaults: TilesetType.tileset);
    final version = parser.getString('version', defaults: '1.0');

    final image = parser.getSingleChildOrNullAs('image', TiledImage.parse);
    final grid = parser.getSingleChildOrNullAs('grid', Grid.parse);
    final tileOffset =
        parser.getSingleChildOrNullAs('tileoffset', TileOffset.parse);
    final properties = parser.getProperties();
    final terrains = parser.getChildrenAs('terrains', Terrain.parse);
    final tiles = parser.formatSpecificParsing(
      (json) => json.getChildrenAs('tiles', Tile.parse),
      (xml) => xml.getChildrenAs('tile', Tile.parse),
    );
    final wangSets = parser.formatSpecificParsing(
      (json) => json.getChildrenAs('wangsets', WangSet.parse),
      (xml) =>
          xml
              .getSingleChildOrNull('wangsets')
              ?.getChildrenAs('wangset', WangSet.parse) ??
          [],
    );

    final result = Tileset(
      firstGid: firstGid,
      source: source,
      name: name,
      tileWidth: tileWidth,
      tileHeight: tileHeight,
      spacing: spacing,
      margin: margin,
      tileCount: tileCount,
      columns: columns,
      objectAlignment: objectAlignment,
      tiles: tiles,
      image: image,
      tileOffset: tileOffset,
      grid: grid,
      properties: properties,
      terrains: terrains,
      wangSets: wangSets,
      version: version,
      tiledVersion: tiledVersion,
      backgroundColor: backgroundColor,
      transparentColor: transparentColor,
      type: type,
    );
    result._checkIfExternalTsx(source, tsx);
    return result;
  }

  void _checkIfExternalTsx(String? source, TsxProvider? tsx) {
    if (tsx != null && source != null) {
      final tileset = Tileset.parse(
        tsx.getCachedSource() ?? tsx.getSource(source),
      );
      // Copy attributes if not null
      backgroundColor = tileset.backgroundColor ?? backgroundColor;
      columns = tileset.columns ?? columns;
      firstGid = tileset.firstGid ?? firstGid;
      grid = tileset.grid ?? grid;
      image = tileset.image ?? image;
      name = tileset.name ?? name;
      objectAlignment = tileset.objectAlignment;
      spacing = tileset.spacing;
      margin = tileset.margin;
      tileCount = tileset.tileCount ?? tileCount;
      tiledVersion = tileset.tiledVersion ?? tiledVersion;
      tileOffset = tileset.tileOffset ?? tileOffset;
      tileHeight = tileset.tileHeight ?? tileHeight;
      tileWidth = tileset.tileWidth ?? tileWidth;
      transparentColor = tileset.transparentColor ?? transparentColor;
      // Add List-Attributes
      properties.byName.addAll(tileset.properties.byName);
      terrains.addAll(tileset.terrains);
      tiles.addAll(tileset.tiles);
      wangSets.addAll(tileset.wangSets);
    }
  }

  Rectangle computeDrawRect(Tile tile) {
    final image = tile.image;
    if (image != null) {
      return Rectangle(
        0,
        0,
        image.width!.toDouble(),
        image.height!.toDouble(),
      );
    }
    final row = tile.localId ~/ columns!;
    final column = tile.localId % columns!;
    final x = margin + (column * (tileWidth! + spacing));
    final y = margin + (row * (tileHeight! + spacing));
    return Rectangle(
      x.toDouble(),
      y.toDouble(),
      tileWidth!.toDouble(),
      tileHeight!.toDouble(),
    );
  }

  static List<Tile> _generateTiles(
    List<Tile> explicitTiles,
    int tileCount,
    int? columns,
    int? tileWidth,
    int? tileHeight,
  ) {
    final tiles = <Tile>[];

    for (var i = 0; i < tileCount; ++i) {
      Rectangle? imageRect;

      if (columns != null &&
          columns != 0 &&
          tileWidth != null &&
          tileHeight != null) {
        final x = (i % columns) * tileWidth;
        final y = i ~/ columns * tileHeight;

        imageRect = Rectangle(
          x.toDouble(),
          y.toDouble(),
          tileWidth.toDouble(),
          tileHeight.toDouble(),
        );
      }

      tiles.add(
        Tile(localId: i, imageRect: imageRect),
      );
    }

    for (final tile in explicitTiles) {
      if (tile.localId >= tiles.length) {
        tiles.add(tile);
      } else {
        final generated = tiles[tile.localId];
        if (tile.imageRect == null) tile.imageRect = generated.imageRect;
        tiles[tile.localId] = tile;
      }
    }
    return tiles;
  }

  @override
  ExportResolver export() => source == null
      ? _export(false)
      : ExportElement(
          'tileset',
          {
            'firstgid': firstGid!.toExport(),
            'source': source!.toExport(),
          }.nonNulls(),
          {},
        );

  ExportResolver exportExternal() => _export(true);

  ExportResolver _export(bool external) {
    final fields = {
      if (!external) 'firstgid': firstGid!.toExport(),
      'name': name!.toExport(),
      'class': type.name.toExport(),
      'type': type.name.toExport(),

      'tilewidth': tileWidth?.toExport(),
      'tileheight': tileHeight?.toExport(),
      'spacing': spacing.toExport(),
      'margin': margin.toExport(),

      'tilecount': tileCount?.toExport(),
      'columns': columns?.toExport(),
      'objectalignment': objectAlignment.name.toExport(),
      // 'tilerendersize': , Not supported by this class
      // 'fillmode': , Not supported by this class
    }.nonNulls();

    final common = {
      'image': image?.export(),
      'tiles': ExportList.from(tiles),
      'tileoffset': tileOffset?.export(),
      'grid': grid?.export(),
      // 'terraintypes': , DEPRECATED
      // 'transformations': ExportList.from(transformations), Not supported by this class
    }.nonNulls();

    final wangsets = ExportElement(
      'wangsets',
      {},
      {'wangsets': ExportList.from(wangSets)},
      properties,
    );

    return ExportFormatSpecific(
      xml: ExportElement(
        'tileset',
        fields,
        {
          ...common,
          if (wangSets.isNotEmpty) 'wangsets': wangsets,
        },
        properties,
      ),
      json: ExportElement(
        'tileset',
        fields,
        {
          ...common,
          'wangsets': ExportList.from(wangSets),
        },
      ),
    );
  }
}
