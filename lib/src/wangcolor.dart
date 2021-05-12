part of tiled;

class WangColor {
  String color;
  String name;
  double probability;
  int tile;

  WangColor.fromXml(XmlElement xmlElement) {
    tile = int.tryParse(xmlElement.getAttribute('tile') ?? '');
    probability = double.tryParse(xmlElement.getAttribute('probability') ?? 0);
    color = xmlElement.getAttribute('color');
    name = xmlElement.getAttribute('name');
  }

  WangColor.fromJson(Map<String, dynamic> json) {
    color = json['color'];
    name = json['name'];
    probability = json['probability'] ?? 0;
    tile = json['tile'];
  }
}
