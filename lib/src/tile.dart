part of tiled;

class Tile {
  List<Frame> animation = [];
  int localId;
  TiledImage image;
  Layer objectGroup;
  double probability;
  List<Property> properties = [];
  List<int> terrain = []; // index of the terrain
  String type;

  Tile(this.localId);

  bool get isEmpty => localId == 0;

  Tile.fromXml(XmlElement xmlElement) {
    localId = int.tryParse(xmlElement.getAttribute('id') ?? '');
    probability =
        double.tryParse(xmlElement.getAttribute('probability') ?? '0');
    type = xmlElement.getAttribute('type');
    xmlElement.children.whereType<XmlElement>().forEach((XmlElement element) {
      switch (element.name.local) {
        case 'image':
          image = TiledImage.fromXml(element);
          break;
        case 'properties':
          element.nodes.whereType<XmlElement>().forEach((element) {
            properties.add(Property.fromXml(element));
          });
          break;
        case 'terrain':
          element.nodes.whereType<XmlElement>().forEach((element) {
            terrain.add(int.tryParse(element.getAttribute('id') ?? ''));
          });
          break;
        case 'animation':
          element.nodes.whereType<XmlElement>().forEach((element) {
            animation.add(Frame.fromXml(element));
          });
          break;
        case 'objectgroup':
          objectGroup = Layer.fromXml(element);
          break;
      }
    });
  }

  Tile.fromJson(Map<String, dynamic> json) {
    animation =
        (json['animation'] as List)?.map((e) => Frame.fromJson(e))?.toList() ??
            [];
    localId = json['id'];
    if (json['image'] != null) {
      image =
          TiledImage(json['image'], json['imageheight'], json['imagewidth']);
    }
    objectGroup = json['objectgroup'];
    probability = json['probability'] ?? 0;
    properties = (json['properties'] as List)
            ?.map((e) => Property.fromJson(e))
            ?.toList() ??
        [];
    terrain = (json['terrain'] as List)?.map((e) => e)?.toList() ??
        []; //TODO correct?
    type = json['type'];
  }
}
