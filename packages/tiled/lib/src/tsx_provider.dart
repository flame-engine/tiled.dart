import 'package:tiled/tiled.dart';

/// abstract class to be implemented for an external tileset data provider.
abstract class TsxProviderBase {
  /// Given a filename this function should check whether this Provider
  /// can provide this source.
  bool checkProvidable(String filename);

  /// Retrieves the external tileset data given the tileset filename.
  Parser getSourceBase(String filename);

  /// Used when provider implementations cache the data. Returns the cached
  /// data for the external tileset by filename.
  Parser? getCachedSourceBase(String filename);
}

/// abstract convenience class to be implemented for an external tileset data
/// provider, which only provides one file and can therefore be matched by the
/// filename alone.
abstract class TsxProvider extends TsxProviderBase {
  /// Unique filename for the tileset to be loaded. This should match the
  /// 'source' property in the map.tmx file. This is used to check if this
  /// Provider can provide a source!
  String get filename;

  @override
  bool checkProvidable(String filename) => filename == this.filename;

  /// Used when provider implementations cache the data. Returns the cached
  /// data for the exernal tileset.
  Parser? getCachedSource();

  @override
  Parser? getCachedSourceBase(String _) => getCachedSource();

  /// Retrieves the external tileset data given the tileset filename.
  Parser getSource(String filename);

  @override
  Parser getSourceBase(String filename) => getSource(filename);

  /// Parses a file returning a [TsxProvider].
  static Future<TsxProvider> parse(String key) {
    throw UnimplementedError();
  }
}
