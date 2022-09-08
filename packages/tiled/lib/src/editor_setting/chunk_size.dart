part of tiled;

/// Below is Tiled's documentation about how this structure is represented
/// on XML files:
///
/// <chunksize>
///
/// * width: The width of chunks used for infinite maps (default to 16).
/// * height: The width of chunks used for infinite maps (default to 16).
class ChunkSize {
  int width;
  int height;

  ChunkSize({required this.width, required this.height});

  static ChunkSize parse(Parser parser) {
    return ChunkSize(
      width: parser.getInt('width', defaults: 16),
      height: parser.getInt('height', defaults: 16),
    );
  }
}
