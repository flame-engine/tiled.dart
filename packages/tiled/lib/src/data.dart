part of tiled;

class TileDataEncoder extends DelegatingList<int> with Exportable {
  final FileEncoding? encoding;
  final Compression? compression;

  TileDataEncoder({
    required List<int> data,
    required this.encoding,
    required this.compression,
  }) : super(data);

  @override
  ExportResolver export() {
    String? data;
    switch (encoding) {
      case null:
        break;
      case FileEncoding.csv:
        data = join(', ');
        break;
      case FileEncoding.base64:
        data = _base64();
        break;
    }

    return ExportFormatSpecific(
      xml: ExportElement('data', {
        if (encoding != null) 'encoding': encoding!.name.toExport(),
        if (compression != null) 'compression': compression!.name.toExport(),
      }, {
        if (data == null)
          'tiles': ExportList(map(
            (gid) => ExportElement(
              'tile',
              {'gid': gid.toExport()},
              {},
            ),
          ))
        else
          'data': data.toExport(),
      }),
      json: ExportLiteral(this),
    );
  }

  String _base64() {
    // Conversion to Uint8List
    final uint32 = Uint32List.fromList(this);
    final dv = ByteData(this.length * 4);

    for (var i = 0; i < this.length; ++i) {
      dv.setInt32(i * 4, uint32[i], Endian.little);
    }

    final uint8 = dv.buffer.asUint8List();

    // Compression
    List<int> compressed;
    print(compression);
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
