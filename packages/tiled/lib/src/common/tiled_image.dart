import 'package:meta/meta.dart';
import 'package:tiled/src/parser.dart';

/// Below is Tiled's documentation about how this structure is represented
/// on XML files:
///
/// <image>
///
/// * format: Used for embedded images, in combination with a data child
///   element.
///   Valid values are file extensions like png, gif, jpg, bmp, etc.
/// * source: The reference to the tileset image file (Tiled supports most
///   common image formats). Only used if the image is not embedded.
/// * trans: Defines a specific color that is treated as transparent
///   (example value: “#FF00FF” for magenta).
///   Including the “#” is optional and Tiled leaves it out for compatibility
///   reasons. (optional)
/// * width: The image width in pixels (optional, used for tile index correction
///   when the image changes)
/// * height: The image height in pixels (optional)
@immutable
class TiledImage {
  final String? source;
  final String? format;
  final int? width;
  final int? height;
  final String? trans;

  const TiledImage({
    this.source,
    this.format,
    this.width,
    this.height,
    this.trans,
  });

  TiledImage.parse(Parser parser)
      : this(
          source: parser.getStringOrNull('source'),
          format: parser.getStringOrNull('format'),
          width: parser.getIntOrNull('width'),
          height: parser.getIntOrNull('height'),
          trans: parser.getStringOrNull('trans'),
        );

  /// Needed for getTiledImages in TileMap;
  /// Images are equal if their source is equal.
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TiledImage &&
          runtimeType == other.runtimeType &&
          source == other.source;

  @override
  int get hashCode => source.hashCode;
}
