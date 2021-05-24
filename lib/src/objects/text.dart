part of tiled;

/// Below is Tiled's documentation about how this structure is represented
/// on XML files:
///
/// <text>
///
/// * fontfamily: The font family used (defaults to "sans-serif")
/// * pixelsize: The size of the font in pixels (not using points, because
///   other sizes in the TMX format are also using pixels) (defaults to 16)
/// * wrap: Whether word wrapping is enabled (1) or disabled (0).
///   (defaults to 0)
/// * color: Color of the text in #AARRGGBB or #RRGGBB format
///   (defaults to #000000)
/// * bold: Whether the font is bold (1) or not (0). (defaults to 0)
/// * italic: Whether the font is italic (1) or not (0). (defaults to 0)
/// * underline: Whether a line should be drawn below the text (1) or not (0).
///   (defaults to 0)
/// * strikeout: Whether a line should be drawn through the text (1) or not (0).
///   (defaults to 0)
/// * kerning: Whether kerning should be used while rendering the text (1) or
///   not (0). (defaults to 1)
/// * halign: Horizontal alignment of the text within the object (left, center,
///   right or justify, defaults to left) (since Tiled 1.2.1)
/// * valign: Vertical alignment of the text within the object (top , center
///   or bottom, defaults to top)
///
/// Used to mark an object as a text object. Contains the actual text as
/// character data.
///
/// For alignment purposes, the bottom of the text is the descender height of
/// the font, and the top of the text is the ascender height of the font.
/// For example, bottom alignment of the word “cat” will leave some space below
/// the text, even though it is unused for this word with most fonts.
/// Similarly, top alignment of the word “cat” will leave some space above the
/// "t" with most fonts, because this space is used for diacritics.
///
/// If the text is larger than the object’s bounds, it is clipped to the bounds
/// of the object.
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
