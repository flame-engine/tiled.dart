part of tiled;

class Grid {
  int height;
  GridOrientation orientation;
  int width;

  Grid.fromXml(XmlElement xmlElement) {
    height = int.tryParse(xmlElement.getAttribute('height') ?? '');
    width = int.tryParse(xmlElement.getAttribute('width') ?? '');
    orientation = GridOrientation.values.firstWhere(
        (e) => e.name == xmlElement.getAttribute('orientation'),
        orElse: () => null);
  }

  Grid.fromJson(Map<String, dynamic> json) {
    height = json['height'];
    orientation = GridOrientation.values
        .firstWhere((e) => e.name == json['orientation'], orElse: () => null);
    width = json['width'];
  }
}
