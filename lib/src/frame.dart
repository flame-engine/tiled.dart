part of tiled;

class Frame {
  int duration;
  int tileId;

  Frame.fromXml(XmlElement xmlElement) {
    tileId  = int.tryParse(xmlElement.getAttribute('tileid') ?? '');
    duration  = int.tryParse(xmlElement.getAttribute('duration') ?? '');
  }

  Frame.fromJson(Map<String, dynamic> json) {
    duration = json['duration'];
    tileId = json['tileid'];
  }
}
