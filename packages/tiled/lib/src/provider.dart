import 'package:tiled/tiled.dart';

/// Resolves external files that are referenced from a map, like external
/// tilesets (`.tsx`, `.tsj`) and object templates (`.tx`, `.tj`).
///
/// A list of providers is passed to [TiledMap.parseTmx] or [TiledMap.parseJson]
/// and every time the parser encounters a reference to an external file the
/// first provider that [canProvide] the referenced path is asked for its
/// [Parser] through [getSource].
///
/// The path is passed exactly as it is written in the map file, which means
/// that it is relative to the file that references it. A single provider can
/// therefore resolve any number of files, for example everything below a
/// directory or everything in an asset bundle.
///
/// Caching, if desired, is the responsibility of the provider.
abstract class ParserProvider {
  /// Whether this provider is able to provide a source for [path].
  bool canProvide(String path);

  /// Returns a [Parser] for the external file at [path].
  ///
  /// Only called with paths for which [canProvide] returned true.
  Parser getSource(String path);
}
