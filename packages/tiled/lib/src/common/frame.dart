part of tiled;

/// Below is Tiled's documentation about how this structure is represented
/// on XML files:
///
/// <frame>
///
/// * tileid: The local ID of a tile within the parent <tileset>.
/// * duration: How long (in milliseconds) this frame should be displayed
///   before advancing to the next frame.
class Frame extends Exportable {
  int tileId;
  int duration;

  Frame({
    required this.tileId,
    required this.duration,
  });

  Frame.parse(Parser parser)
      : this(
          tileId: parser.getInt('tileid'),
          duration: parser.getInt('duration'),
        );

  @override
  ExportResolver export(ExportSettings settings) => ExportElement('frame', {
    'tileid': tileId.toExport(),
    'duration': duration.toExport(),
  }, {});
}
