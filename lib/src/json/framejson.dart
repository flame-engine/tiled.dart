import 'package:xml/xml.dart';

class FrameJson {
  int duration;
  int tileid;

  FrameJson({this.duration, this.tileid});

  FrameJson.fromXML(XmlElement xmlElement) {
    tileid  = int.parse(xmlElement.getAttribute('tileid'));
    duration  = int.parse(xmlElement.getAttribute('duration'));
  }

  FrameJson.fromJson(Map<String, dynamic> json) {
    duration = json['duration'];
    tileid = json['tileid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['duration'] = duration;
    data['tileid'] = tileid;
    return data;
  }
}
