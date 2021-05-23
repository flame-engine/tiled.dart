part of tiled;

class Text {
  String fontFamily;
  int pixelSize;
  String color;

  String text;

  HAlign hAlign;
  VAlign vAlign;

  bool bold;
  bool italic;
  bool underline;
  bool strikeout;
  bool kerning;
  bool wrap;

  Text({
    this.fontFamily = 'sans-serif',
    this.pixelSize = 16,
    this.color = '#000000',
    this.text = "",
    this.hAlign = HAlign.left,
    this.vAlign = VAlign.top,
    this.bold = false,
    this.italic = false,
    this.underline = false,
    this.strikeout = false,
    this.kerning = true,
    this.wrap = false,
  });

  static Text parse(Parser parser) {
    return Text(
      fontFamily: parser.getString('fontFamily', defaults: 'sans-serif'),
      pixelSize: parser.getInt('pixelSize', defaults: 16),
      color: parser.getString('color', defaults: '#000000'),
      text: parser.getString('text', defaults: ""),
      hAlign: parser.getHAlign('hAlign', defaults: HAlign.left),
      vAlign: parser.getVAlign('vAlign', defaults: VAlign.top),
      bold: parser.getBool('bold', defaults: false),
      italic: parser.getBool('italic', defaults: false),
      underline: parser.getBool('underline', defaults: false),
      strikeout: parser.getBool('strikeout', defaults: false),
      kerning: parser.getBool('kerning', defaults: true),
      wrap: parser.getBool('wrap', defaults: false),
    );
  }
}
