part of tiled;

class WangTile {
  bool dflip;
  bool hflip;
  int tileid;
  bool vflip;
  List<int> wangid;

  WangTile.fromXml(XmlElement xmlElement) {
    tileid  = int.tryParse(xmlElement.getAttribute('tileid') ?? '');
    dflip  = xmlElement.getAttribute('dflip') == 'true';
    hflip  = xmlElement.getAttribute('hflip') == 'true';
    vflip  = xmlElement.getAttribute('vflip') == 'true';
    final id = xmlElement.getAttribute('wangid') ?? "";
    final idList = id.split(",").map(int.parse).toList();
    _setWangid(idList);
  }

  WangTile.fromJson(Map<String, dynamic> json) {
    dflip = json['dflip'];
    hflip = json['hflip'];
    tileid = json['tileid'];
    vflip = json['vflip'];
    _setWangid(json['wangid'] ?? []);
  }

  void _setWangid(List<int> value) {
    final bytes = Uint8List.fromList(value);
    final dv = ByteData.view(bytes.buffer);
    final uint32 = <int>[];
    for (var i = 0; i < value.length; ++i) {
      if (i % 4 == 0) {
        uint32.add(dv.getUint32(i,Endian.little));
      }
    }
    wangid = uint32;
  }
}
