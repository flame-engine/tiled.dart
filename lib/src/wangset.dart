part of tiled;

class WangSet {
  List<WangColor> cornerColors = [];
  List<WangColor> edgeColors = [];
  String name;
  List<Property> properties = [];
  int tile;
  List<WangTile> wangTiles = [];

  WangSet.fromXml(XmlElement xmlElement) {
    name  = xmlElement.getAttribute('name');
    tile  = int.tryParse(xmlElement.getAttribute('tile') ?? '');
    xmlElement.children.whereType<XmlElement>().forEach((XmlElement element) {
      switch (element.name.local) {
        case 'wangcolor':
          if( xmlElement.getAttribute('type') == 'corner'){
            cornerColors.add(WangColor.fromXml(element));
          }else{
            edgeColors.add(WangColor.fromXml(element));
          }
          break;
        case 'properties':
          element.nodes.whereType<XmlElement>().forEach((element) {properties.add(Property.fromXml(element));});
          break;
        case 'wangtile':
          wangTiles.add(WangTile.fromXml(element));
          break;
      }
    });
  }

  WangSet.fromJson(Map<String, dynamic> json) {
    if (json['cornercolors'] != null) {
      cornerColors = <WangColor>[];
      json['cornercolors'].forEach((v) {
        cornerColors.add(WangColor.fromJson(v));
      });
    }
    if (json['edgecolors'] != null) {
      edgeColors = <WangColor>[];
      json['edgecolors'].forEach((v) {
        edgeColors.add(WangColor.fromJson(v));
      });
    }
    name = json['name'];
    if (json['properties'] != null) {
      properties = <Property>[];
      json['properties'].forEach((v) {
        properties.add(Property.fromJson(v));
      });
    }
    tile = json['tile'];
    if (json['wangtiles'] != null) {
      wangTiles = <WangTile>[];
      json['wangtiles'].forEach((v) {
        wangTiles.add(WangTile.fromJson(v));
      });
    }
  }
}
