part of tiled;

class Flips {
  final bool horizontally;
  final bool vertically;
  final bool diagonally;

  const Flips(this.horizontally, this.vertically, this.diagonally);

  const Flips.defaults() : this(false, false, false);

  Flips copyWith({
    bool horizontally = null,
    bool vertically = null,
    bool diagonally = null,
  }) {
    return Flips(
      horizontally ?? this.horizontally,
      vertically ?? this.vertically,
      diagonally ?? this.diagonally,
    );
  }
}