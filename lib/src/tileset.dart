part of tiled;

class Tileset {
  String backgroundcolor;
  int columns;
  int firstgid;
  Grid grid;
  TiledImage image;
  int margin;
  String name;
  String objectalignment;
  List<Property> properties = [];
  String source;
  int spacing;
  List<Terrain> terrains = [];
  int tilecount;
  String tiledversion;
  TileOffset tileoffset;
  List<Tile> tiles = [];
  int tileheight;
  int tilewidth;
  String transparentcolor;
  String type;
  num version;
  List<WangSet> wangsets = [];

  Tileset.fromXml(XmlNode xmlElement) {
    backgroundcolor = xmlElement.getAttribute('backgroundcolor');
    columns = int.tryParse(xmlElement.getAttribute('columns') ?? '');
    firstgid = int.tryParse(xmlElement.getAttribute('firstgid') ?? '');
    margin = int.tryParse(xmlElement.getAttribute('margin') ?? '0');
    name = xmlElement.getAttribute('name');
    objectalignment = xmlElement.getAttribute('objectalignment');
    source = xmlElement.getAttribute('source');
    spacing = int.tryParse(xmlElement.getAttribute('spacing') ?? '0');
    tilecount = int.tryParse(xmlElement.getAttribute('tilecount') ?? '');
    tileheight = int.tryParse(xmlElement.getAttribute('tileheight') ?? '');
    tiledversion = xmlElement.getAttribute('tiledversion');
    tilewidth = int.tryParse(xmlElement.getAttribute('tilewidth') ?? '');
    transparentcolor = xmlElement.getAttribute('transparentcolor');
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
          tileoffset = TileOffset.fromXml(element);
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
            wangsets.add(WangSet.fromXml(element));
          });
          break;
      }
    });

    final iterator = tilelist.iterator;
    Tile t = iterator.moveNext() ? iterator.current : Tile(-1);
    for (var i = 0; i < tilecount; ++i) {
      if(t.id == i){
        tiles.add(t);
        if(iterator.moveNext()) {
          t = iterator.current;
        }
      }else{
        tiles.add(Tile(i));
      }
    }
  }

  Tileset.fromJson(Map<String, dynamic> json) {
    backgroundcolor = json['backgroundcolor'];
    columns = json['columns'];
    firstgid = json['firstgid'];
    grid = json['grid'] != null ? Grid.fromJson(json['grid']) : null;
    if (json['image'] != null) {
      image = TiledImage(json['image'], json['imageheight'], json['imagewidth']);
    }
    margin = json['margin'] ?? 0;
    name = json['name'];
    objectalignment = json['objectalignment'];
    if (json['properties'] != null) {
      properties = <Property>[];
      json['properties'].forEach((v) {
        properties.add(Property.fromJson(v));
      });
    }
    source = json['source'];
    spacing = json['spacing'] ?? 0;
    if (json['terrains'] != null) {
      terrains = <Terrain>[];
      json['terrains'].forEach((v) {
        terrains.add(Terrain.fromJson(v));
      });
    }
    tilecount = json['tilecount'];
    tiledversion = json['tiledversion'];
    tileheight = json['tileheight'];
    tileoffset = json['tileoffset'] != null
        ? TileOffset.fromJson(json['tileoffset'])
        : null;

    final tilelist = json['tiles'] ?? <Map<String, dynamic>>[];

    final iterator = tilelist.iterator;
    Tile t = iterator.moveNext() ? Tile.fromJson(iterator.current) : Tile(-1);
    for (var i = 0; i < tilecount; ++i) {
      if(t.id == i){
        tiles.add(t);
        if(iterator.moveNext()) {
          t = Tile.fromJson(iterator.current);
        }
      }else{
        tiles.add(Tile(i));
      }
    }

    tilewidth = json['tilewidth'];
    transparentcolor = json['transparentcolor'];
    type = json['type'];
    version = json['version'];
    if (json['wangsets'] != null) {
      wangsets = <WangSet>[];
      json['wangsets'].forEach((v) {
        wangsets.add(WangSet.fromJson(v));
      });
    }
  }
}
