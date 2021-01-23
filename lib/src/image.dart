part of tiled;

class Image {
  String source;
  num width;
  num height;

  Image(this.source, this.width, this.height);

  @override
  String toString() {
    return 'Image{source: $source, width: $width, height: $height}';
  }
}
