part of tiled;

class WangSet {
  List<WangColor> cornerColors = [];
  List<WangColor> edgeColors = [];
  String name;
  List<Property> properties = [];
  int tile;
  List<WangTile> wangTiles = [];

  WangSet.fromXml(XmlElement xmlElement) {
    name = xmlElement.getAttribute('name');
    tile = int.tryParse(xmlElement.getAttribute('tile') ?? '');
    xmlElement.children.whereType<XmlElement>().forEach((XmlElement element) {
      switch (element.name.local) {
        case 'wangcolor':
          if (xmlElement.getAttribute('type') == 'corner') {
            cornerColors.add(WangColor.fromXml(element));
          } else {
            edgeColors.add(WangColor.fromXml(element));
          }
          break;
        case 'properties':
          element.nodes.whereType<XmlElement>().forEach((element) {
            properties.add(Property.fromXml(element));
          });
          break;
        case 'wangtile':
          wangTiles.add(WangTile.fromXml(element));
          break;
      }
    });
  }

  WangSet.fromJson(Map<String, dynamic> json) {
    cornerColors = (json['cornercolors'] as List)
            ?.map((e) => WangColor.fromJson(e))
            ?.toList() ??
        [];
    edgeColors = (json['edgecolors'] as List)
            ?.map((e) => WangColor.fromJson(e))
            ?.toList() ??
        [];
    name = json['name'];
    properties = (json['properties'] as List)
            ?.map((e) => Property.fromJson(e))
            ?.toList() ??
        [];
    tile = json['tile'];
    wangTiles = (json['wangtiles'] as List)
            ?.map((e) => WangTile.fromJson(e))
            ?.toList() ??
        [];
  }
}
