part of tiled;

class Text {
  bool bold = false;
  String color = '#000000';
  String fontFamily = 'sans-serif';
  HAlign hAlign = HAlign.left;
  bool italic = false;
  bool kerning = true;
  int pixelSize = 16;
  bool strikeout = false;
  String text = "";
  bool underline = false;
  VAlign vAlign = VAlign.top;
  bool wrap = false;

  Text.fromXml(XmlElement element) {
    bold = (element.getAttribute('bold') ?? '0') == '1';
    color = element.getAttribute('color') ?? '#000000';
    fontFamily = element.getAttribute('fontfamily') ?? 'sans-serif';
    hAlign = HAlign.values.firstWhere(
        (e) => e.name == element.getAttribute('halign'),
        orElse: () => HAlign.left);
    italic = (element.getAttribute('italic') ?? '0') == '1';
    kerning = (element.getAttribute('kerning') ?? '0') == '1';
    pixelSize = int.tryParse(element.getAttribute('pixelsize') ?? '16');
    strikeout = (element.getAttribute('strikeout') ?? '0') == '1';
    text = element.text ?? '';
    underline = (element.getAttribute('underline') ?? '0') == '1';
    vAlign = VAlign.values.firstWhere(
        (e) => e.name == element.getAttribute('valign'),
        orElse: () => VAlign.top);
    wrap = (element.getAttribute('wrap') ?? '0') == '1';
  }

  Text.fromJson(Map<String, dynamic> json) {
    bold = json['bold'];
    color = json['color'];
    fontFamily = json['fontfamily'];
    hAlign = HAlign.values
        .firstWhere((e) => e.name == json['halign'], orElse: () => HAlign.left);
    italic = json['italic'];
    kerning = json['kerning'];
    pixelSize = json['pixelsize'];
    strikeout = json['strikeout'];
    text = json['text'];
    underline = json['underline'];
    vAlign = VAlign.values
        .firstWhere((e) => e.name == json['valign'], orElse: () => VAlign.top);
    wrap = json['wrap'];
  }
}
