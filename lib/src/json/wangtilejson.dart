
import 'package:xml/xml.dart';

class WangTileJson {
  bool dflip;
  bool hflip;
  int tileid;
  bool vflip;
  List<int> wangid; //32-bit unsigned integer

  WangTileJson({this.dflip, this.hflip, this.tileid, this.vflip, this.wangid});

  WangTileJson.fromXML(XmlElement xmlElement) {
    tileid  = int.tryParse(xmlElement.getAttribute('tileid') ?? '');
    // wangid  = int.parse(xmlElement.getAttribute('wangid')); // TODO parse Int32
    dflip  = xmlElement.getAttribute('dflip') == 'true';
    hflip  = xmlElement.getAttribute('hflip') == 'true';
    vflip  = xmlElement.getAttribute('vflip') == 'true';
  }

  WangTileJson.fromJson(Map<String, dynamic> json) {
    dflip = json['dflip'];
    hflip = json['hflip'];
    tileid = json['tileid'];
    vflip = json['vflip'];
    if (json['wangid'] != null) {
      wangid = <int>[];
      json['wangid'].forEach((v) {
        wangid.add(v);
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['dflip'] = dflip;
    data['hflip'] = hflip;
    data['tileid'] = tileid;
    data['vflip'] = vflip;
    if (wangid != null) {
      data['wangid'] = wangid.map((v) => v).toList();
    }
    return data;
  }
}
