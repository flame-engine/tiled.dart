import 'package:tiled/tiled.dart';

/// Resolves external files that are referenced from a map, like external
/// tilesets (`.tsx`, `.tsj`) and object templates (`.tx`, `.tj`).
///
/// A list of providers is passed to [TiledMap.parseTmx] or [TiledMap.parseJson]
/// and every time the parser encounters a reference to an external file the
/// first provider that [canProvide] the referenced path is asked for its
/// [Parser] through [getSource].
///
/// The path is always relative to the map file: a path written in the map is
/// passed exactly as it is written there, and a path written in an external
/// file is joined with the directory of that file first. A single provider
/// can therefore resolve any number of files, for example everything below a
/// directory or everything in an asset bundle.
///
/// Every file is requested at most once per parsed map, so providers only
/// need to cache if the same files are shared between maps.
abstract class ParserProvider {
  /// Whether this provider is able to provide a source for [path].
  bool canProvide(String path);

  /// Returns a [Parser] for the external file at [path].
  ///
  /// Only called with paths for which [canProvide] returned true.
  Parser getSource(String path);
}
