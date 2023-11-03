part of tiled;

class Flips {
  final bool horizontally;
  final bool vertically;
  final bool diagonally;
  final bool antiDiagonally;

  const Flips({
    required this.horizontally,
    required this.vertically,
    required this.diagonally,
    required this.antiDiagonally,
  });

  const Flips.defaults()
      : this(
          horizontally: false,
          vertically: false,
          diagonally: false,
          antiDiagonally: false,
        );

  Flips copyWith({
    bool? horizontally,
    bool? vertically,
    bool? diagonally,
    bool? antiDiagonally,
  }) {
    return Flips(
      horizontally: horizontally ?? this.horizontally,
      vertically: vertically ?? this.vertically,
      diagonally: diagonally ?? this.diagonally,
      antiDiagonally: antiDiagonally ?? this.antiDiagonally,
    );
  }
}
