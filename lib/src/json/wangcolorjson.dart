class WangColorJson {
  String color;
  String name;
  double probability;
  int tile;

  WangColorJson({this.color, this.name, this.probability, this.tile});

  WangColorJson.fromJson(Map<String, dynamic> json) {
    color = json['color'];
    name = json['name'];
    probability = json['probability'];
    tile = json['tile'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['color'] = color;
    data['name'] = name;
    data['probability'] = probability;
    data['tile'] = tile;
    return data;
  }
}
