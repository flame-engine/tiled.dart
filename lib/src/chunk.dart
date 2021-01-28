part of tiled;

class Chunk {
  String
      data; // TODO array or string - 	Array of unsigned int (GIDs) or base64-encoded data
  int height;
  int width;
  int x;
  int y;

  Chunk.fromXml(XmlNode xmlElement) {
    height = int.tryParse(xmlElement.getAttribute('height') ?? '');
    width = int.tryParse(xmlElement.getAttribute('width') ?? '');
    x = int.tryParse(xmlElement.getAttribute('x') ?? '');
    y = int.tryParse(xmlElement.getAttribute('y') ?? '');
    //TODO data
  }

  Chunk.fromJson(Map<String, dynamic> json) {
    data = json['data']; //TODO Data object with enc & comp?
    height = json['height'];
    width = json['width'];
    x = json['x'];
    y = json['y'];
  }
}
