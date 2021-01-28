part of tiled;

class Text {
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

  Text.fromXml(XmlElement element) {
    bold = (element.getAttribute('bold') ?? '0') == '1';
    color = element.getAttribute('color') ?? '#000000';
    fontfamily = element.getAttribute('fontfamily') ?? 'sans-serif';
    halign = element.getAttribute('halign') ?? 'left'; // left, center, right or justify, defaults to left
    italic = (element.getAttribute('italic') ?? '0') == '1';
    kerning = (element.getAttribute('kerning') ?? '0') == '1';
    pixelsize = int.tryParse(element.getAttribute('pixelsize') ?? '16');
    strikeout = (element.getAttribute('strikeout') ?? '0') == '1';
    text = element.getAttribute('text') ?? '';
    underline = (element.getAttribute('underline') ?? '0') == '1';
    valign = element.getAttribute('valign') ?? 'top'; // top , center or bottom, defaults to top
    wrap = (element.getAttribute('wrap') ?? '0') == '1';
  }

  Text.fromJson(Map<String, dynamic> json) {
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
}
