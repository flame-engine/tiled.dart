part of tiled;

class Tile {
  List<Frame> animation = [];
  int gid;
  TiledImage image;
  Layer objectGroup;
  double probability;
  List<Property> properties = [];
  List<int> terrain = []; // index of the terrain
  String type;

  Tile(this.gid);

  bool get isEmpty => gid == 0;

  Tile.fromXml(XmlElement xmlElement) {
    gid = int.tryParse(xmlElement.getAttribute('id') ?? '');
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
          objectGroup = Layer.fromXml(
              element);
          break;
      }
    });
  }

  Tile.fromJson(Map<String, dynamic> json) {
    if (json['animation'] != null) {
      animation = <Frame>[];
      json['animation'].forEach((v) {
        animation.add(Frame.fromJson(v));
      });
    }
    gid = json['id'];
    if (json['image'] != null) {
      image =
          TiledImage(json['image'], json['imageheight'], json['imagewidth']);
    }
    objectGroup = json['objectgroup'];
    probability = json['probability'] ?? 0;
    if (json['properties'] != null) {
      properties = <Property>[];
      json['properties'].forEach((v) {
        properties.add(Property.fromJson(v));
      });
    }
    if (json['terrain'] != null) {
      terrain = <int>[];
      json['terrain'].forEach((v) {
        terrain.add(v);
      });
    }
    type = json['type'];
  }
}
