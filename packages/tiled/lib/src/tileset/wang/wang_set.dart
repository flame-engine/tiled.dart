import 'package:tiled/tiled.dart';

/// Below is Tiled's documentation about how this structure is represented
/// on XML files:
///
/// <wangset>
///
/// Defines a list of corner colors and a list of edge colors, and any number
/// of Wang tiles using these colors.
///
/// name: The name of the Wang set.
/// tile: The tile ID of the tile representing this Wang set.
/// Can contain at most one: <properties>
///
/// Can contain up to 255: <wangcolor> (since Tiled 1.5)
///
/// Can contain any number: <wangtile>
class WangSet {
  String name;
  int tile;
  List<WangColor> cornerColors;
  List<WangColor> edgeColors;
  List<WangTile> wangTiles;
  CustomProperties properties;

  WangSet({
    required this.name,
    required this.tile,
    this.cornerColors = const [],
    this.edgeColors = const [],
    this.wangTiles = const [],
    this.properties = CustomProperties.empty,
  });

  factory WangSet.parse(Parser parser) {
    final colors = parser.formatSpecificParsing(
      (json) => [
        json.getChildrenAs('cornercolors', WangColor.parse),
        json.getChildrenAs('edgecolors', WangColor.parse),
      ],
      (xml) {
        final isCorner = xml.getString('type') == 'corner';
        final colors = xml.getChildrenAs('wangcolor', WangColor.parse);
        return isCorner ? [colors, <WangColor>[]] : [<WangColor>[], colors];
      },
    );
    return WangSet(
      name: parser.getString('name'),
      tile: parser.getInt('tile'),
      cornerColors: colors[0],
      edgeColors: colors[1],
      wangTiles: parser.getChildrenAs('wangtiles', WangTile.parse),
      properties: parser.getProperties(),
    );
  }
}
