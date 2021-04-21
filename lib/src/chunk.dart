part of tiled;

class Chunk {
  List<int> data;
  int height;
  int width;
  int x;
  int y;

  // Convenience
  List<List<int>> tileIdMatrix;
  List<List<Flips>> tileFlips;

  Chunk.fromXml(
      XmlNode xmlElement, FileEncoding encoding, Compression compression) {
    height = int.tryParse(xmlElement.getAttribute('height') ?? '');
    width = int.tryParse(xmlElement.getAttribute('width') ?? '');
    x = int.tryParse(xmlElement.getAttribute('x') ?? '');
    y = int.tryParse(xmlElement.getAttribute('y') ?? '');
    data = Layer.decodeData(xmlElement.text, encoding, compression);

    tileIdMatrix = List.generate(height, (_) => List<int>.filled(width, 0));
    tileFlips = List.generate(height, (_) => List<Flips>.filled(width, null));
    Layer.generateTiles(data, height, width, tileIdMatrix, tileFlips);
  }

  Chunk.fromJson(Map<String, dynamic> json, FileEncoding encoding,
      Compression compression) {
    data = Layer.decodeData(json['data'], encoding, compression);
    height = json['height'];
    width = json['width'];
    x = json['x'];
    y = json['y'];

    tileIdMatrix = List.generate(height, (_) => List<int>.filled(width, 0));
    tileFlips = List.generate(height, (_) => List<Flips>.filled(width, null));
    Layer.generateTiles(data, height, width, tileIdMatrix, tileFlips);
  }
}
