part of tiled;

class TileSet {
  String backgroundColor;
  int columns;
  int firstGId;
  Grid grid;
  TiledImage image;
  int margin;
  String name;
  String objectAlignment;
  List<Property> properties = [];
  String source;
  int spacing;
  List<Terrain> terrains = [];
  int tileCount;
  String tiledVersion;
  TileOffset tileOffset;
  List<Tile> tiles = [];
  int tileHeight;
  int tileWidth;
  String transparentColor;
  String type;
  num version;
  List<WangSet> wangSets = [];

  TileSet(this.name, this.firstGId, this.columns, this.tileCount, List<Tile> tilelist){
    if(tileCount == null && tilelist.isNotEmpty){
      tileCount = tilelist.last.localId;
    }
    final iterator = tilelist.iterator;
    Tile t = iterator.moveNext() ? iterator.current : Tile(-1);
    for (var i = 0; i <= tileCount; ++i) {
      if(t.localId == i){
        tiles.add(t);
        if(iterator.moveNext()) {
          t = iterator.current;
        }
      }else{
        tiles.add(Tile(i));
      }
    }
  }

  TileSet.fromXml(XmlNode xmlElement, {TsxProvider tsx}) {
    backgroundColor = xmlElement.getAttribute('backgroundcolor');
    columns = int.tryParse(xmlElement.getAttribute('columns') ?? '');
    firstGId = int.tryParse(xmlElement.getAttribute('firstgid') ?? '');
    margin = int.tryParse(xmlElement.getAttribute('margin') ?? '0');
    name = xmlElement.getAttribute('name');
    objectAlignment = xmlElement.getAttribute('objectalignment');
    source = xmlElement.getAttribute('source');
    spacing = int.tryParse(xmlElement.getAttribute('spacing') ?? '0');
    tileCount = int.tryParse(xmlElement.getAttribute('tilecount') ?? '');
    tileHeight = int.tryParse(xmlElement.getAttribute('tileheight') ?? '');
    tiledVersion = xmlElement.getAttribute('tiledversion');
    tileWidth = int.tryParse(xmlElement.getAttribute('tilewidth') ?? '');
    transparentColor = xmlElement.getAttribute('transparentcolor');
    type = xmlElement.getAttribute('type');
    version = int.tryParse(xmlElement.getAttribute('version') ?? '');

    final tilelist = <Tile>[];

    xmlElement.children.whereType<XmlElement>().forEach((XmlElement element) {
      switch (element.name.local) {
        case 'image':
          image = TiledImage.fromXml(element);
          break;
        case 'grid':
          grid = Grid.fromXml(element);
          break;
        case 'tileoffset':
          tileOffset = TileOffset.fromXml(element);
          break;
        case 'properties':
          element.nodes.whereType<XmlElement>().forEach((element) {
            properties.add(Property.fromXml(element));
          });
          break;
        case 'terrains':
          element.nodes.whereType<XmlElement>().forEach((element) {
            terrains.add(Terrain.fromXml(element));
          });
          break;
        case 'tile':
            tilelist.add(Tile.fromXml(element));
          break;
        case 'wangsets':
          element.nodes.whereType<XmlElement>().forEach((element) {
            wangSets.add(WangSet.fromXml(element));
          });
          break;
      }
    });

    _checkIfExtenalTsx(source, tsx);

    if(tileCount == null && tilelist.isNotEmpty){
      tileCount = tilelist.last.localId;
    }
    final iterator = tilelist.iterator;
    Tile t = iterator.moveNext() ? iterator.current : Tile(-1);
    for (var i = 0; i <= tileCount; ++i) {
      if(t.localId == i){
        tiles.add(t);
        if(iterator.moveNext()) {
          t = iterator.current;
        }
      }else{
        tiles.add(Tile(i));
      }
    }
  }

  void _checkIfExtenalTsx(String source, TsxProvider tsx) {
    if (tsx != null && source != null) {
      final TileSet tileset = TileSet.fromXml(tsx.getSource(source));
      //Copy attributes if not null
      backgroundColor = tileset.backgroundColor ?? backgroundColor;
      columns = tileset.columns ?? columns;
      firstGId = tileset.firstGId ?? firstGId;
      grid = tileset.grid ?? grid;
      image = tileset.image ?? image;
      margin = tileset.margin ?? margin;
      name = tileset.name ?? name;
      objectAlignment = tileset.objectAlignment ?? objectAlignment;
      spacing = tileset.spacing ?? spacing;
      tileCount = tileset.tileCount ?? tileCount;
      tiledVersion = tileset.tiledVersion ?? tiledVersion;
      tileOffset = tileset.tileOffset ?? tileOffset;
      tileHeight = tileset.tileHeight ?? tileHeight;
      tileWidth = tileset.tileWidth ?? tileWidth;
      transparentColor = tileset.transparentColor ?? transparentColor;
      type = tileset.type ?? type;
      version = tileset.version ?? version;
      //Add List-Attributes
      properties.addAll(tileset.properties);
      terrains.addAll(tileset.terrains);
      tiles.addAll(tileset.tiles);
      wangSets.addAll(tileset.wangSets);
    }
  }

  TileSet.fromJson(Map<String, dynamic> json) {
    backgroundColor = json['backgroundcolor'];
    columns = json['columns'];
    firstGId = json['firstgid'];
    grid = json['grid'] != null ? Grid.fromJson(json['grid']) : null;
    if (json['image'] != null) {
      image = TiledImage(json['image'], json['imageheight'], json['imagewidth']);
    }
    margin = json['margin'] ?? 0;
    name = json['name'];
    objectAlignment = json['objectalignment'];
    properties = (json['properties'] as List)?.map((e) => Property.fromJson(e))?.toList() ?? [];
    source = json['source'];
    spacing = json['spacing'] ?? 0;
    terrains = (json['terrains'] as List)?.map((e) => Terrain.fromJson(e))?.toList() ?? [];
    tileCount = json['tilecount'];
    tiledVersion = json['tiledversion'];
    tileHeight = json['tileheight'];
    tileOffset = json['tileoffset'] != null
        ? TileOffset.fromJson(json['tileoffset'])
        : null;

    final tilelist = json['tiles'] ?? <Map<String, dynamic>>[];

    if(tileCount == null && tilelist.isNotEmpty){
      tileCount = tilelist.last.localId;
    }
    final iterator = tilelist.iterator;
    Tile t = iterator.moveNext() ? Tile.fromJson(iterator.current) : Tile(-1);
    for (var i = 0; i <= tileCount; ++i) {
      if(t.localId == i){
        tiles.add(t);
        if(iterator.moveNext()) {
          t = Tile.fromJson(iterator.current);
        }
      }else{
        tiles.add(Tile(i));
      }
    }

    tileWidth = json['tilewidth'];
    transparentColor = json['transparentcolor'];
    type = json['type'];
    version = json['version'];
    wangSets = (json['wangsets'] as List)?.map((e) => WangSet.fromJson(e))?.toList() ?? [];
  }

  Rectangle computeDrawRect(Tile tile) {
    if (tile.image != null) {
      return Rectangle(0, 0, tile.image.width, tile.image.height);
    }
    final row = (tile.localId - firstGId) ~/ columns;
    final column = (tile.localId - firstGId) % columns;
    final x = margin + (column * (tileWidth + spacing));
    final y = margin + (row * (tileHeight + spacing));
    return Rectangle(x, y, tileWidth + spacing, tileHeight + spacing);
  }
}
