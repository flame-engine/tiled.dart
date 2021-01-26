part of tiled;

class Image {
  String source;
  num width;
  num height;
  String trans;

  Image(this.source, this.width, this.height);

  Image.fromXML(XmlElement xmlElement) {
    height  = int.tryParse(xmlElement.getAttribute('height') ?? '');
    width  = int.tryParse(xmlElement.getAttribute('width') ?? '');
    source  = xmlElement.getAttribute('source');
    trans  = xmlElement.getAttribute('trans'); // “#FF00FF”

    // Embedded Images are unsupported by tiled yet:
    // id
    // format  = xmlElement.getAttribute('format'); // file extensions like png, gif, jpg, bmp, etc.
    // data
  }

  @override
  String toString() {
    return 'Image{source: $source, width: $width, height: $height, trans: $trans}';
  }
}
