part of tiled;

class Tile {
  static const int FLIPPED_HORIZONTALLY_FLAG = 0x80000000;
  static const int FLIPPED_VERTICALLY_FLAG = 0x40000000;
  static const int FLIPPED_DIAGONALLY_FLAG = 0x20000000;

  List<Frame> animation = [];
  int id;
  TiledImage image;
  Layer objectgroup;
  double probability;
  List<Property> properties = [];
  List<int> terrain = []; // index of the terrain
  String type;

  //Additionaly
  bool flippedHorizontally = false;
  bool flippedVertically = false;
  bool flippedDiagonally = false;

  Tile(this.id);

  Tile.fromXml(XmlElement xmlElement) {
    id = int.tryParse(xmlElement.getAttribute('id') ?? '');
    // get flips from id
    flippedHorizontally =
        (id & FLIPPED_HORIZONTALLY_FLAG) == FLIPPED_HORIZONTALLY_FLAG;
    flippedVertically =
        (id & FLIPPED_VERTICALLY_FLAG) == FLIPPED_VERTICALLY_FLAG;
    flippedDiagonally =
        (id & FLIPPED_DIAGONALLY_FLAG) == FLIPPED_DIAGONALLY_FLAG;
    //clear id from flips
    id &= ~(FLIPPED_HORIZONTALLY_FLAG |
        FLIPPED_VERTICALLY_FLAG |
        FLIPPED_DIAGONALLY_FLAG);

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
          objectgroup = Layer.fromXml(
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
    id = json['id'];
    if (json['image'] != null) {
      image =
          TiledImage(json['image'], json['imageheight'], json['imagewidth']);
    }
    objectgroup = json['objectgroup'];
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
