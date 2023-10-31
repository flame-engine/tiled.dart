part of tiled;

/// Below is Tiled's documentation about how this structure is represented
/// on XML files:
///
/// <tileoffset>
///
/// x: Horizontal offset in pixels. (defaults to 0)
/// y: Vertical offset in pixels (positive is down, defaults to 0)
///
/// This element is used to specify an offset in pixels, to be applied when
/// drawing a tile from the related tileset.
/// When not present, no offset is applied.
class TileOffset extends Exportable {
  int x;
  int y;

  TileOffset({
    required this.x,
    required this.y,
  });

  TileOffset.parse(Parser parser)
      : this(
          x: parser.getInt('x', defaults: 0),
          y: parser.getInt('y', defaults: 0),
        );

  @override
  ExportResolver export(ExportSettings settings) => ExportElement(
        'tileoffset',
        {
          'x': x.toExport(),
          'y': y.toExport(),
        },
        {},
      );
}
