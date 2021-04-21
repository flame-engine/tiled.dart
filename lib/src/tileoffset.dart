part of tiled;

class TileOffset {
  int x;
  int y;

  TileOffset.fromXml(XmlElement xmlElement) {
    x = int.tryParse(xmlElement.getAttribute('x') ?? '');
    y = int.tryParse(xmlElement.getAttribute('y') ?? '');
  }

  TileOffset.fromJson(Map<String, dynamic> json) {
    x = json['x'];
    y = json['y'];
  }
}
