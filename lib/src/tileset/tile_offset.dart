part of tiled;

/// <tileoffset>
///
/// x: Horizontal offset in pixels. (defaults to 0)
/// y: Vertical offset in pixels (positive is down, defaults to 0)
///
/// This element is used to specify an offset in pixels, to be applied when
/// drawing a tile from the related tileset.
/// When not present, no offset is applied.
class TileOffset {
  int x;
  int y;

  TileOffset({
    required this.x,
    required this.y,
  });

  static TileOffset parse(Parser parser) {
    return TileOffset(
      x: parser.getInt('x', defaults: 0),
      y: parser.getInt('y', defaults: 0),
    );
  }
}
