part of tiled;

class Chunksize {
  int height;
  int width;

  Chunksize.fromXml(XmlNode xmlElement) {
    height = int.tryParse(xmlElement.getAttribute('height') ?? '');
    width = int.tryParse(xmlElement.getAttribute('width') ?? '');
  }

  Chunksize.fromJson(Map<String, dynamic> json) {
    height = json['height'];
    width = json['width'];
  }
}
