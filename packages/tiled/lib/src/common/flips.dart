part of tiled;

class Flips {
  final bool horizontally;
  final bool vertically;
  final bool diagonally;
  final bool antiDiagonally;

  const Flips(
    this.horizontally,
    this.vertically,
    this.diagonally,
    this.antiDiagonally,
  );

  const Flips.defaults() : this(false, false, false, false);

  Flips copyWith({
    bool? horizontally,
    bool? vertically,
    bool? diagonally,
    bool? antiDiagonally,
  }) {
    return Flips(
      horizontally ?? this.horizontally,
      vertically ?? this.vertically,
      diagonally ?? this.diagonally,
      antiDiagonally ?? this.antiDiagonally,
    );
  }
}
