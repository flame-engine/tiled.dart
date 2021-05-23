part of tiled;

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

  static Terrain parse(Parser parser) {
    return Terrain(
      name: parser.getString('name'),
      tile: parser.getInt('name'),
      properties: parser.getProperties(),
    );
  }
}
