part of tiled;

/// Export element encoding the tile data
class ExportTileData with Exportable {
  final FileEncoding? encoding;
  final Compression? compression;
  final List<int> data;

  const ExportTileData({
    required this.data,
    required this.encoding,
    required this.compression,
  });

  @override
  ExportResolver export() {
    String? encodedData;
    switch (encoding) {
      case null:
        break;
      case FileEncoding.csv:
        encodedData = encodeCsv();
        break;
      case FileEncoding.base64:
        encodedData = encodeBase64();
        break;
    }

    return ExportFormatSpecific(
      xml: ExportElement(
        'data',
        {
          if (encoding != null) 'encoding': encoding!.name.toExport(),
          if (compression != null) 'compression': compression!.name.toExport(),
        },
        {
          if (encodedData == null)
            'tiles': exportTiles()
          else
            'data': encodedData.toExport(),
        },
      ),
      json: ExportLiteral(data),
    );
  }

  /// Exports tiles for xml elements
  ExportList exportTiles() => ExportList(
        data.map(
          (gid) => ExportElement(
            'tile',
            {'gid': gid.toExport()},
            {},
          ),
        ),
      );

  /// Encodes tiles as csv
  String encodeCsv() => data.join(', ');

  /// Encodes tiles as base64
  String encodeBase64() {
    // Conversion to Uint8List
    final uint32 = Uint32List.fromList(data);
    final uint8 = uint32.buffer.asUint8List();

    // Compression
    List<int> compressed;
    switch (compression) {
      case Compression.zlib:
        compressed = const ZLibEncoder().encode(uint8);
        break;
      case Compression.gzip:
        compressed = GZipEncoder().encode(uint8)!;
        break;
      case Compression.zstd:
        throw UnsupportedError('zstd is an unsupported compression');
      case null:
        compressed = uint8;
        break;
    }

    // encoding
    return base64Encode(compressed);
  }
}
