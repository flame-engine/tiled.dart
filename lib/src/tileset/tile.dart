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
class Tile {
  int localId;
  String? type;
  double probability;

  /// List of indexes of the terrain.
  List<int> terrain;

  TiledImage? image;
  Layer? objectGroup;
  List<Frame> animation;
  List<Property> properties;

  Tile({
    required this.localId,
    this.type,
    this.probability = 0,
    this.terrain = const [],
    this.image,
    this.objectGroup,
    this.animation = const [],
    this.properties = const [],
  });

  bool get isEmpty => localId == 0;

  static Tile parse(Parser parser) {
    return Tile(
      localId: parser.getInt('id'),
      type: parser.getStringOrNull('type'),
      probability: parser.getDouble('probability', defaults: 0),
      terrain: parser
              .getStringOrNull('terrain')
              ?.split(',')
              .map(int.parse)
              .toList() ??
          [],
      image: parser.getSingleChildOrNullAs('image', TiledImage.parse),
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
}
