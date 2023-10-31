part of tiled;

class ExportSettings {
  final FileEncoding? encoding;
  final Compression? compression;

  ExportSettings({
    required this.encoding,
    required this.compression,
  }) {
    if (compression != null) {
      assert(encoding == FileEncoding.base64);
    }
  }
}
