part of tiled;

/// Below is Tiled's documentation about how this structure is represented
/// on XML files:
///
/// <wangcolor>
/// A color that can be used to define the corner and/or edge of a Wang tile.
///
/// * name: The name of this color.
/// * color: The color in #RRGGBB format (example: #c17d11).
/// * tile: The tile ID of the tile representing this color.
/// * probability: The relative probability that this color is chosen over
///   others in case of multiple options. (defaults to 0)
///
/// Can contain at most one: <properties>
class WangColor {
  String name;
  String color;
  int tile;
  double probability;

  List<Property> properties;

  WangColor({
    required this.name,
    required this.color,
    required this.tile,
    this.probability = 0,
    this.properties = const [],
  });

  WangColor.parse(Parser parser)
      : this(
          name: parser.getString('name'),
          color: parser.getString('color'),
          tile: parser.getInt('tile'),
          probability: parser.getDouble('probability', defaults: 0),
          properties: parser.getProperties(),
        );
}
