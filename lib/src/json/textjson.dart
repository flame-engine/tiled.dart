class TextJson {
  bool bold = false;
  String color = '#000000';
  String fontfamily = 'sans-serif';
  String halign = 'left'; // center, right, justify or left
  bool italic = false;
  bool kerning = true;
  int pixelsize = 16;
  bool strikeout = false;
  String text = "";
  bool underline = false;
  String valign = 'top'; // center, bottom or top
  bool wrap = false;

  TextJson(
      {this.bold,
      this.color,
      this.fontfamily,
      this.halign,
      this.italic,
      this.kerning,
      this.pixelsize,
      this.strikeout,
      this.text,
      this.underline,
      this.valign,
      this.wrap});

  TextJson.fromJson(Map<String, dynamic> json) {
    bold = json['bold'];
    color = json['color'];
    fontfamily = json['fontfamily'];
    halign = json['halign'];
    italic = json['italic'];
    kerning = json['kerning'];
    pixelsize = json['pixelsize'];
    strikeout = json['strikeout'];
    text = json['text'];
    underline = json['underline'];
    valign = json['valign'];
    wrap = json['wrap'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['bold'] = bold;
    data['color'] = color;
    data['fontfamily'] = fontfamily;
    data['halign'] = halign;
    data['italic'] = italic;
    data['kerning'] = kerning;
    data['pixelsize'] = pixelsize;
    data['strikeout'] = strikeout;
    data['text'] = text;
    data['underline'] = underline;
    data['valign'] = valign;
    data['wrap'] = wrap;
    return data;
  }
}
