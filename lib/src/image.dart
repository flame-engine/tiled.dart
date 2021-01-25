part of tiled;

class Image {
  String source;
  num width;
  num height;
  String trans;

  Image(this.source, this.width, this.height);

  Image.fromXML(XmlElement xmlElement) {
    height  = int.parse(xmlElement.getAttribute('height'));
    width  = int.parse(xmlElement.getAttribute('width'));
    source  = xmlElement.getAttribute('source');
    trans  = xmlElement.getAttribute('trans'); // “#FF00FF”

    // TODO Embedded Images are unsupported by tiled yet:
    // id
    // format  = xmlElement.getAttribute('format'); // file extensions like png, gif, jpg, bmp, etc.
    // data
  }
}
