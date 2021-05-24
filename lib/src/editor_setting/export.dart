part of tiled;

/// Below is Tiled's documentation about how this structure is represented
/// on XML files:
///
/// <export>
///
/// * target: The last file this map was exported to.
/// * format: The short name of the last format this map was exported as.
class Export {
  String format;
  String target;

  Export({
    required this.format,
    required this.target,
  });

  static Export parse(Parser parser) {
    return Export(
      format: parser.getString('format'),
      target: parser.getString('target'),
    );
  }
}
