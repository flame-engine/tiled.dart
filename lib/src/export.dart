part of tiled;

class Export {
  String format;
  String target;

  Export.fromXml(XmlNode xmlElement) {
    format = xmlElement.getAttribute('format');
    target = xmlElement.getAttribute('target');
  }

  Export.fromJson(Map<String, dynamic> json) {
    format = json['format'];
    target = json['target'];
  }
}
