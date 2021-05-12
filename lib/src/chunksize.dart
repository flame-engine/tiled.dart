part of tiled;

class ChunkSize {
  int height;
  int width;

  ChunkSize.fromXml(XmlNode xmlElement) {
    height = int.tryParse(xmlElement.getAttribute('height') ?? '');
    width = int.tryParse(xmlElement.getAttribute('width') ?? '');
  }

  ChunkSize.fromJson(Map<String, dynamic> json) {
    height = json['height'];
    width = json['width'];
  }
}
