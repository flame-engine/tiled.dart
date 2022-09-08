part of tiled;

/// Below is Tiled's documentation about how this structure is represented
/// on XML files:
///
/// <terrain>
///
/// * name: The name of the terrain type.
/// * tile: The local tile-id of the tile that represents the terrain visually.
///
/// Can contain at most one: <properties>
class Terrain {
  String name;
  int tile;
  List<Property> properties;

  Terrain({
    required this.name,
    required this.tile,
    this.properties = const [],
  });

  Terrain.parse(Parser parser)
      : this(
          name: parser.getString('name'),
          tile: parser.getInt('name'),
          properties: parser.getProperties(),
        );
}
