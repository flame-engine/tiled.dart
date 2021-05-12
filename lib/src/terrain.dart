part of tiled;

class Terrain {
  String name;
  List<Property> properties = [];
  int tile;

  Terrain.fromXml(XmlElement xmlElement) {
    name = xmlElement.getAttribute('name');
    tile = int.tryParse(xmlElement.getAttribute('tile') ?? '');
    xmlElement.children.whereType<XmlElement>().forEach((XmlElement element) {
      switch (element.name.local) {
        case 'properties':
          element.nodes.whereType<XmlElement>().forEach((element) {
            properties.add(Property.fromXml(element));
          });
          break;
      }
    });
  }

  Terrain.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    properties = (json['properties'] as List)
            ?.map((e) => Property.fromJson(e))
            ?.toList() ??
        [];
    tile = json['tile'];
  }
}
