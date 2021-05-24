part of tiled;

/// Below is Tiled's documentation about how this structure is represented
/// on XML files:
///
/// <chunk>
///
/// * x: The x coordinate of the chunk in tiles.
/// * y: The y coordinate of the chunk in tiles.
/// * width: The width of the chunk in tiles.
/// * height: The height of the chunk in tiles.
///
/// This is currently added only for infinite maps. The contents of a chunk
/// element is same as that of the data element, except it stores the data of
/// the area specified in the attributes.
///
/// The data inside is a compressed (encoded) representation of a list
/// (that sequentially represents a matrix) of integers representing
/// [TileData]s.
class Chunk {
  List<int> data;

  int x;
  int y;

  int width;
  int height;

  /// This is not part of the tiled definitions; this is just a convinient
  /// wrapper over the [data] field that simplifies two things:
  ///
  /// * represents the matrix as a matrix (List<List<X>>) instead of a flat list
  /// * wraps the gid integer into the [Gid] class for easy access of properties
  List<List<Gid>> tileData;

  Chunk({
    required this.data,
    required this.x,
    required this.y,
    required this.height,
    required this.width,
  }) : tileData = Gid.generate(data, width, height);

  static Chunk parse(
    Parser parser,
    FileEncoding encoding,
    Compression? compression,
  ) {
    final data = Layer.parseLayerData(parser, encoding, compression);
    if (data == null) {
      throw ParsingException('chunk', null, 'Chunk must have data');
    }

    final x = parser.getInt('x');
    final y = parser.getInt('y');

    final width = parser.getInt('width');
    final height = parser.getInt('height');

    return Chunk(data: data, x: x, y: y, width: width, height: height);
  }
}
