part of tiled;

class WangTile {
  bool dFlip;
  bool hFlip;
  int tileId;
  bool vFlip;
  List<int> wangId;

  WangTile.fromXml(XmlElement xmlElement) {
    tileId  = int.tryParse(xmlElement.getAttribute('tileid') ?? '');
    dFlip  = xmlElement.getAttribute('dflip') == 'true';
    hFlip  = xmlElement.getAttribute('hflip') == 'true';
    vFlip  = xmlElement.getAttribute('vflip') == 'true';
    final id = xmlElement.getAttribute('wangid') ?? "";
    final idList = id.split(",").map(int.parse).toList();
    _setWangid(idList);
  }

  WangTile.fromJson(Map<String, dynamic> json) {
    dFlip = json['dflip'];
    hFlip = json['hflip'];
    tileId = json['tileid'];
    vFlip = json['vflip'];
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
    wangId = uint32;
  }
}
