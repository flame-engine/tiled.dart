part of tiled;

/// A [Gid], Global Tile ID is a Tiled concept to represent the tiles inside
/// int matrices. This wrapper is used by [Layer] and [Chunk] to provide
/// more easy access to the user.
///
/// Normally the integer stored by tiled in those matrixes use bit operations
/// to store two different elements of information:
///
/// * the actual gid, i.e., the global id of the tile on your tileset
/// * flip information
///
/// Each tileset tile placed in the world matrix can have arbitrary flip data.
/// For tiled, Flip includes flips and rotation via the concept of the diagonal
/// flip.
///
/// This class uses the documentation on tile flips below to extract that
/// complexity from the user by using the [Flips] class.
///
/// # Tile flipping
///
/// The highest three bits of the gid store the flipped states:
///
/// * Bit 32 is used for storing whether the tile is horizontally flipped,
/// * Bit 31 is used for the vertically flipped tiles and
/// * Bit 30 indicates whether the tile is flipped (anti) diagonally,
///   enabling tile rotation.
///
/// These bits have to be read and cleared before you can find out which
/// tileset a tile belongs to.
///
/// When rendering a tile, the order of operation matters. The diagonal flip
/// (x/y axis swap) is done first, followed by the horizontal and vertical
/// flips.
class Gid {
  static const int flippedHorizontallyFlag = 0x80000000;
  static const int flippedVerticallyFlag = 0x40000000;
  static const int flippedDiagonallyFlag = 0x20000000;
  static const int flippedAntiDiagonallyFlag = 0x10000000;

  final int tile;
  final Flips flips;

  const Gid(this.tile, this.flips);

  factory Gid.fromInt(int gid) {
    // get flips from id
    final flippedHorizontally =
        (gid & flippedHorizontallyFlag) == flippedHorizontallyFlag;
    final flippedVertically =
        (gid & flippedVerticallyFlag) == flippedVerticallyFlag;
    final flippedDiagonally =
        (gid & flippedDiagonallyFlag) == flippedDiagonallyFlag;
    final flippedAntiDiagonally =
        gid & flippedAntiDiagonallyFlag == flippedAntiDiagonallyFlag;
    // clear id from flips
    final tileId = gid &
        ~(flippedHorizontallyFlag |
            flippedVerticallyFlag |
            flippedDiagonallyFlag |
            flippedAntiDiagonallyFlag);
    final flip = Flips(
      horizontally: flippedHorizontally,
      vertically: flippedVertically,
      diagonally: flippedDiagonally,
      antiDiagonally: flippedAntiDiagonally,
    );
    return Gid(tileId, flip);
  }

  Gid copyWith({
    int? tile,
    Flips? flips,
  }) {
    return Gid(
      tile ?? this.tile,
      flips ?? this.flips,
    );
  }

  static List<List<Gid>> generate(List<int> data, int width, int height) {
    return List.generate(height, (y) {
      return List.generate(width, (x) {
        final gid = data[(y * width) + x];
        return Gid.fromInt(gid);
      });
    });
  }
}
