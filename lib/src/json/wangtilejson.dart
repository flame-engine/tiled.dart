class WangTileJson {
  bool dflip;
  bool hflip;
  int tile;
  bool vflip;
  List<int> wangid = [];

  WangTileJson({this.dflip, this.hflip, this.tile, this.vflip, this.wangid});

  WangTileJson.fromJson(Map<String, dynamic> json) {
    dflip = json['dflip'];
    hflip = json['hflip'];
    tile = json['tile'];
    vflip = json['vflip'];
    wangid = json['wangid'];
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
    data['tile'] = tile;
    data['vflip'] = vflip;
    if (wangid != null) {
      data['wangid'] = wangid.map((v) => v).toList();
    }
    return data;
  }
}
