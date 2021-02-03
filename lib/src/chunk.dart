part of tiled;

class Chunk {
  List<int> data;
  int height;
  int width;
  int x;
  int y;

  // Convenience

  List<List<int>> tileIDMatrix;
  List<List<Flips>> tileFlips;

  Chunk.fromXml(XmlNode xmlElement, String encoding, String compression) {
    height = int.tryParse(xmlElement.getAttribute('height') ?? '');
    width = int.tryParse(xmlElement.getAttribute('width') ?? '');
    x = int.tryParse(xmlElement.getAttribute('x') ?? '');
    y = int.tryParse(xmlElement.getAttribute('y') ?? '');
    data = Layer.decodeData(xmlElement.text, encoding, compression);

    tileIDMatrix = List.generate(height, (_) => List<int>(width));
    tileFlips = List.generate(height, (_) => List<Flips>(width));
    Layer.generateTiles(data, height, width, tileIDMatrix, tileFlips);
  }

  Chunk.fromJson(Map<String, dynamic> json, String encoding, String compression) {
    data = Layer.decodeData(json['data'], encoding, compression);
    height = json['height'];
    width = json['width'];
    x = json['x'];
    y = json['y'];

    tileIDMatrix = List.generate(height, (_) => List<int>(width));
    tileFlips = List.generate(height, (_) => List<Flips>(width));
  }
}
