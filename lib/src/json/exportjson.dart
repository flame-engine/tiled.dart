class ExportJson {
  String format;
  String target;

  ExportJson({this.format, this.target});

  ExportJson.fromJson(Map<String, dynamic> json) {
    format = json['format'];
    target = json['target'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['format'] = format;
    data['target'] = target;
    return data;
  }
}
