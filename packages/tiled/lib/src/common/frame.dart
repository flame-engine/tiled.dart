part of tiled;

/// Below is Tiled's documentation about how this structure is represented
/// on XML files:
///
/// <frame>
///
/// * tileid: The local ID of a tile within the parent <tileset>.
/// * duration: How long (in milliseconds) this frame should be displayed
///   before advancing to the next frame.
class Frame {
  int tileId;
  int duration;

  Frame({
    required this.tileId,
    required this.duration,
  });

  static Frame parse(Parser parser) {
    return Frame(
      tileId: parser.getInt('tileid'),
      duration: parser.getInt('duration'),
    );
  }
}
