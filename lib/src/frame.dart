part of tiled;

class Frame {
  int duration;
  int tileid;

  Frame.fromXml(XmlElement xmlElement) {
    tileid  = int.tryParse(xmlElement.getAttribute('tileid') ?? '');
    duration  = int.tryParse(xmlElement.getAttribute('duration') ?? '');
  }

  Frame.fromJson(Map<String, dynamic> json) {
    duration = json['duration'];
    tileid = json['tileid'];
  }
}
