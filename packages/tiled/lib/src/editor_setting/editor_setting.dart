part of tiled;

/// Below is Tiled's documentation about how this structure is represented
/// on XML files:
///
/// <editorsettings>
/// This element contains various editor-specific settings,
/// which are generally not relevant when reading a map.
///
/// Can contain: <chunksize>, <export>
class EditorSetting {
  ChunkSize? chunkSize;
  Export? export;

  EditorSetting({required this.chunkSize, required this.export});

  static EditorSetting parse(Parser parser) {
    return EditorSetting(
      chunkSize: parser.getSingleChildOrNullAs('chunksize', ChunkSize.parse),
      export: parser.getSingleChildOrNullAs('export', Export.parse),
    );
  }
}
