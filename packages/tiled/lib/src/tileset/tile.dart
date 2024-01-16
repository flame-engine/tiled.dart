part of tiled;

/// Below is Tiled's documentation about how this structure is represented
/// on XML files:
///
/// <tile>
///
/// * id: The local tile ID within its tileset.
/// * type: The type of the tile. Refers to an object type and is used by tile
///   objects. (optional) (since 1.0)
/// * terrain: Defines the terrain type of each corner of the tile, given as
///   comma-separated indexes in the terrain types array in the order top-left,
///   top-right, bottom-left, bottom-right.
///   Leaving out a value means that corner has no terrain. (optional)
/// * probability: A percentage indicating the probability that this tile is
///   chosen when it competes with others while editing with the terrain tool.
///   (defaults to 0)
///
/// Can contain at most one: <properties>, <image> (since 0.9), <objectgroup>,
/// <animation>.
class Tile with Exportable {
  int localId;
  String? type;
  double probability;

  /// List of indexes of the terrain.
  List<int?> terrain;

  TiledImage? image;
  Rectangle? imageRect;
  Layer? objectGroup;
  List<Frame> animation;
  CustomProperties properties;

  Tile({
    required this.localId,
    this.type,
    this.probability = 0,
    this.terrain = const [],
    this.image,
    this.imageRect,
    this.objectGroup,
    this.animation = const [],
    this.properties = CustomProperties.empty,
  });

  bool get isEmpty => localId == -1;

  /// The "Class" property, a.k.a "Type" prior to Tiled 1.9.
  /// Will be same as [type].
  String? get class_ => type;

  factory Tile.parse(Parser parser) {
    final image = parser.getSingleChildOrNullAs('image', TiledImage.parse);
    final x = parser.getDoubleOrNull('x');
    final y = parser.getDoubleOrNull('y');
    final width = parser.getDoubleOrNull('width');
    final height = parser.getDoubleOrNull('height');

    final imageRect = [image, x, y, width, height].contains(null)
        ? null
        : Rectangle(x!, y!, width!, height!);

    return Tile(
      localId: parser.getInt('id'),

      /// Tiled 1.9 "type" has been moved to "class"
      type: parser.getStringOrNull('class') ?? parser.getStringOrNull('type'),

      probability: parser.getDouble('probability', defaults: 0),
      terrain: parser
              .getStringOrNull('terrain')
              ?.split(',')
              .map((str) => str.isEmpty ? null : int.parse(str))
              .toList() ??
          [],
      image: image,
      imageRect: imageRect,
      objectGroup: parser.getSingleChildOrNullAs('objectgroup', Layer.parse),
      animation: parser.formatSpecificParsing(
        (json) => json.getChildrenAs('animation', Frame.parse),
        (xml) =>
            xml
                .getSingleChildOrNull('animation')
                ?.getChildrenAs('frame', Frame.parse) ??
            [],
      ),
      properties: parser.getProperties(),
    );
  }

  @override
  ExportResolver export() {
    final fields = {
      'id': localId.toExport(),
      'class': type?.toExport(),
      'probability': probability.toExport(),
      'x': imageRect?.left.toExport(),
      'y': imageRect?.top.toExport(),
      'width': imageRect?.width.toExport(),
      'height': imageRect?.height.toExport(),
    }.nonNulls();

    final children = {
      'image': image,
      'objectgroup': objectGroup,
    }.nonNulls();

    return ExportFormatSpecific(
      xml: ExportElement(
        'tile',
        fields,
        {
          ...children,
          if (animation.isNotEmpty)
            'animations': ExportElement(
              'animation',
              {},
              {
                'frames': ExportList.from(animation),
              },
            ),
        },
        properties,
      ),
      json: ExportElement(
        'tile',
        fields,
        {
          ...children,
          'animation': ExportList.from(animation),
        },
        properties,
      ),
    );
  }
}
