part of '../../tiled.dart';

/// Below is Tiled's documentation about how this structure is represented
/// on XML files:
///
/// <grid>
///
/// * orientation: Orientation of the grid for the tiles in this tileset
///   (orthogonal or isometric, defaults to orthogonal)
/// * width: Width of a grid cell
/// * height: Height of a grid cell
///
/// This element is only used in case of isometric orientation, and determines
/// how tile overlays for terrain and collision information are rendered.
class Grid {
  int width;
  int height;
  GridOrientation orientation;

  Grid({
    required this.width,
    required this.height,
    required this.orientation,
  });

  Grid.parse(Parser parser)
      : this(
          width: parser.getInt('width'),
          height: parser.getInt('height'),
          orientation: parser.getGridOrientation('orientation'),
        );
}
