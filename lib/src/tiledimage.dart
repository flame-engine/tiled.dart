part of tiled;

class TiledImage {
  String source;
  num width;
  num height;
  String trans;

  // Needed for Json
  TiledImage(this.source, this.width, this.height);

  TiledImage.fromXml(XmlElement xmlElement) {
    height  = int.tryParse(xmlElement.getAttribute('height') ?? '');
    width  = int.tryParse(xmlElement.getAttribute('width') ?? '');
    source  = xmlElement.getAttribute('source');
    trans  = xmlElement.getAttribute('trans'); // “#FF00FF”

    // Embedded Images are unsupported by tiled yet:
    // id
    // format  = xmlElement.getAttribute('format'); // file extensions like png, gif, jpg, bmp, etc.
    // data
  }

  /// Needed for getTiledImages in TileMap;
  /// Images are equal if their source is equal.
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TiledImage &&
          runtimeType == other.runtimeType &&
          source == other.source;

  @override
  int get hashCode => source.hashCode;
}
