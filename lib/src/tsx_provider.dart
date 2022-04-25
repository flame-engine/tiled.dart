part of tiled;

/// abstract class to be implemented for an external tileset data provider.
abstract class TsxProvider {
  /// Unique filename for the tileset to be loaded. This should match the
  /// 'source' property in the map.tmx file.
  String get filename;

  /// Retrieves the external tileset data given the tileset filename.
  Parser getSource(String filename);

  /// Used when provider implementations cache the data. Returns the cached
  /// data for the exernal tileset.
  Parser? getCachedSource();

  /// Parses a file returning a [TsxProvider].
  static Future<TsxProvider> parse(String key) {
    throw UnimplementedError();
  }
}
