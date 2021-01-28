part of tiled;

class WangTile {
  bool dflip;
  bool hflip;
  int tileid;
  bool vflip;
  List<int> wangid; //TODO 32-bit unsigned integer

  WangTile.fromXml(XmlElement xmlElement) {
    tileid  = int.tryParse(xmlElement.getAttribute('tileid') ?? '');
    // wangid  = int.parse(xmlElement.getAttribute('wangid')); // TODO parse Int32
    dflip  = xmlElement.getAttribute('dflip') == 'true';
    hflip  = xmlElement.getAttribute('hflip') == 'true';
    vflip  = xmlElement.getAttribute('vflip') == 'true';
  }

  WangTile.fromJson(Map<String, dynamic> json) {
    dflip = json['dflip'];
    hflip = json['hflip'];
    tileid = json['tileid'];
    vflip = json['vflip'];
    if (json['wangid'] != null) {
      wangid = <int>[];
      json['wangid'].forEach((v) { // TODO parse Int32
        wangid.add(v);
      });
    }
  }
}
