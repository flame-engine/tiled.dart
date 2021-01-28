part of tiled;

class WangSet {
  List<WangColor> cornercolors = [];
  List<WangColor> edgecolors = [];
  String name;
  List<Property> properties = [];
  int tile;
  List<WangTile> wangtiles = [];

  WangSet.fromXml(XmlElement xmlElement) {
    name  = xmlElement.getAttribute('name');
    tile  = int.tryParse(xmlElement.getAttribute('tile') ?? '');
    xmlElement.children.whereType<XmlElement>().forEach((XmlElement element) {
      switch (element.name.local) {
        case 'cornercolors':
          element.nodes.whereType<XmlElement>().forEach((element) {cornercolors.add(WangColor.fromXml(element));});
          break;
        case 'edgecolors':
          element.nodes.whereType<XmlElement>().forEach((element) {edgecolors.add(WangColor.fromXml(element));});
          break;
        case 'properties':
          element.nodes.whereType<XmlElement>().forEach((element) {properties.add(Property.fromXml(element));});
          break;
        case 'wangtiles':
          element.nodes.whereType<XmlElement>().forEach((element) {wangtiles.add(WangTile.fromXml(element));});
          break;
      }
    });
  }

  WangSet.fromJson(Map<String, dynamic> json) {
    if (json['cornercolors'] != null) {
      cornercolors = <WangColor>[];
      json['cornercolors'].forEach((v) {
        cornercolors.add(WangColor.fromJson(v));
      });
    }
    if (json['edgecolors'] != null) {
      edgecolors = <WangColor>[];
      json['edgecolors'].forEach((v) {
        edgecolors.add(WangColor.fromJson(v));
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
      wangtiles = <WangTile>[];
      json['wangtiles'].forEach((v) {
        wangtiles.add(WangTile.fromJson(v));
      });
    }
  }
}
