part of tiled;

class TileData extends DelegatingList<int> implements Exportable {
  TileData(super.base);

  @override
  ExportResolver export(ExportSettings settings) {
    String? data;
    switch (settings.encoding) {
      case null:
        break;
      case FileEncoding.csv:
        data = join(', ');
        break;
      case FileEncoding.base64:
        data = _base64(settings);
        break;
    }

    return ExportFormatSpecific(
      xml: ExportElement('data', {
        if (settings.encoding != null)
          'encoding': settings.encoding!.name.toExport(),
        if (settings.compression != null)
          'compression': settings.compression!.name.toExport(),
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

  String _base64(ExportSettings settings) {
    // Compression
    List<int> compressed;
    switch (settings.compression) {
      case Compression.zlib:
        compressed = const ZLibEncoder().encode(this);
        break;
      case Compression.gzip:
        compressed = GZipEncoder().encode(this)!;
        break;
      case Compression.zstd:
        throw UnsupportedError('zstd is an unsupported compression');
      case null:
        compressed = this;
        break;
    }

    // Conversion to Uint8List
    final uint32 = Uint32List.fromList(compressed);
    final dv = ByteData(compressed.length * 4);

    for (var i = 0; i < compressed.length; ++i) {
      dv.setInt32(i * 4, uint32[i], Endian.little);
    }

    final uint8 = dv.buffer.asUint8List();

    // encoding
    return base64Encode(uint8);
  }
}
